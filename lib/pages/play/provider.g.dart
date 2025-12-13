// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getImageColorHash() => r'0f56b07b3fef86710fe0b72e48df28907fd89488';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [getImageColor].
@ProviderFor(getImageColor)
const getImageColorProvider = GetImageColorFamily();

/// See also [getImageColor].
class GetImageColorFamily extends Family<AsyncValue<PaletteGenerator>> {
  /// See also [getImageColor].
  const GetImageColorFamily();

  /// See also [getImageColor].
  GetImageColorProvider call(
    ImageProvider<Object> imageProvider,
  ) {
    return GetImageColorProvider(
      imageProvider,
    );
  }

  @override
  GetImageColorProvider getProviderOverride(
    covariant GetImageColorProvider provider,
  ) {
    return call(
      provider.imageProvider,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getImageColorProvider';
}

/// See also [getImageColor].
class GetImageColorProvider
    extends AutoDisposeFutureProvider<PaletteGenerator> {
  /// See also [getImageColor].
  GetImageColorProvider(
    ImageProvider<Object> imageProvider,
  ) : this._internal(
          (ref) => getImageColor(
            ref as GetImageColorRef,
            imageProvider,
          ),
          from: getImageColorProvider,
          name: r'getImageColorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getImageColorHash,
          dependencies: GetImageColorFamily._dependencies,
          allTransitiveDependencies:
              GetImageColorFamily._allTransitiveDependencies,
          imageProvider: imageProvider,
        );

  GetImageColorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.imageProvider,
  }) : super.internal();

  final ImageProvider<Object> imageProvider;

  @override
  Override overrideWith(
    FutureOr<PaletteGenerator> Function(GetImageColorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetImageColorProvider._internal(
        (ref) => create(ref as GetImageColorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        imageProvider: imageProvider,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PaletteGenerator> createElement() {
    return _GetImageColorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetImageColorProvider &&
        other.imageProvider == imageProvider;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, imageProvider.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetImageColorRef on AutoDisposeFutureProviderRef<PaletteGenerator> {
  /// The parameter `imageProvider` of this provider.
  ImageProvider<Object> get imageProvider;
}

class _GetImageColorProviderElement
    extends AutoDisposeFutureProviderElement<PaletteGenerator>
    with GetImageColorRef {
  _GetImageColorProviderElement(super.provider);

  @override
  ImageProvider<Object> get imageProvider =>
      (origin as GetImageColorProvider).imageProvider;
}

String _$currentSongLyricsHash() => r'3c035b3829885697651cf13068de64db9c540f88';

/// 当前播放歌曲的歌词
///
/// Copied from [currentSongLyrics].
@ProviderFor(currentSongLyrics)
final currentSongLyricsProvider =
    AutoDisposeFutureProvider<SongLyricWrap?>.internal(
  currentSongLyrics,
  name: r'currentSongLyricsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSongLyricsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentSongLyricsRef = AutoDisposeFutureProviderRef<SongLyricWrap?>;
String _$currentSongCommentsHash() =>
    r'92478d6473ece29cbaf23c57b68576351c3713d2';

/// 当前播放歌曲的评论
///
/// Copied from [currentSongComments].
@ProviderFor(currentSongComments)
final currentSongCommentsProvider =
    AutoDisposeFutureProvider<CommentListWrap?>.internal(
  currentSongComments,
  name: r'currentSongCommentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSongCommentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentSongCommentsRef = AutoDisposeFutureProviderRef<CommentListWrap?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
