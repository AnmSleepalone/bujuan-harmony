/// API返回码常量定义
const int RET_CODE_UNKNOW = -233;
const int RET_CODE_OK = 200;
const int RET_CODE_NO_PERMISSION = -2;
const int RET_CODE_OK_FOLLOW = 201;
const int RET_CODE_RISK_WARNING = 250;
const int RET_CODE_CHEATING = -460;
const int RET_CODE_NEED_LOGIN = 301;
const int RET_CODE_ILLEGAL = 400;
const int RET_CODE_ILLEGAL_REQUEST = 403;
const int RET_CODE_REQUEST_NOT_FOUNT = 404;
const int RET_CODE_HAS_INIT = 408;
const int RET_CODE_ACCOUNT_NOT_FOUND = 501;
const int RET_CODE_UPDATE_PROFILE_OCCUPY = 505;
const int RET_CODE_CAPTCHA_VERIFY_FAIL = 503;
const int RET_CODE_CAPTCHA_VERIFY_FREQUENTLY = 405;
const int RET_CODE_UNPAID = 512;

/// API返回码枚举
enum RetCode {
  Ok,
  NeedLogin,
  IllegalArgument,
  IllegalRequest,
  RequestNotFount,
  UnKnow
}

/// 将整数返回码转换为枚举
RetCode valueOfCode(int code) {
  switch (code) {
    case RET_CODE_OK:
      return RetCode.Ok;
    case RET_CODE_NEED_LOGIN:
      return RetCode.NeedLogin;
    case RET_CODE_ILLEGAL:
      return RetCode.IllegalArgument;
    case RET_CODE_ILLEGAL_REQUEST:
      return RetCode.IllegalRequest;
    case RET_CODE_REQUEST_NOT_FOUNT:
      return RetCode.RequestNotFount;
  }
  return RetCode.UnKnow;
}

/// API相关常量
const String TAG = 'BujuanMusicApi';
const String HOST = 'https://music.163.com';
const HOSTS = [
  'music.163.com',
  'interface.music.163.com',
  'interface3.music.163.com'
];

/// 加密类型
enum EncryptType { LinuxForward, WeApi, EApi }

/// User Agent类型
enum UserAgent { Random, Pc, Mobile }

/// User Agent列表
const userAgentList = [
  'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1',
  'Mozilla/5.0 (iPhone; CPU iPhone OS 9_1 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13B143 Safari/601.1',
  'Mozilla/5.0 (Linux; Android 5.0; SM-G900P Build/LRX21T) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
  'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
  'Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Mobile Safari/537.36',
  'Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_2 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Mobile/14F89;GameHelper',
  'Mozilla/5.0 (iPhone; CPU iPhone OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1',
  'Mozilla/5.0 (iPad; CPU OS 10_0 like Mac OS X) AppleWebKit/602.1.38 (KHTML, like Gecko) Version/10.0 Mobile/14A300 Safari/602.1',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:46.0) Gecko/20100101 Firefox/46.0',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:46.0) Gecko/20100101 Firefox/46.0',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36 Edge/13.10586'
];
