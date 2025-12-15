<p align="center">
<img src="macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png" alt="app_icon" width="120"/>
</p>

<h1 align="center">Bujuan for HarmonyOS</h1>

<p align="center">
  <strong>一个专为鸿蒙系统适配的第三方网易云音乐播放器</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-HarmonyOS-red?style=flat-square" alt="Platform"/>
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square" alt="Flutter"/>
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License"/>
</p>

---

## 致谢

本项目基于 [bujuan](https://github.com/2697a/bujuan) 开源项目进行鸿蒙适配开发，感谢原作者的开源贡献！

> 原项目 README 请查看 [ORIGIN_README.md](./ORIGIN_README.md)

---

## 特别说明

> **本项目专为 HarmonyOS (鸿蒙系统) 适配开发，不保证在其他平台（Android、iOS、Windows、MacOS、Linux）的可用性。**
>
> 如需在其他平台使用，请参考原项目。

---

## 截图预览

<!-- 请在此处添加截图 -->
| 首页 | 播放页 | 歌词页 |
|:---:|:---:|:---:|
| ![首页](screenshots/home.png) | ![播放页](screenshots/play.png) | ![歌词页](screenshots/lyrics.png) |

| 我的 | 每日推荐 | 登录页 |
|:---:|:---:|:---:|
| ![我的](screenshots/me.png) | ![每日推荐](screenshots/today.png) | ![登录页](screenshots/login.png) |

---

## 功能特性

### 基础功能
- 网易云账号登录（二维码登录）
- 每日推荐歌曲
- 私人 FM（未实现）
- 云盘音乐（未实现）
- 歌单管理
- 歌手/专辑浏览
- 搜索功能
- 鸿蒙系统媒体卡片控制
-


---

## 鸿蒙适配改进

在原项目分支new-ui基础上，本项目做了以下适配和优化：

### 新增功能
- [x] 鸿蒙系统媒体卡片播放控制
- [x] 歌词显示
- [x] 歌词翻译显示
- [x] 评论页面
- [x] 快捷入口（每日推荐、云盘、私人FM）

### 问题修复
- [x] 修复 API 调用错误
- 
### UI 优化
- [x] 播放页面布局优化
- [x] 歌词页面视觉效果优化
- [x] 用户页面布局调整

---

## 编译部署

### 环境要求
- Flutter 3.27.4 （鸿蒙适配，https://gitcode.com/openharmony-tpc/flutter_flutter/tree/oh-3.27.4-dev）
- Dart SDK
- HarmonyOS DevEco Studio (用于鸿蒙打包)

### 编译命令

```bash
# 获取依赖
flutter doctor
# 查看是否鸿蒙 flutter sdk 与 鸿蒙sdk
# 鸿蒙打包 (需配置鸿蒙开发环境)
# 请参考鸿蒙官方文档进行配置
flutter pub get -v
# 获取依赖

flutter run -d 设备Id
# flutter devices 获取你的设备ID

flutter build hap --release
# 打包为鸿蒙包

```

---

## 项目结构

```
lib/
├── common/          # 公共模块（音乐处理、API管理）
├── pages/           # 页面
│   ├── home/        # 首页
│   ├── play/        # 播放页面
│   ├── user/        # 用户页面
│   ├── login/       # 登录页面
│   ├── cloud/       # 云盘页面
│   ├── fm/          # 私人FM页面
│   └── ...
├── router/          # 路由配置
├── utils/           # 工具类
└── widgets/         # 公共组件
```

---

## 免责声明

- 本项目仅供学习交流使用，请勿用于商业用途
- 本项目不存储任何音乐资源，所有数据均来自第三方
- 使用本项目产生的任何问题，开发者不承担任何责任
- 如有侵权，请联系删除

---


