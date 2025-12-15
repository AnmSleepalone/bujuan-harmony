import 'package:bujuan_music/pages/main/provider.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../pages/main/main_page.dart';
import '../../router/app_router.dart';

class AppConfig {
  static const String isDarkTheme = 'isDarkTheme'; // 已废弃，使用 themeMode
  static const String themeMode = 'themeMode'; // 主题模式: 'light', 'dark', 'system'
  static const String backgroundPath = 'backgroundPath';
  static const String playbackState = 'playback_state'; // 播放状态持久化

  static final List<BottomData> bottomItems = [
    BottomData(HugeIcons.strokeRoundedHome01, HugeIcons.strokeRoundedHome01, AppRouter.home, '首页'),
    BottomData(HugeIcons.strokeRoundedLookTop, HugeIcons.strokeRoundedLookTop, AppRouter.user, '我的'),
    BottomData(HugeIcons.strokeRoundedSettings02, HugeIcons.strokeRoundedSettings02, AppRouter.setting, '设置'),
  ];

  static HomeStyleType homeStyleType = HomeStyleType.bottomBar;

  static const String userInfoKey = 'USER_INFO_KEY';
}
