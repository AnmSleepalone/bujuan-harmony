import 'package:bujuan_music/pages/main/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons/hugeicons.dart';

AppBar mainAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
        onPressed: () => GetIt.I<ZoomDrawerController>().toggle?.call(),
        icon: Image.asset('assets/images/logo.png',width: 35.w,height: 35.w,)),
    title: Text('BuJuan'),
    actions: [
      Consumer(builder: (context, ref, child) {
        return IconButton(
            onPressed: () {
              bool isDark = ref.read(themeModeNotifierProvider) == ThemeMode.dark;
              ref
                  .read(themeModeNotifierProvider.notifier)
                  .setTheme(isDark ? ThemeMode.light : ThemeMode.dark);
            },
            icon: Icon(HugeIcons.strokeRoundedSearch01));
      })
    ],
  );
}
