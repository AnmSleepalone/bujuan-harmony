# 🎵 不卷音乐API插件 - 完整指南

## 📦 插件概览

`bujuan_music_api` 是从不卷音乐项目提取的完整网易云音乐API客户端，包含：

- ✅ **7个API模块** - Login, User, Play, Search, DJ, Event, Uncategorized
- ✅ **3种加密方式** - WeApi, EApi, LinuxForward
- ✅ **自动Token刷新** - 无需手动处理
- ✅ **登录状态管理** - 自动保存/恢复
- ✅ **完整的Cookie管理** - 自动持久化
- ✅ **详细的错误处理** - 完善的异常机制
- ✅ **调试日志支持** - 方便开发调试

## 🚀 快速集成（3步）

### 步骤1: 添加依赖

在主项目的 `pubspec.yaml` 中：

```yaml
dependencies:
  bujuan_music_api:
    path: plugin/bujuan_music_api
```

### 步骤2: 初始化

在 `main.dart` 中：

```dart
import 'package:bujuan_music_api/bujuan_music_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 必须在使用前初始化
  await BujuanMusicManager.init(debug: kDebugMode);

  runApp(MyApp());
}
```

### 步骤3: 使用API

```dart
class MusicController {
  final api = BujuanMusicManager();

  // 登录
  Future<bool> login(String phone, String password) async {
    try {
      var result = await api.loginCellPhone(phone, password);
      return result.code == RET_CODE_OK;
    } catch (e) {
      return false;
    }
  }

  // 搜索
  Future<List<Song>> search(String keyword) async {
    var result = await api.search(keyword, type: SearchType.Song);
    return result.result?.songs ?? [];
  }
}
```

## 📚 核心功能详解

### 1. 登录功能

#### 手机号登录
```dart
// 密码需要MD5加密
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/digests/md5.dart';

String encryptPassword(String password) {
  return Encrypted(MD5Digest().process(
    Uint8List.fromList(utf8.encode(password))
  )).base16;
}

var result = await api.loginCellPhone(
  '13800138000',
  encryptPassword('password'),
);
```

#### 二维码登录（完整流程）
```dart
Future<void> loginWithQrCode() async {
  // 1. 获取二维码key
  var keyResult = await api.loginQrCodeKey();
  if (keyResult.code != RET_CODE_OK) return;

  // 2. 显示二维码
  String qrUrl = api.loginQrCodeUrl(keyResult.unikey!);
  showQrCode(qrUrl); // 你的显示二维码方法

  // 3. 轮询检查状态
  Timer.periodic(Duration(seconds: 2), (timer) async {
    var result = await api.loginQrCodeCheck(keyResult.unikey!);

    switch (result.code) {
      case 800: // 二维码过期
        timer.cancel();
        showMessage('二维码已过期');
        break;
      case 801: // 等待扫码
        break;
      case 802: // 等待确认
        showMessage('请在手机上确认登录');
        break;
      case 803: // 登录成功
        timer.cancel();
        showMessage('登录成功');
        break;
    }
  });
}
```

#### 监听登录状态
```dart
void setupLoginListener() {
  api.usc.listenLoginState((state, accountInfo) {
    if (state == LoginState.Logined) {
      print('已登录: ${accountInfo?.profile?.nickname}');
      // 更新UI
    } else {
      print('未登录');
      // 跳转登录页
    }
  });
}
```

### 2. 音乐播放

#### 获取歌曲URL
```dart
// 支持多种音质: standard, higher, exhigh, lossless, hires
Future<String?> getSongUrl(int songId, {String quality = 'exhigh'}) async {
  var result = await api.songUrl([songId], level: quality);
  return result.data?.first.url;
}
```

#### 获取歌曲详情
```dart
var result = await api.songDetail([songId]);
var song = result.songs?.first;
print('歌名: ${song?.name}');
print('歌手: ${song?.ar?.first.name}');
print('专辑: ${song?.al?.name}');
```

#### 获取歌词
```dart
var result = await api.lyric(songId);
print('歌词: ${result.lrc?.lyric}');
print('翻译: ${result.tlyric?.lyric}');
```

#### 喜欢/取消喜欢
```dart
// 喜欢
await api.like(songId, true);

// 取消喜欢
await api.like(songId, false);

// 检查是否喜欢
var result = await api.likeCheck([songId]);
bool isLiked = result.ids?.contains(songId) ?? false;
```

### 3. 搜索功能

```dart
// 搜索歌曲
var songs = await api.search('周杰伦', type: SearchType.Song);

// 搜索歌手
var artists = await api.search('周杰伦', type: SearchType.Artist);

// 搜索专辑
var albums = await api.search('范特西', type: SearchType.Album);

// 搜索歌单
var playlists = await api.search('华语', type: SearchType.Playlist);

// 分页搜索
var result = await api.search(
  '周杰伦',
  type: SearchType.Song,
  limit: 30,    // 每页数量
  offset: 30,   // 偏移量（第2页）
);
```

### 4. 歌单管理

#### 创建歌单
```dart
var result = await api.playlistCreate('我的歌单', privacy: 10);
int? playlistId = result.id;
```

#### 获取歌单详情
```dart
var result = await api.playlistDetail(playlistId);
var playlist = result.playlist;
print('歌单名: ${playlist?.name}');
print('创建者: ${playlist?.creator?.nickname}');
print('歌曲数: ${playlist?.trackCount}');
```

#### 添加/移除歌曲
```dart
// 添加歌曲
await api.playlistTracks(
  TrackOperate.add,
  playlistId,
  [songId1, songId2],
);

// 移除歌曲
await api.playlistTracks(
  TrackOperate.del,
  playlistId,
  [songId1],
);
```

