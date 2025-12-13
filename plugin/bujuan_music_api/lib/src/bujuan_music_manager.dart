import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api/dj/api.dart';
import 'api/event/api.dart';
import 'api/login/api.dart';
import 'api/login/bean.dart';
import 'api/play/api.dart';
import 'api/search/api.dart';
import 'api/uncategorized/api.dart';
import 'api/user/api.dart';
import 'common/bean.dart';
import 'common/constants.dart';
import 'common/dio_ext.dart';
import 'handler/interceptor.dart';

/// 不卷音乐API管理器
/// 使用mixin模式组合各个API模块
class BujuanMusicManager
    with
        ApiPlay,
        ApiDj,
        ApiLogin,
        ApiUser,
        ApiEvent,
        ApiSearch,
        ApiUncategorized {
  static BujuanMusicManager? _instance;

  static late CookieManager _cookieManager;
  static late CookieJar _cookieJar;
  static late PathProvider _pathProvider;

  /// 用户登录状态控制器
  UserLoginStateController usc = UserLoginStateController();

  BujuanMusicManager._internal() {
    usc.init();
  }

  factory BujuanMusicManager() {
    return _instance ??= BujuanMusicManager._internal();
  }

  /// 初始化API
  /// [provider] 路径提供器，用于保存Cookie和用户数据
  /// [debug] 是否开启调试模式（打印详细日志）
  static Future<bool> init({
    PathProvider? provider,
    bool debug = false,
  }) async {
    provider ??= PathProvider();
    _pathProvider = provider;

    await provider.init();

    _cookieJar = PersistCookieJar(
      storage: FileStorage(provider.getCookieSavedPath()),
    );
    _cookieManager = CookieManager(_cookieJar);

    _initDio(Https.dio, debug, true);

    return true;
  }

  /// 初始化Dio拦截器
  static Dio _initDio(Dio dio, bool debug, bool refreshToken) {
    dio.interceptors.add(_cookieManager);

    // 添加请求拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        neteaseInterceptor(options, handler, _cookieJar);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) async {
        var requestOptions = response.requestOptions;

        // 处理JSON解析
        if (response.data is String) {
          try {
            response.data = jsonDecode(response.data);
          } catch (e) {}
        }

        // Token自动刷新逻辑
        if (refreshToken &&
            BujuanMusicManager().usc.isLogined &&
            response.data is Map) {
          var result = ServerStatusBean.fromJson(response.data);
          if (result.code == RET_CODE_NEED_LOGIN) {
            try {
              // Token过期，尝试刷新
              var refreshResult = await BujuanMusicManager()
                  .loginRefresh(dio: _initDio(Dio(), debug, false));
              if (refreshResult.code == RET_CODE_OK) {
                var newResponse = await dio.fetch(requestOptions);
                handler.next(newResponse);
                return;
              }
            } catch (e) {}
            // 刷新失败，退出登录
            await BujuanMusicManager().usc.onLogout();
          }
        }

        handler.next(response);
      },
    ));

    // 添加日志拦截器（调试模式）
    if (debug) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
        logPrint: (object) {
          if (object is String) {
            print(object.replaceAll('║', ''));
          }
        },
      ));
    }
    return dio;
  }

  /// 获取CookieJar（用于高级操作）
  static CookieJar get cookieJar => _cookieJar;

  /// 获取PathProvider
  static PathProvider get pathProvider => _pathProvider;
}

/// 用户登录状态控制器
class UserLoginStateController {
  LoginState? _curLoginState;
  StreamController? _controller;
  NeteaseAccountInfoWrap? _accountInfo;
  AnonimousLoginRet? _anonimousLoginRet;

  UserLoginStateController();

  Future<void> init() async {
    _checkCreateSavePath();
    await _readAccountInfo();
    var cookies = await _loadCookies();
    _refreshLoginState(
      cookies.isNotEmpty && _accountInfo != null
          ? LoginState.Logined
          : LoginState.Logout,
    );
  }

  /// 当前账号信息
  NeteaseAccountInfoWrap? get accountInfo => _accountInfo;

  /// 匿名登录信息
  AnonimousLoginRet? get anonimousLoginInfo {
    if (accountInfo != null) {
      _anonimousLoginRet = null;
    }
    return _anonimousLoginRet;
  }

  /// 是否已登录
  bool get isLogined => _curLoginState == LoginState.Logined;

  /// 监听登录状态变化
  StreamSubscription listenLoginState(
    void Function(LoginState event, NeteaseAccountInfoWrap? accountInfoWrap)
        onChange,
  ) {
    var controller = _controller;
    if (controller == null) {
      _controller = controller = StreamController.broadcast(sync: true);
    }
    return controller.stream.listen((t) {
      onChange(t, accountInfo);
    });
  }

  /// 登录成功回调
  void onLogined(NeteaseAccountInfoWrap infoWrap) {
    _accountInfo = infoWrap;
    _refreshLoginState(LoginState.Logined);
    _saveAccountInfo(infoWrap);
  }

  /// 匿名登录成功回调
  void onAnonimousLogined(AnonimousLoginRet anonimousLoginRet) {
    _anonimousLoginRet = anonimousLoginRet;
  }

  /// 退出登录
  Future<void> onLogout() async {
    await deleteAllCookie(BujuanMusicManager.cookieJar);
    _accountInfo = null;
    _saveAccountInfo(null);
    _refreshLoginState(LoginState.Logout);
  }

  void _saveAccountInfo(NeteaseAccountInfoWrap? infoWrap) {
    _saveFile().writeAsString(jsonEncode(infoWrap), flush: true);
  }

  Future<void> _readAccountInfo() async {
    try {
      var accountInfo = _saveFile().readAsStringSync();
      _accountInfo = NeteaseAccountInfoWrap.fromJson(jsonDecode(accountInfo));
    } catch (e) {
      print('读取登录信息失败');
      await onLogout();
    }
  }

  File _saveFile() => File(
      BujuanMusicManager.pathProvider.getDataSavedPath() + "_accountInfo.json");

  void _checkCreateSavePath() {
    var file = _saveFile();
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
  }

  void _refreshLoginState(LoginState state) {
    var controller = _controller;
    if (controller != null && _curLoginState != state) {
      controller.add(state);
    }
    _curLoginState = state;
  }

  Future<List<Cookie>> _loadCookies() async {
    return BujuanMusicManager.cookieJar
        .loadForRequest(Uri.parse(HOST));
  }

  void destroy() {
    _controller?.close();
  }
}

/// 登录状态枚举
enum LoginState {
  Logined,
  Logout,
}

/// 路径提供器
/// 用于提供Cookie和数据存储路径
class PathProvider {
  var _cookiePath = '';
  var _dataPath = '';

  Future<void> init() async {
    if (kIsWeb) return;
    _cookiePath =
        "${(await getApplicationSupportDirectory()).absolute.path}/bujuan_music/.cookies/";
    _dataPath =
        "${(await getApplicationSupportDirectory()).absolute.path}/bujuan_music/.data/";
  }

  String getCookieSavedPath() => _cookiePath;
  String getDataSavedPath() => _dataPath;
}
