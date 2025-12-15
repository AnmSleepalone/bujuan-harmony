import 'package:bujuan_music/pages/main/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../router/app_router.dart';
import '../../utils/adaptive_screen_utils.dart';
import '../../widgets/backdrop.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool desktop = medium(context) || expanded(context);
    return desktop ? DesktopMenu() : MobileMenu();
  }
}

class MobileMenu extends ConsumerWidget {
  const MobileMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentPath = ref.watch(currentRouterPathProvider);
    var theme = ref.watch(themeModeNotifierProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          minLeadingWidth: 20.w,
          leading: Icon(
            HugeIcons.strokeRoundedHome01,
            color: currentPath == AppRouter.home ? Colors.red : null,
          ),
          title: Text(
            '首页',
            style: TextStyle(
                color: currentPath == AppRouter.home ? Colors.red : null, fontSize: 16.sp),
          ),
          onTap: () {
            context.replace(AppRouter.home);
            GetIt.I<ZoomDrawerController>().toggle?.call();
          },
        ),
        ListTile(
          minLeadingWidth: 20.w,
          leading: Icon(HugeIcons.strokeRoundedLookTop,
              color: currentPath == AppRouter.user ? Colors.red : null),
          title: Text(
            '我的',
            style: TextStyle(
                color: currentPath == AppRouter.user ? Colors.red : null, fontSize: 16.sp),
          ),
          onTap: () {
            context.replace(AppRouter.user);
            GetIt.I<ZoomDrawerController>().toggle?.call();
          },
        ),
        ListTile(
          leading: Icon(
            HugeIcons.strokeRoundedSettings03,
            color: currentPath == AppRouter.setting ? Colors.red : null,
          ),
          minLeadingWidth: 20.w,
          title: Text(
            '设置',
            style: TextStyle(
                color: currentPath == AppRouter.setting ? Colors.red : null, fontSize: 16.sp),
          ),
          onTap: () {
            context.replace(AppRouter.setting);
            GetIt.I<ZoomDrawerController>().toggle?.call();
          },
        ),
        ListTile(
          minLeadingWidth: 20.w,
          leading: Icon(
            theme == ThemeMode.dark
                ? HugeIcons.strokeRoundedSunCloud02
                : HugeIcons.strokeRoundedMoon01,
          ),
          title: Text('主题'),
          onTap: () => ref.read(themeModeNotifierProvider.notifier).toggleTheme(),
        )
      ],
    );
  }
}

class DesktopMenu extends ConsumerWidget {
  const DesktopMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentPath = ref.watch(currentRouterPathProvider);
    return BackdropView(
      width: 52.w,
      padding: EdgeInsets.symmetric(vertical: 15.w),
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          IconButton(
            onPressed: () =>  context.replace(AppRouter.home),
            icon: Icon(HugeIcons.strokeRoundedHome01,
                color: currentPath == AppRouter.home ? Color(0XFF1ED760) : null),
          ),
          SizedBox(height: 60.w),
          IconButton(
            onPressed: () =>  context.replace(AppRouter.user),
            icon: Icon(HugeIcons.strokeRoundedUser,
                color: currentPath == AppRouter.user ? Color(0XFF1ED760) : null),
          ),
          SizedBox(height: 60.w),
          // IconButton(
          //   onPressed: () {},
          //   icon: Icon(HugeIcons.strokeRoundedNote,
          //       color: currentPath == AppRouter.splash ? Color(0XFF1ED760) : null),
          // ),
          // SizedBox(height: 60.w),
          // IconButton(
          //   onPressed: () =>  context.replace(AppRouter.setting),
          //   icon: Icon(HugeIcons.strokeRoundedSettings02,
          //       color: currentPath == AppRouter.setting ? Color(0XFF1ED760) : null),
          // ),
        ],
      ),
    );
  }
}