#### 更新歌单信息
```dart
await api.playlistUpdate(
  playlistId,
  name: '新名称',
  desc: '新描述',
  tags: ['华语', '流行'],
);
```

#### 删除歌单
```dart
await api.playlistDelete([playlistId]);
```

### 5. 用户功能

#### 获取用户详情
```dart
var result = await api.userDetail(userId);
var profile = result.profile;
print('昵称: ${profile?.nickname}');
print('签名: ${profile?.signature}');
print('粉丝: ${profile?.followeds}');
```

#### 获取用户歌单
```dart
var result = await api.userPlaylist(userId);
result.playlist?.forEach((playlist) {
  print('${playlist.name} - ${playlist.trackCount}首歌');
});
```

#### 每日签到
```dart
var result = await api.dailySignin();
if (result.code == RET_CODE_OK) {
  print('签到成功！获得${result.point}积分');
}
```

### 6. 推荐功能

```dart
// 每日推荐歌曲（需登录）
var songs = await api.recommendSongs();

// 每日推荐歌单
var playlists = await api.recommendResource();

// 推荐新音乐
var newSongs = await api.personalizedNewsong();

// 推荐歌单（未登录也可用）
var personalizedPlaylists = await api.personalized(limit: 10);
```

## 🎯 高级用法

### 自定义存储路径

```dart
class CustomPathProvider extends PathProvider {
  @override
  Future<void> init() async {
    // 自定义Cookie路径
    _cookiePath = '/your/custom/cookie/path/';
    // 自定义数据路径
    _dataPath = '/your/custom/data/path/';
  }
}

await BujuanMusicManager.init(
  provider: CustomPathProvider(),
  debug: true,
);
```

### 直接操作Cookie

```dart
import 'package:bujuan_music_api/src/handler/interceptor.dart';

// 获取所有Cookie
var cookies = await BujuanMusicManager.cookieJar.loadForRequest(
  Uri.parse('https://music.163.com')
);

// 删除所有Cookie（相当于退出登录）
await deleteAllCookie(BujuanMusicManager.cookieJar);
```

### 错误处理最佳实践

```dart
Future<Result<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    var result = await apiCall();
    return Result.success(result);
  } on DioException catch (e) {
    // 网络错误
    return Result.error('网络错误: ${e.message}');
  } catch (e) {
    // 其他错误
    return Result.error('未知错误: $e');
  }
}

// 使用
var result = await safeApiCall(() => api.search('周杰伦'));
result.when(
  success: (data) => print('搜索成功'),
  error: (message) => print('搜索失败: $message'),
);
```

## ⚙️ 配置选项

### Debug模式

```dart
// 开发环境
await BujuanMusicManager.init(debug: true);

// 生产环境
await BujuanMusicManager.init(debug: false);
```

Debug模式会打印：
- 请求URL
- 请求Header
- 请求Body
- 响应Body
- 错误信息

### 音质选项

```dart
// standard - 标准音质
// higher - 较高音质
// exhigh - 极高音质（默认）
// lossless - 无损音质（需要VIP）
// hires - Hi-Res音质（需要黑胶VIP）

await api.songUrl([songId], level: 'lossless');
```

## 🐛 常见问题排查

### 问题1: 登录失败（返回码301）

**原因**: Token过期或Cookie失效

**解决**:
```dart
// 方法1: 刷新Token
await api.loginRefresh();

// 方法2: 重新登录
await api.loginCellPhone(phone, password);
```

### 问题2: 歌曲无法播放

**原因**: 可能是版权问题或需要VIP

**解决**:
```dart
// 1. 检查歌曲是否可用
var detail = await api.songDetail([songId]);
if (detail.privileges?.first.st == -200) {
  print('该歌曲无版权');
}

// 2. 尝试不同音质
var url = await getSongUrl(songId, quality: 'standard');
```

### 问题3: 二维码登录一直pending

**原因**: 未扫码或未在手机上确认

**解决**: 确保正确处理所有状态码（见上方二维码登录示例）

### 问题4: Web平台Cookie丢失

**原因**: Web平台Cookie存储在浏览器中

**解决**: 使用 `SharedPreferences` 或 `localStorage` 自行管理Token

## 📊 API返回码对照表

| 返回码 | 常量 | 说明 |
|-------|------|------|
| 200 | RET_CODE_OK | 成功 |
| 301 | RET_CODE_NEED_LOGIN | 需要登录 |
| 400 | RET_CODE_ILLEGAL | 参数错误 |
| 403 | RET_CODE_ILLEGAL_REQUEST | 请求被拒绝 |
| 404 | RET_CODE_REQUEST_NOT_FOUNT | 资源不存在 |
| 800 | - | 二维码过期 |
| 801 | - | 等待扫码 |
| 802 | - | 等待确认 |
| 803 | - | 登录成功 |

## 🔐 安全建议

1. **不要在代码中硬编码密码**
2. **使用环境变量或安全存储**
3. **定期刷新Token**
4. **在生产环境关闭Debug模式**
5. **处理所有可能的异常**

## 📈 性能优化

1. **单例模式**: `BujuanMusicManager()` 已经是单例
2. **请求去重**: 避免短时间内重复请求
3. **分页加载**: 使用limit和offset参数
4. **缓存策略**: 自行实现本地缓存
5. **错误重试**: 网络错误时自动重试

## 🎓 学习资源

- [不卷音乐主项目](https://github.com/2697a/bujuan)
- [网易云音乐API文档](https://binaryify.github.io/NeteaseCloudMusicApi/)
- [Flutter官方文档](https://flutter.dev/docs)

---

**祝你使用愉快！** 🎉

如有问题，欢迎提Issue或查看 `MAINTENANCE.md` 维护指南。
