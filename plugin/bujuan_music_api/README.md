# 不卷音乐API (Bujuan Music API)

[![Pub Version](https://img.shields.io/badge/pub-v1.0.0-blue)](https://pub.dev)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

一个完整的网易云音乐API Flutter插件，支持所有主要功能。本插件从[不卷音乐](https://github.com/2697a/bujuan)项目提取，**专为API不可用的分支设计**。

## ✨ 特性

- 🔐 **完整的登录支持** - 手机号、邮箱、二维码登录
- 🎵 **音乐播放** - 获取歌曲URL、歌词、详情
- 🔍 **搜索功能** - 搜索歌曲、专辑、歌手、歌单
- 📝 **歌单管理** - 创建、删除、更新歌单
- 👤 **用户信息** - 获取用户资料、喜欢列表
- 🎙️ **电台支持** - 电台节目、订阅
- 📱 **动态功能** - 查看、发布动态
- 🔒 **自动加密** - 支持WeApi、EApi、LinuxForward三种加密方式
- 🍪 **Cookie管理** - 自动处理登录态
- ♻️ **Token刷新** - 自动刷新过期Token

## 📦 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  bujuan_music_api:
    path: ../plugin/bujuan_music_api  # 本地路径
    # 或使用 git 依赖
    # git:
    #   url: https://github.com/YOUR_REPO/bujuan_music_api.git
```

然后运行：

```bash
flutter pub get
```

## 🚀 快速开始

### 1. 初始化

```dart
import 'package:bujuan_music_api/bujuan_music_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化API（必须在使用前调用）
  await BujuanMusicManager.init(
    debug: true,  // 开启调试日志
  );

  runApp(MyApp());
}
```

### 2. 基础使用

```dart
class MusicService {
  final _api = BujuanMusicManager();

  // 手机号登录
  Future<void> login(String phone, String password) async {
    try {
      var result = await _api.loginCellPhone(phone, password);
      if (result.code == RET_CODE_OK) {
        print('登录成功: ${result.profile?.nickname}');
      }
    } catch (e) {
      print('登录失败: $e');
    }
  }

  // 搜索歌曲
  Future<void> searchSongs(String keyword) async {
    var result = await _api.search(keyword, type: SearchType.Song);
    if (result.code == RET_CODE_OK) {
      result.result?.songs?.forEach((song) {
        print('${song.name} - ${song.artists?.first.name}');
      });
    }
  }

  // 获取歌曲播放URL
  Future<String?> getSongUrl(int songId) async {
    var result = await _api.songUrl([songId]);
    return result.data?.first.url;
  }

  // 获取用户歌单
  Future<void> getUserPlaylists(int uid) async {
    var result = await _api.userPlaylist(uid);
    result.playlist?.forEach((playlist) {
      print('歌单: ${playlist.name}');
    });
  }
}
```

### 3. 监听登录状态

```dart
void setupLoginListener() {
  var manager = BujuanMusicManager();

  manager.usc.listenLoginState((state, accountInfo) {
    switch (state) {
      case LoginState.Logined:
        print('已登录: ${accountInfo?.profile?.nickname}');
        break;
      case LoginState.Logout:
        print('未登录');
        break;
    }
  });
}
```

## 📖 API文档

### 登录相关

```dart
var api = BujuanMusicManager();

// 手机号登录
await api.loginCellPhone('13800138000', 'password');

// 邮箱登录
await api.loginEmail('email@example.com', 'password');

// 二维码登录
var qrKey = await api.loginQrCodeKey();
String qrUrl = api.loginQrCodeUrl(qrKey.unikey!);
// 显示二维码，轮询检查登录状态
var checkResult = await api.loginQrCodeCheck(qrKey.unikey!);

// 退出登录
await api.logout();

// 刷新登录Token
await api.loginRefresh();
```

### 用户相关

```dart
// 获取用户详情
await api.userDetail(userId);

// 获取用户歌单
await api.userPlaylist(userId);

// 获取喜欢列表
await api.likeList(userId);

// 签到
await api.dailySignin();
```

### 音乐播放

```dart
// 获取歌曲URL
await api.songUrl([songId1, songId2], level: 'exhigh');

// 获取歌曲详情
await api.songDetail([songId]);

// 获取歌词
await api.lyric(songId);

// 喜欢音乐
await api.like(songId, true);

// 检查是否喜欢
await api.likeCheck([songId]);
```

### 搜索功能

```dart
// 搜索歌曲
await api.search('歌曲名', type: SearchType.Song);

// 搜索歌手
await api.search('歌手名', type: SearchType.Artist);

// 搜索歌单
await api.search('歌单名', type: SearchType.Playlist);

// 搜索专辑
await api.search('专辑名', type: SearchType.Album);
```

### 歌单管理

```dart
// 创建歌单
await api.playlistCreate('我的歌单');

// 删除歌单
await api.playlistDelete(playlistId);

// 更新歌单信息
await api.playlistUpdate(playlistId, name: '新名称', desc: '描述');

// 获取歌单详情
await api.playlistDetail(playlistId);

// 添加歌曲到歌单
await api.playlistTracks(TrackOperate.add, playlistId, [songId]);

// 从歌单移除歌曲
await api.playlistTracks(TrackOperate.del, playlistId, [songId]);
```

### 推荐功能

```dart
// 每日推荐歌曲
await api.recommendSongs();

// 每日推荐歌单
await api.recommendResource();

// 推荐新音乐
await api.personalizedNewsong();
```

## 🏗️ 架构设计

插件采用**Mixin组合模式**，核心类 `BujuanMusicManager` 组合了所有API模块：

```
BujuanMusicManager
├── ApiLogin      (登录相关)
├── ApiUser       (用户相关)
├── ApiPlay       (播放相关)
├── ApiSearch     (搜索相关)
├── ApiDj         (电台相关)
├── ApiEvent      (动态相关)
└── ApiUncategorized (其他)
```

### 加密处理

插件支持网易云音乐的三种加密方式：

1. **WeApi** - 网页端加密（默认）
2. **EApi** - 移动端加密
3. **LinuxForward** - Linux客户端转发

所有加密细节由拦截器自动处理，开发者无需关心。

### 状态管理

- `UserLoginStateController` - 管理登录状态
- 自动保存/读取账号信息
- 支持登录状态监听
- 自动处理Token过期

## ⚠️ 注意事项

1. **初始化**：必须在使用API前调用 `BujuanMusicManager.init()`
2. **密码加密**：密码需要传入MD5加密后的十六进制字符串
3. **Cookie持久化**：登录态自动保存，重启应用后仍然有效
4. **Token刷新**：Token过期时会自动刷新，无需手动处理
5. **网络请求**：所有API都是异步的，建议使用 try-catch 处理异常

## 🔧 高级配置

### 自定义路径提供器

```dart
class MyPathProvider extends PathProvider {
  @override
  Future<void> init() async {
    _cookiePath = '/custom/cookie/path/';
    _dataPath = '/custom/data/path/';
  }
}

await BujuanMusicManager.init(
  provider: MyPathProvider(),
);
```

### 自定义Dio配置

```dart
import 'package:bujuan_music_api/src/common/dio_ext.dart';

// 在init之前配置
Https.optHeader['Custom-Header'] = 'value';

await BujuanMusicManager.init();
```

## 🐛 常见问题

### Q: 登录返回301（需要登录）
A: Token可能过期，调用 `loginRefresh()` 或重新登录。

### Q: 部分歌曲无法播放
A: 可能是版权问题，尝试更换音质level或使用VIP账号。

### Q: 二维码登录一直pending
A: 需要轮询调用 `loginQrCodeCheck()` 检查扫码状态。

### Q: Web平台Cookie问题
A: Web平台Cookie存储在浏览器中，关闭页面后可能丢失。

## 📄 协议

MIT License - 详见 [LICENSE](LICENSE)

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📮 联系

- 项目主页: [不卷音乐](https://github.com/2697a/bujuan)
- Issues: [提交问题](https://github.com/2697a/bujuan/issues)

## 🙏 致谢

本插件基于[不卷音乐](https://github.com/2697a/bujuan)项目提取，感谢原作者的贡献！

---

**注意**: 本插件仅供学习交流使用，请遵守网易云音乐相关协议。
