// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$weSlideControllerHash() => r'2a39b97effbcc5bacfd7439a0ece4b480357b239';

/// See also [weSlideController].
@ProviderFor(weSlideController)
final weSlideControllerProvider =
    AutoDisposeProvider<WeSlideController>.internal(
  weSlideController,
  name: r'weSlideControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$weSlideControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeSlideControllerRef = AutoDisposeProviderRef<WeSlideController>;
String _$mediaItemHash() => r'c955eda17d145c44c1963bd2fca905983abd8b72';

/// See also [mediaItem].
@ProviderFor(mediaItem)
final mediaItemProvider = StreamProvider<MediaItem?>.internal(
  mediaItem,
  name: r'mediaItemProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mediaItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MediaItemRef = StreamProviderRef<MediaItem?>;
String _$playbackStateHash() => r'377f19925c19bdc4792008dea1e7471e1fe3ee27';

/// See also [playbackState].
@ProviderFor(playbackState)
final playbackStateProvider = StreamProvider<PlaybackState?>.internal(
  playbackState,
  name: r'playbackStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$playbackStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PlaybackStateRef = StreamProviderRef<PlaybackState?>;
String _$queueStreamHash() => r'eddd01f7d426e427398c73a0fa9e9ffbd3e91235';

/// See also [queueStream].
@ProviderFor(queueStream)
final queueStreamProvider = StreamProvider<List<MediaItem>>.internal(
  queueStream,
  name: r'queueStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$queueStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef QueueStreamRef = StreamProviderRef<List<MediaItem>>;
String _$currentIndexStreamHash() =>
    r'27e49901a9782e05ba29a387ef292a30d8bb561a';

/// See also [currentIndexStream].
@ProviderFor(currentIndexStream)
final currentIndexStreamProvider = StreamProvider<int>.internal(
  currentIndexStream,
  name: r'currentIndexStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentIndexStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentIndexStreamRef = StreamProviderRef<int>;
String _$userInfoHash() => r'37ca86b3f6a2f92534a229e5bee178986fb8ae7f';

/// See also [userInfo].
@ProviderFor(userInfo)
final userInfoProvider =
    AutoDisposeFutureProvider<NeteaseAccountInfoWrap?>.internal(
  userInfo,
  name: r'userInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserInfoRef = AutoDisposeFutureProviderRef<NeteaseAccountInfoWrap?>;
String _$mvUrlHash() => r'21f9f4ec5e70ab1271c42cebba60da9476bc2757';

/// See also [mvUrl].
@ProviderFor(mvUrl)
final mvUrlProvider = AutoDisposeFutureProvider<MvUrlWrap?>.internal(
  mvUrl,
  name: r'mvUrlProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mvUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MvUrlRef = AutoDisposeFutureProviderRef<MvUrlWrap?>;
String _$lyricHash() => r'541d4242a12bc4b2a2cc6ff57a407414e80d7259';

/// See also [lyric].
@ProviderFor(lyric)
final lyricProvider =
    AutoDisposeFutureProvider<NeteaseAccountInfoWrap?>.internal(
  lyric,
  name: r'lyricProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lyricHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LyricRef = AutoDisposeFutureProviderRef<NeteaseAccountInfoWrap?>;
String _$mediaColorHash() => r'3860228a1db7639806da3d37ea784fde8b5c99fb';

/// See also [mediaColor].
@ProviderFor(mediaColor)
final mediaColorProvider = AutoDisposeFutureProvider<PaletteGenerator>.internal(
  mediaColor,
  name: r'mediaColorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mediaColorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MediaColorRef = AutoDisposeFutureProviderRef<PaletteGenerator>;
String _$themeModeNotifierHash() => r'ad700fa5d41aeec8fea1cfb81dd3df07abf3c3ef';

/// See also [ThemeModeNotifier].
@ProviderFor(ThemeModeNotifier)
final themeModeNotifierProvider =
    AutoDisposeNotifierProvider<ThemeModeNotifier, ThemeMode>.internal(
  ThemeModeNotifier.new,
  name: r'themeModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$themeModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeModeNotifier = AutoDisposeNotifier<ThemeMode>;
String _$backgroundModeNotifierHash() =>
    r'7809376e2bdbb9de244200e40b1359ee0ca28731';

/// See also [BackgroundModeNotifier].
@ProviderFor(BackgroundModeNotifier)
final backgroundModeNotifierProvider =
    AutoDisposeNotifierProvider<BackgroundModeNotifier, String>.internal(
  BackgroundModeNotifier.new,
  name: r'backgroundModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$backgroundModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BackgroundModeNotifier = AutoDisposeNotifier<String>;
String _$currentIndexHash() => r'51e75b301eb79ee8f5bc2fd781463dbd404ea42f';

/// See also [CurrentIndex].
@ProviderFor(CurrentIndex)
final currentIndexProvider =
    AutoDisposeNotifierProvider<CurrentIndex, int>.internal(
  CurrentIndex.new,
  name: r'currentIndexProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentIndex = AutoDisposeNotifier<int>;
String _$homeStyleHash() => r'c6b5888f097d189eb19895e8754d4f6027fc20b3';

/// See also [HomeStyle].
@ProviderFor(HomeStyle)
final homeStyleProvider =
    AutoDisposeNotifierProvider<HomeStyle, HomeStyleType>.internal(
  HomeStyle.new,
  name: r'homeStyleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$homeStyleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeStyle = AutoDisposeNotifier<HomeStyleType>;
String _$boxPanelDetailDataHash() =>
    r'156ad7326d0b0b9aea2a9eaa45e202639e0a32f6';

/// See also [BoxPanelDetailData].
@ProviderFor(BoxPanelDetailData)
final boxPanelDetailDataProvider =
    AutoDisposeNotifierProvider<BoxPanelDetailData, double>.internal(
  BoxPanelDetailData.new,
  name: r'boxPanelDetailDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$boxPanelDetailDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$BoxPanelDetailData = AutoDisposeNotifier<double>;
String _$currentRouterPathHash() => r'6433b94e949466cc49bf052a1f376336469b71aa';

/// See also [CurrentRouterPath].
@ProviderFor(CurrentRouterPath)
final currentRouterPathProvider =
    AutoDisposeNotifierProvider<CurrentRouterPath, String>.internal(
  CurrentRouterPath.new,
  name: r'currentRouterPathProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentRouterPathHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentRouterPath = AutoDisposeNotifier<String>;
String _$loopModeNotifierHash() => r'd6e22c4d2f3e534e551adbaa1a66a8a0c559f760';

/// 播放模式
///
/// Copied from [LoopModeNotifier].
@ProviderFor(LoopModeNotifier)
final loopModeNotifierProvider =
    AutoDisposeNotifierProvider<LoopModeNotifier, LoopMode>.internal(
  LoopModeNotifier.new,
  name: r'loopModeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$loopModeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LoopModeNotifier = AutoDisposeNotifier<LoopMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
