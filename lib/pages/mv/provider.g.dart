// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mvUrlHash() => r'6e5f6cb2b608bd1fb38feb8774f531e275caf60f';

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

/// See also [mvUrl].
@ProviderFor(mvUrl)
const mvUrlProvider = MvUrlFamily();

/// See also [mvUrl].
class MvUrlFamily extends Family<AsyncValue<MvData>> {
  /// See also [mvUrl].
  const MvUrlFamily();

  /// See also [mvUrl].
  MvUrlProvider call(
    int id,
  ) {
    return MvUrlProvider(
      id,
    );
  }

  @override
  MvUrlProvider getProviderOverride(
    covariant MvUrlProvider provider,
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
  String? get name => r'mvUrlProvider';
}

/// See also [mvUrl].
class MvUrlProvider extends AutoDisposeFutureProvider<MvData> {
  /// See also [mvUrl].
  MvUrlProvider(
    int id,
  ) : this._internal(
          (ref) => mvUrl(
            ref as MvUrlRef,
            id,
          ),
          from: mvUrlProvider,
          name: r'mvUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mvUrlHash,
          dependencies: MvUrlFamily._dependencies,
          allTransitiveDependencies: MvUrlFamily._allTransitiveDependencies,
          id: id,
        );

  MvUrlProvider._internal(
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
    FutureOr<MvData> Function(MvUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MvUrlProvider._internal(
        (ref) => create(ref as MvUrlRef),
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
  AutoDisposeFutureProviderElement<MvData> createElement() {
    return _MvUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MvUrlProvider && other.id == id;
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
mixin MvUrlRef on AutoDisposeFutureProviderRef<MvData> {
  /// The parameter `id` of this provider.
  int get id;
}

class _MvUrlProviderElement extends AutoDisposeFutureProviderElement<MvData>
    with MvUrlRef {
  _MvUrlProviderElement(super.provider);

  @override
  int get id => (origin as MvUrlProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
