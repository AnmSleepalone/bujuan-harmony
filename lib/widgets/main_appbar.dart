import 'package:bujuan_music/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

AppBar mainAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    leading: IconButton(
        onPressed: () => GetIt.I<ZoomDrawerController>().toggle?.call(),
        icon: Image.asset('assets/images/logo.png',width: 35.w,height: 35.w,)),
    title: Text('BuJuan'),
    actions: [
      IconButton(
          onPressed: () {
            context.push(AppRouter.search);
          },
          icon: Icon(HugeIcons.strokeRoundedSearch01)),
    ],
  );
}
