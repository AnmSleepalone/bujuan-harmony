# Pinput 5.0.2 鸿蒙适配补丁说明

## 修改内容

### 问题描述
原版 pinput 5.0.2 在鸿蒙平台运行时会抛出以下错误：
```
LateInitializationError: Field 'forcePressEnabled' has not been initialized.
```

### 根本原因
在 `lib/src/pinput_state.dart` 文件的 `_buildPinput()` 方法中，`forcePressEnabled` 字段仅针对以下平台初始化：
- iOS
- Android
- macOS
- Linux
- Windows
- Fuchsia

**鸿蒙平台不在上述列表中**，导致该字段未被初始化。

### 修复方案
在 `initState()` 方法中预先初始化 `forcePressEnabled` 字段，确保在任何平台都有默认值。

**修改文件**：`lib/src/pinput_state.dart`

**修改位置**：第75-93行

**修改内容**：
```dart
@override
void initState() {
  super.initState();
  // Initialize forcePressEnabled for HarmonyOS compatibility
  forcePressEnabled = false;  // ← 新增这一行
  _gestureDetectorBuilder =
      _PinputSelectionGestureDetectorBuilder(state: this);
  // ... 其他代码保持不变
}
```

## 使用方法

此包已作为本地依赖集成到项目中，在 `pubspec.yaml` 中配置如下：

```yaml
dependencies:
  pinput:
    path: ./plugin/pinput-5.0.2-ohos
```

## 维护说明

### 为什么使用本地依赖？
1. **pub-cache 修改会被覆盖**：直接修改 pub-cache 中的文件在运行 `flutter pub get`、`flutter pub upgrade` 或 `flutter clean` 后会丢失
2. **版本控制**：本地依赖可以纳入项目的版本控制系统
3. **团队协作**：团队其他成员克隆项目后无需手动修改第三方包

### 注意事项
1. 不要删除 `plugin/pinput-5.0.2-ohos` 目录
2. 如需升级 pinput 版本，需要：
   - 获取新版本
   - 应用相同的鸿蒙兼容性补丁
   - 更新本地目录
3. 此修改仅影响鸿蒙平台，不影响其他平台的正常使用

## 修改日期
2025-12-11

## 修改人
Claude Code (AI Assistant)

## 相关 Issue
- pinput 官方仓库尚未支持鸿蒙平台
- 建议向官方提交 PR 以获得长期支持
