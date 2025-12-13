import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/common/values/app_theme.dart';
import 'package:bujuan_music/pages/main/provider.dart';
import 'package:bujuan_music/router/router.dart';
import 'package:bujuan_music/utils/adaptive_screen_utils.dart';
import 'package:bujuan_music/widgets/we_slider/weslide_controller.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';
// import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initMedia();
  await initWindow();
  await Hive.initFlutter();
  await Hive.openBox('bujuan');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // 底部手势栏透明
      statusBarColor: Colors.transparent));
  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<ZoomDrawerController>(ZoomDrawerController());
  getIt.registerSingleton<WeSlideController>(WeSlideController(initial: true),instanceName: 'footer');
  getIt.registerSingleton<WeSlideController>(WeSlideController(),instanceName: 'panel');
  getIt.registerSingleton<Box>(Hive.box('bujuan'));
  // 让布局真正覆盖状态栏和底部手势栏
  // 注意：鸿蒙暂不支持 edgeToEdge，如需启用请添加平台判断
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(ProviderScope(child: MyApp()));
}

/// 初始化窗口（仅桌面平台）
Future<void> initWindow() async {
  // 只在桌面平台（非鸿蒙、非Android、非iOS）使用 window_manager
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    // window_manager 已在 pubspec.yaml 中注释，如需桌面端支持请取消注释
    // await windowManager.ensureInitialized();
    // WindowOptions windowOptions = WindowOptions(
    //   size: Size(1024, 650),
    //   maximumSize: Size(1024, 800),
    //   center: true,
    //   backgroundColor: Colors.transparent,
    //   skipTaskbar: false,
    //   titleBarStyle: TitleBarStyle.hidden,
    // );
    // windowManager.waitUntilReadyToShow(windowOptions, () async {
    //   await windowManager.show();
    //   await windowManager.focus();
    // });
  }
  // 鸿蒙、Android、iOS 等移动平台无需窗口管理
}

/// 初始化音频服务
Future<void> initMedia() async {
  await BujuanMusicManager.init(debug: false);
  await AudioService.init(
    builder: () => BujuanMusicHandler(),
    config: AudioServiceConfig(
      androidNotificationChannelId: 'com.sixbugs.bujuan.channel.audio',
      androidNotificationChannelName: 'Music playback',
    ),
  );
}

/// 开启本地代理服务
// Future<void> startLocalRedirectServer() async {
//   final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8848);
//   server.listen((HttpRequest request) async {
//     final path = request.uri.path;
//     if (path.startsWith('/song/')) {
//       final songId = path.split('/').last;
//       final realUrl = await BujuanMusicHandler().getSongUrl(songId);
//       final client = HttpClient();
//       final realRequest = await client.getUrl(Uri.parse(realUrl));
//       final realResponse = await realRequest.close();
//       log('$songId--------------$realUrl');
//       request.response.statusCode = realResponse.statusCode;
//       request.response.headers.contentType = realResponse.headers.contentType;
//       await realResponse.pipe(request.response);
//     } else {
//       request.response
//         ..statusCode = 404
//         ..write('Not found')
//         ..close();
//     }
//   });
//
// }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    Size size = Size(375, 812);
    if (medium(context) || expanded(context)) {
      size = Size(1024, 700);
    }

    return ScreenUtilInit(
      designSize: size,
      builder: (_, __) => AnnotatedRegion(value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: true
      ), child: Consumer(builder: (_, ref, __) {
        final themeMode = ref.watch(themeModeNotifierProvider);
        return MaterialApp.router(
          title: 'Bujuan',
          themeMode: themeMode,
          darkTheme: AppTheme.dark,
          showPerformanceOverlay: false,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          routerConfig: router,
        );
      })),
    );
  }
}
