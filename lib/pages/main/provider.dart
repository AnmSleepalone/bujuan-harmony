import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/common/values/app_config.dart';
import 'package:bujuan_music/common/values/app_images.dart';
import 'package:bujuan_music/widgets/we_slider/weslide_controller.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    // 读取保存的主题模式，默认跟随系统
    final themeString = GetIt.I<Box>().get(AppConfig.themeMode) as String?;
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    // 保存主题模式
    final themeString = mode == ThemeMode.light
        ? 'light'
        : mode == ThemeMode.dark
            ? 'dark'
            : 'system';
    GetIt.I<Box>().put(AppConfig.themeMode, themeString);
  }

  void toggleTheme() {
    // 切换顺序：浅色 -> 深色 -> 跟随系统 -> 浅色
    final newMode = state == ThemeMode.light
        ? ThemeMode.dark
        : state == ThemeMode.dark
            ? ThemeMode.system
            : ThemeMode.light;
    setTheme(newMode);
  }
}

@riverpod
WeSlideController weSlideController(Ref ref) {
  return WeSlideController();
}

@riverpod
class BackgroundModeNotifier extends _$BackgroundModeNotifier {
  @override
  String build() => (GetIt.I<Box>().get(AppConfig.backgroundPath) ?? AppImages.happy);

  void changeBackground(String background) {
    state = background;
  }
}

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build() => 0; // 初始值

  void setIndex(int index) {
    state = index; // 修改值
  }
}

@riverpod
class HomeStyle extends _$HomeStyle {
  @override
  HomeStyleType build() => HomeStyleType.bottomBar; // 初始值

  void setIndex(HomeStyleType type) {
    state = type; // 修改值
  }
}

enum HomeStyleType { draw, bottomBar }

@riverpod
class BoxPanelDetailData extends _$BoxPanelDetailData {
  @override
  double build() => 0;

  void updatePanelDetail(double newValue) {
    state = newValue;
  }
}

@riverpod
class CurrentRouterPath extends _$CurrentRouterPath {
  @override
  String build() => '/';

  void updatePanelDetail(String newValue) {
    if (state != newValue) {
      state = newValue;
    }
  }
}

@Riverpod(keepAlive: true)
Stream<MediaItem?> mediaItem(Ref ref) {
  return BujuanMusicHandler().mediaItem.stream;
}

@Riverpod(keepAlive: true)
Stream<PlaybackState?> playbackState(Ref ref) {
  return BujuanMusicHandler().playbackState.stream;
}

@Riverpod(keepAlive: true)
Stream<List<MediaItem>> queueStream(Ref ref) {
  return BujuanMusicHandler().queue.stream.map((queue) => queue ?? []);
}

@Riverpod(keepAlive: true)
Stream<int> currentIndexStream(Ref ref) {
  return BujuanMusicHandler().currentIndexSubject.stream;
}

// _player.onPositionChanged

@riverpod
Future<NeteaseAccountInfoWrap?> userInfo(Ref ref) async {
  return await BujuanMusicManager().loginAccountInfo();
}

@riverpod
Future<MvUrlWrap?> mvUrl(Ref ref) async {
  // var url = ref.watch(mediaItemProvider).value.extras?['mvId'];
  // return await BujuanMusicManager().mvUrl(id: id);
}

@riverpod
Future<NeteaseAccountInfoWrap?> lyric(Ref ref) async {
  return await BujuanMusicManager().loginAccountInfo();
}

@riverpod
Future<PaletteGenerator> mediaColor(Ref ref) async {
  final artUri = ref.watch(
    mediaItemProvider.select((m) => m.value?.artUri.toString()),
  );
  if (artUri == null || artUri.isEmpty) {
    return PaletteGenerator.fromColors([PaletteColor(Colors.grey, 1)]);
  }
  final imageProvider = CachedNetworkImageProvider('$artUri?param=200y200');
  return PaletteGenerator.fromImageProvider(
    imageProvider,
    size: const Size(200, 200),
  );
}

/// 播放模式
@riverpod
class LoopModeNotifier extends _$LoopModeNotifier {
  @override
  LoopMode build() => LoopMode.playlist;

  void changeMode() {
    switch (BujuanMusicHandler().loopMode) {
      case LoopMode.one:
        state = LoopMode.playlist;
        break;
      case LoopMode.playlist:
        state = LoopMode.shuffle;
        break;
      case LoopMode.shuffle:
        state = LoopMode.one;
        break;
    }
    BujuanMusicHandler().setLoopMode(state);
  }
}
