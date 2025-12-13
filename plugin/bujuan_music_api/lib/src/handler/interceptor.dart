import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:pointycastle/digests/md5.dart';
import 'package:pointycastle/export.dart' hide Algorithm;

import '../common/constants.dart';
import '../common/dio_ext.dart';
import 'encrypt_handler.dart';

/// 网易云音乐API请求拦截器
/// 处理加密、Cookie、Header等
void neteaseInterceptor(
    RequestOptions option, RequestInterceptorHandler handler, CookieJar cookieJar) async {
  if (option.method == 'POST' &&
      HOSTS.contains(option.uri.host) &&
      option.extra['hookRequestData']) {
    option.contentType = Headers.formUrlEncodedContentType;
    option.headers[HttpHeaders.refererHeader] = HOST;

    var realIP = option.extra['realIP'];
    if (realIP != null) {
      option.headers['X-Real-IP'] = realIP;
    }
    option.headers[HttpHeaders.userAgentHeader] =
        _chooseUserAgent(option.extra['userAgent']);

    var cookies = await _loadCookies(cookieJar, host: option.uri);

    var cookiesSb = StringBuffer(CookieManager.getCookies(cookies));
    option.extra['cookies'].forEach((key, value) {
      cookiesSb
          .write(' ;${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}');
    });
    option.headers[HttpHeaders.cookieHeader] = cookiesSb.toString();
    option.extra['cookiesHash'] = await _loadCookiesHash(cookieJar, cookies: cookies);

    if (!(option.extra['hookRequestDataSuccess'] ?? false)) {
      switch (option.extra['encryptType']) {
        case EncryptType.LinuxForward:
          _handleLinuxForward(option);
          break;
        case EncryptType.WeApi:
          _handleWeApi(option);
          break;
        case EncryptType.EApi:
          _handleEApi(option, cookies);
          break;
      }
      option.extra['hookRequestDataSuccess'] = true;
    }
  }
  handler.next(option);
}

const _BASE62 =
    'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
const String _presetKeyLinuxForward = 'rFgB&h#%2?^eDg:Q';

/// Linux Forward 加密处理
void _handleLinuxForward(RequestOptions option) {
  var oldUriStr = option.uri.toString();

  option.path = Uri(
          scheme: option.uri.scheme,
          host: option.uri.host,
          path: 'api/linux/forward')
      .toString();

  var newData = {
    'method': option.method,
    'url': oldUriStr.replaceAll(RegExp(r'\w*api'), 'api'),
    'params': option.data
  };

  final key = Key.fromUtf8(_presetKeyLinuxForward);
  final encrypter = Encrypter(AES(key, mode: AESMode.ecb));
  final encrypted = encrypter.encrypt(jsonEncode(newData));

  option.data = 'eparams=${Uri.encodeQueryComponent(encrypted.base16)}';
}

const _presetKeyWeApi = '0CoJUm6Qyw8W8jud';
const _ivWeApi = '0102030405060708';
const _publicKeyWeApi =
    '-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgtQn2JZ34ZC28NWYpAUd98iZ37BUrX/aKzmFbt7clFSs6sXqHauqKWqdtLkF2KexO40H1YTX8z2lSgBBOAxLsvaklV8k4cBFK9snQXE9/DDaFt6Rr7iVZMldczhC0JNgTz+SHXT6CBHuX3e9SdB1Ua44oncaTWz7OBGLbCiK45wIDAQAB\n-----END PUBLIC KEY-----';

/// WeApi 加密处理
void _handleWeApi(RequestOptions option) {
  var oldUriStr = option.uri.toString();
  option.path = oldUriStr.replaceAll(RegExp(r'\w*api'), 'weapi');

  // weApi方式请求body里面需要带上csrfToken字段
  String csrfToken = '';
  try {
    csrfToken = RegExp(r'_csrf=([^(;|$)]+)')
            .firstMatch(option.headers[HttpHeaders.cookieHeader] ?? '')
            ?.group(1) ??
        '';
  } catch (e) {}
  if (csrfToken.isNotEmpty) {
    option.data = Map.from(option.data);
    option.data['csrf_token'] = csrfToken;
  }

  String body = jsonEncode(option.data);

  // 1. 固定密钥加密原始数据
  final key = Key.fromUtf8(_presetKeyWeApi);
  final iv = IV.fromUtf8(_ivWeApi);
  final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(body, iv: iv);

  // 2. 生成一个16位密钥A
  Uint8List randomKeyBytes = Uint8List.fromList(List.generate(16, (int index) {
    return _BASE62.codeUnitAt(Random().nextInt(62));
  }));

  // 3. 用密钥A再次加密步骤1的结果
  final key2 = Key(randomKeyBytes);
  final encrypterBody = Encrypter(AES(key2, mode: AESMode.cbc));
  final encryptedBody = encrypterBody.encrypt(encrypted.base64, iv: iv);

  // 4. RSA加密密钥A
  final parser = RSAKeyParser();
  final encrypter3 = Encrypter(
      RSAExt(publicKey: parser.parse(_publicKeyWeApi) as RSAPublicKey?));
  final encrypted3 =
      encrypter3.encryptBytes(List.from(randomKeyBytes.reversed));

  // 5. 组合结果
  option.data =
      'params=${Uri.encodeQueryComponent(encryptedBody.base64)}&encSecKey=${Uri.encodeQueryComponent(encrypted3.base16)}';
}

