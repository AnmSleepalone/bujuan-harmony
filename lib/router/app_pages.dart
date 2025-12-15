import 'package:bujuan_music/pages/artist/artist_page.dart';
import 'package:bujuan_music/pages/cloud/cloud_page.dart';
import 'package:bujuan_music/pages/fm/fm_page.dart';
import 'package:bujuan_music/pages/home/today/today_page.dart';
import 'package:bujuan_music/pages/mv/mv_page.dart';
import 'package:bujuan_music/pages/play/desktop_play_page.dart';
import 'package:bujuan_music/pages/playlist/playlist_page.dart';
import 'package:bujuan_music/pages/search/search_page.dart';
import 'package:bujuan_music/pages/setting/setting_page.dart';
import 'package:bujuan_music/pages/user/user_page.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';

class AppPages {
  static final shellRouter = [
    GoRoute(
      path: AppRouter.home,
      pageBuilder: (context, state) => NoTransitionPage(child: HomePage()),
    ),
    GoRoute(path: AppRouter.today, builder: (context, state) => TodayPage()),
    GoRoute(
        path: AppRouter.play,
        pageBuilder: (context, state) =>
            buildPageWithSlideUpTransition(state: state, child: DesktopPlayPage())),
    GoRoute(
        path: AppRouter.playlist,
        builder: (context, state) {
          // 处理 String 和 int 两种类型的 id
          final id = state.extra;
          final playlistId = id is int ? id : int.tryParse(id.toString()) ?? 0;
          print('[Router] Playlist route - received id type: ${id.runtimeType}, converted to: $playlistId');
          return PlaylistPage(playlistId);
        }),
    GoRoute(
        path: AppRouter.artist,
        builder: (context, state) {
          // 处理 String 和 int 两种类型的 id
          final id = state.extra;
          final artistId = id is int ? id : int.tryParse(id.toString()) ?? 0;
          print('[Router] Artist route - received id type: ${id.runtimeType}, converted to: $artistId');
          return ArtistPage(artistId);
        }),
    GoRoute(
      path: AppRouter.user,
      pageBuilder: (context, state) => NoTransitionPage(child: UserPage()),
    ),
    GoRoute(
      path: AppRouter.setting,
      pageBuilder: (context, state)=>  NoTransitionPage(child: SettingPage()),
    ),
    GoRoute(
      path: AppRouter.search,
      builder: (context, state) => SearchPage(),
    ),
    GoRoute(
      path: AppRouter.cloud,
      builder: (context, state) => CloudPage(),
    ),
    GoRoute(
      path: AppRouter.fm,
      builder: (context, state) => FmPage(),
    ),
  ];

  static final rootRouter = [
    GoRoute(path: AppRouter.login, builder: (c, s) => const LoginPage()),
    GoRoute(path: AppRouter.splash, builder: (c, s) => const SplashPage()),
    GoRoute(
        path: AppRouter.mv,
        builder: (c, s) {
          // 处理 String 和 int 两种类型的 id
          final id = s.extra;
          final mvId = id is int ? id : int.tryParse(id.toString()) ?? 0;
          print('[Router] MV route - received id type: ${id.runtimeType}, converted to: $mvId');
          return MvPage(mvId);
        }),
  ];

  static Page<dynamic> buildPageWithSlideUpTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // 从底部开始
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
