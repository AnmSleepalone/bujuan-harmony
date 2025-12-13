// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playlistDetailHash() => r'babd8e567a2b4302f5958cd7929399cd607c4839';

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

/// See also [playlistDetail].
@ProviderFor(playlistDetail)
const playlistDetailProvider = PlaylistDetailFamily();

/// See also [playlistDetail].
class PlaylistDetailFamily extends Family<AsyncValue<PlaylistData>> {
  /// See also [playlistDetail].
  const PlaylistDetailFamily();

  /// See also [playlistDetail].
  PlaylistDetailProvider call(
    int id,
  ) {
    return PlaylistDetailProvider(
      id,
    );
  }

  @override
  PlaylistDetailProvider getProviderOverride(
    covariant PlaylistDetailProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'playlistDetailProvider';
}

/// See also [playlistDetail].
class PlaylistDetailProvider extends AutoDisposeFutureProvider<PlaylistData> {
  /// See also [playlistDetail].
  PlaylistDetailProvider(
    int id,
  ) : this._internal(
          (ref) => playlistDetail(
            ref as PlaylistDetailRef,
            id,
          ),
          from: playlistDetailProvider,
          name: r'playlistDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$playlistDetailHash,
          dependencies: PlaylistDetailFamily._dependencies,
          allTransitiveDependencies:
              PlaylistDetailFamily._allTransitiveDependencies,
          id: id,
        );

  PlaylistDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<PlaylistData> Function(PlaylistDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PlaylistDetailProvider._internal(
        (ref) => create(ref as PlaylistDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<PlaylistData> createElement() {
    return _PlaylistDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlaylistDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlaylistDetailRef on AutoDisposeFutureProviderRef<PlaylistData> {
  /// The parameter `id` of this provider.
  int get id;
}

class _PlaylistDetailProviderElement
    extends AutoDisposeFutureProviderElement<PlaylistData>
    with PlaylistDetailRef {
  _PlaylistDetailProviderElement(super.provider);

  @override
  int get id => (origin as PlaylistDetailProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
