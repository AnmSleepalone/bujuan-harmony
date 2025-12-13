library bujuan_music_api;

/// 不卷音乐API - 网易云音乐API Flutter插件
///
/// 这是一个完整的网易云音乐API客户端，支持：
/// - 登录（手机号、邮箱、二维码）
/// - 用户信息管理
/// - 歌曲播放、搜索
/// - 歌单管理
/// - 电台、动态等
///
/// 使用示例：
/// ```dart
/// // 1. 初始化
/// await BujuanMusicManager.init(debug: true);
///
/// // 2. 使用API
/// var manager = BujuanMusicManager();
///
/// // 登录
/// var result = await manager.loginCellPhone('手机号', '密码');
///
/// // 搜索歌曲
/// var songs = await manager.search('歌曲名称');
///
/// // 获取歌曲URL
/// var url = await manager.songUrl([歌曲ID]);
/// ```

export 'src/bujuan_music_manager.dart';

// 导出Bean类（用于类型引用）
export 'src/api/login/bean.dart';
export 'src/api/user/bean.dart';
export 'src/api/play/bean.dart';
export 'src/api/search/bean.dart';
export 'src/api/dj/bean.dart';
export 'src/api/event/bean.dart';
export 'src/api/uncategorized/bean.dart';
export 'src/common/bean.dart';
export 'src/common/constants.dart';
