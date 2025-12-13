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



### 注意事项
1. 不要删除 `plugin/pinput-5.0.2-ohos` 目录
2. 如需升级 pinput 版本，需要：
   - 获取新版本
   - 应用相同的鸿蒙兼容性补丁
   - 更新本地目录
3. 此修改仅影响鸿蒙平台，不影响其他平台的正常使用


