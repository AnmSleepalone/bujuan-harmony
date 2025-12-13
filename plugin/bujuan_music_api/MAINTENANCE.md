# 插件维护指南

## 🔧 导入路径修复

由于代码是从主项目迁移过来的，可能存在一些import路径需要手动修复。

### 需要修复的import模式

#### 1. API模块中的import

**原路径** (需要修复):
```dart
import 'package:bujuan/common/netease_api/src/xxx';
import '../../../netease_music_api.dart';
import '../../../src/xxx';
```

**新路径** (正确):
```dart
import '../../bujuan_music_manager.dart';
import '../../common/xxx.dart';
import '../../handler/xxx.dart';
```

### 批量修复脚本

运行以下命令批量修复所有import路径：

```bash
cd plugin/bujuan_music_api

# 修复API模块
find lib/src/api -name "*.dart" -type f -exec sed -i 's|package:bujuan/common/netease_api/||g' {} \;
find lib/src/api -name "*.dart" -type f -exec sed -i 's|../../../netease_music_api.dart|../../bujuan_music_manager.dart|g' {} \;
find lib/src/api -name "*.dart" -type f -exec sed -i 's|../../../src/|../../|g' {} \;

# 修复bean.dart
sed -i 's|../../src/netease_bean.dart|../common/constants.dart|g' lib/src/common/bean.dart
```

### Windows用户

Windows用户可以使用PowerShell:

```powershell
cd plugin\bujuan_music_api

# 使用PowerShell替换
Get-ChildItem -Path "lib\src\api" -Filter *.dart -Recurse | ForEach-Object {
    (Get-Content $_.FullName) -replace 'package:bujuan/common/netease_api/', '' | Set-Content $_.FullName
    (Get-Content $_.FullName) -replace '../../../netease_music_api.dart', '../../bujuan_music_manager.dart' | Set-Content $_.FullName
    (Get-Content $_.FullName) -replace '../../../src/', '../../' | Set-Content $_.FullName
}
```

## 🛠️ 常见编译错误修复

### 错误1: 找不到 NeteaseMusicApi 类

**错误信息**:
```
Error: Method not found: 'NeteaseMusicApi'.
```

**修复方法**:
在 `api/login/api.dart` 等文件中，将：
```dart
NeteaseMusicApi().usc.onLogined(info);
```
改为：
```dart
BujuanMusicManager().usc.onLogined(info);
```

运行批量替换：
```bash
find lib/src/api -name "*.dart" -exec sed -i 's|NeteaseMusicApi()|BujuanMusicManager()|g' {} \;
```

### 错误2: 找不到 Https 类

**错误信息**:
```
Error: Method not found: 'Https.dioProxy'.
```

**确认**:
检查 `lib/src/common/dio_ext.dart` 是否存在，该文件应该包含 `Https` 类定义。

### 错误3: 缺少 .g.dart 文件

**错误信息**:
```
Error: Couldn't find file 'bean.g.dart'.
```

**修复方法**:
运行代码生成：
```bash
cd plugin/bujuan_music_api
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📦 依赖问题

### 版本冲突

如果遇到依赖版本冲突，可以尝试：

1. **清除缓存**:
```bash
flutter pub cache clean
flutter clean
flutter pub get
```

2. **调整依赖版本**:
在 `pubspec.yaml` 中根据主项目调整版本号。

### 鸿蒙平台适配

如果用于鸿蒙平台，需要将 `pubspec.yaml` 中的插件替换为鸿蒙版本：

```yaml
dependencies:
  # 使用鸿蒙适配版本
  path_provider:
    git:
      url: "https://gitcode.com/openharmony-tpc/flutter_packages.git"
      path: "packages/path_provider/path_provider"
      ref: "br_path_provider-v2.1.5_ohos"
```

## 🧪 测试插件

### 创建测试项目

```bash
# 在plugin目录下创建测试项目
cd plugin
flutter create test_app
cd test_app
```

在 `pubspec.yaml` 中添加：
```yaml
dependencies:
  bujuan_music_api:
    path: ../bujuan_music_api
```

### 简单测试

```dart
import 'package:bujuan_music_api/bujuan_music_api.dart';

void main() async {
  // 初始化
  await BujuanMusicManager.init(debug: true);

  // 测试匿名登录
  var api = BujuanMusicManager();
  var result = await api.loginAnonimous();

  print('匿名登录: ${result.code == RET_CODE_OK ? "成功" : "失败"}');
}
```

## 🔍 调试技巧

### 1. 开启详细日志

```dart
await BujuanMusicManager.init(debug: true);
```

### 2. 检查Cookie

```dart
import 'package:bujuan_music_api/src/handler/interceptor.dart';

var cookies = await _loadCookies(BujuanMusicManager.cookieJar);
print('Cookies: $cookies');
```

### 3. 检查登录状态

```dart
var manager = BujuanMusicManager();
print('是否登录: ${manager.usc.isLogined}');
print('用户信息: ${manager.usc.accountInfo?.profile?.nickname}');
```

## 📝 代码规范

维护插件时请遵循以下规范：

1. **导入顺序**: Dart SDK -> Flutter -> 第三方包 -> 内部包
2. **命名规范**:
   - 类名: `PascalCase`
   - 方法名: `camelCase`
   - 常量: `UPPER_SNAKE_CASE`
3. **注释**: 所有公开API都应该有文档注释
4. **错误处理**: 使用 try-catch 包装所有网络请求

## 🚀 发布检查清单

发布新版本前请检查：

- [ ] 所有import路径正确
- [ ] 运行 `flutter analyze` 无错误
- [ ] 运行 `flutter pub run build_runner build` 生成代码
- [ ] 测试项目可以正常使用
- [ ] README.md 文档完整
- [ ] CHANGELOG.md 更新版本记录
- [ ] pubspec.yaml 版本号更新

## 🐛 已知问题

### PlatformUtils依赖

原项目中使用了 `PlatformUtils.isWeb`，已替换为 `kIsWeb` (来自 `package:flutter/foundation.dart`)。

### DioError vs DioException

新版本Dio使用 `DioException` 而不是 `DioError`，已在 `dio_ext.dart` 中修复。

### Cookie存储路径

Cookie默认存储在 `应用支持目录/bujuan_music/.cookies/`。
用户数据存储在 `应用支持目录/bujuan_music/.data/`。

## 💡 最佳实践

1. **初始化时机**: 在 `main()` 函数中，`runApp()` 之前初始化
2. **单例使用**: `BujuanMusicManager()` 返回单例，可以在任何地方调用
3. **错误处理**: 所有API调用都应该有错误处理
4. **登录态管理**: 使用 `listenLoginState` 监听登录状态变化
5. **资源清理**: 应用退出时调用 `usc.destroy()` 清理资源

---

如有问题，请提交Issue或查看README.md获取更多信息。
