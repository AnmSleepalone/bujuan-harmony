import 'package:bujuan_music/pages/main/provider.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../pages/main/main_page.dart';
import '../../router/app_router.dart';

class AppConfig {
  static const String isDarkTheme = 'isDarkTheme';
  static const String backgroundPath = 'backgroundPath';

  static final List<BottomData> bottomItems = [
    BottomData(HugeIcons.strokeRoundedHome01, HugeIcons.strokeRoundedHome01, AppRouter.home, 'Home'),
    BottomData(HugeIcons.strokeRoundedLookTop, HugeIcons.strokeRoundedLookTop, AppRouter.user, 'Me'),
    BottomData(HugeIcons.strokeRoundedFileMusic, HugeIcons.strokeRoundedFileMusic, AppRouter.setting, 'File'),
    BottomData(HugeIcons.strokeRoundedSettings02, HugeIcons.strokeRoundedSettings02, AppRouter.setting, 'Setting'),
  ];

  static HomeStyleType homeStyleType = HomeStyleType.bottomBar;

  static const String userInfoKey = 'USER_INFO_KEY';
}