const _KeyEApi = 'e82ckenh8dichen8';

/// EApi 加密处理
void _handleEApi(RequestOptions option, List<Cookie> cookies) {
  var oldUriStr = option.uri.toString();
  option.path = oldUriStr.replaceAll(RegExp(r'\w*api'), 'eapi');

  var header = <String, dynamic>{};
  Map<String, String> cookiesMap =
      cookies.fold(<String, String>{}, (map, element) {
    map[element.name] = element.value;
    return map;
  });
  header['osver'] = cookiesMap['osver'];
  header['deviceId'] = cookiesMap['deviceId'];
  header['appver'] = cookiesMap['appver'] ?? '8.0.00';
  header['versioncode'] = cookiesMap['versioncode'] ?? '140';
  header['mobilename'] = cookiesMap['mobilename'];
  header['buildver'] =
      cookiesMap['mobilename'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
  header['resolution'] = cookiesMap['resolution'] ?? '1920x1080';
  header['os'] = cookiesMap['os'] ?? 'android';
  header['channel'] = cookiesMap['channel'];
  header['__csrf'] = cookiesMap['__csrf'] ?? '';
  if (cookiesMap['MUSIC_U'] != null) {
    header['MUSIC_U'] = cookiesMap['MUSIC_U'];
  }
  if (cookiesMap['MUSIC_A'] != null) {
    header['MUSIC_A'] = cookiesMap['MUSIC_A'];
  }
  header['requestId'] =
      '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(1000).toString().padLeft(4, '0')}';

  option.data = Map.from(option.data);
  option.data['header'] = header;

  var url = option.extra['eApiUrl'];
  var body = jsonEncode(option.data);
  var message = 'nobody${url}use${body}md5forencrypt';
  var digest =
      Encrypted(MD5Digest().process(Uint8List.fromList(utf8.encode(message))))
          .base16;
  var data = '$url-36cd479b6b5-$body-36cd479b6b5-$digest';

  final encrypted = Encrypter(AES(Key.fromUtf8(_KeyEApi), mode: AESMode.ecb))
      .encrypt(data, iv: IV.fromLength(0))
      .base16
      .toUpperCase();

  option.data = 'params=${Uri.encodeComponent(encrypted)}';
}

/// 选择User Agent
String _chooseUserAgent(UserAgent agent) {
  var random = Random();
  switch (agent) {
    case UserAgent.Random:
      return userAgentList[random.nextInt(userAgentList.length)];
    case UserAgent.Pc:
      return userAgentList[random.nextInt(5) + 8];
    case UserAgent.Mobile:
      return userAgentList[random.nextInt(7)];
  }
}

/// 创建请求Options
Options joinOptions({
  hookRequestDate = true,
  EncryptType encryptType = EncryptType.WeApi,
  UserAgent userAgent = UserAgent.Random,
  Map<String, String> cookies = const {},
  String eApiUrl = '',
  String? realIP,
}) =>
    Options(contentType: ContentType.json.value, extra: {
      'hookRequestData': hookRequestDate,
      'encryptType': encryptType,
      'userAgent': userAgent,
      'cookies': cookies,
      'eApiUrl': eApiUrl,
      'realIP': realIP
    });

/// 拼接URI
Uri joinUri(String path) {
  return Uri.parse('$HOST$path');
}

/// 加载Cookies
Future<List<Cookie>> _loadCookies(CookieJar cookieJar, {Uri? host}) async {
  host ??= Uri.parse(HOST);
  return cookieJar.loadForRequest(host);
}

/// 计算Cookies哈希
Future<int> _loadCookiesHash(CookieJar cookieJar, {List<Cookie>? cookies}) async {
  cookies ??= await _loadCookies(cookieJar);
  return Object.hashAll(cookies.map((e) => e.toString()));
}


/// 删除所有Cookie
Future<void> deleteAllCookie(CookieJar cookieJar) async {
  try {
    await (cookieJar as PersistCookieJar).deleteAll();
  } catch (e) {
    // 忽略删除失败
  }
}
