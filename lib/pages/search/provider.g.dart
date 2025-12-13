// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hotSearchListHash() => r'45a50f0e7dbefd8cb2cb7f7738db10ab20f39436';

/// See also [hotSearchList].
@ProviderFor(hotSearchList)
final hotSearchListProvider =
    AutoDisposeFutureProvider<List<SearchKeyDetailedItem>>.internal(
  hotSearchList,
  name: r'hotSearchListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hotSearchListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HotSearchListRef
    = AutoDisposeFutureProviderRef<List<SearchKeyDetailedItem>>;
String _$searchSuggestHash() => r'4b82d756b73729667d962e68cda666f19601fc68';

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

/// See also [searchSuggest].
@ProviderFor(searchSuggest)
const searchSuggestProvider = SearchSuggestFamily();

/// See also [searchSuggest].
class SearchSuggestFamily extends Family<AsyncValue<SearchSuggestWrapX>> {
  /// See also [searchSuggest].
  const SearchSuggestFamily();

  /// See also [searchSuggest].
  SearchSuggestProvider call(
    String keyword,
  ) {
    return SearchSuggestProvider(
      keyword,
    );
  }

  @override
  SearchSuggestProvider getProviderOverride(
    covariant SearchSuggestProvider provider,
  ) {
    return call(
      provider.keyword,
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
  String? get name => r'searchSuggestProvider';
}

/// See also [searchSuggest].
class SearchSuggestProvider
    extends AutoDisposeFutureProvider<SearchSuggestWrapX> {
  /// See also [searchSuggest].
  SearchSuggestProvider(
    String keyword,
  ) : this._internal(
          (ref) => searchSuggest(
            ref as SearchSuggestRef,
            keyword,
          ),
          from: searchSuggestProvider,
          name: r'searchSuggestProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchSuggestHash,
          dependencies: SearchSuggestFamily._dependencies,
          allTransitiveDependencies:
              SearchSuggestFamily._allTransitiveDependencies,
          keyword: keyword,
        );

  SearchSuggestProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
  }) : super.internal();

  final String keyword;

  @override
  Override overrideWith(
    FutureOr<SearchSuggestWrapX> Function(SearchSuggestRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchSuggestProvider._internal(
        (ref) => create(ref as SearchSuggestRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SearchSuggestWrapX> createElement() {
    return _SearchSuggestProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSuggestProvider && other.keyword == keyword;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchSuggestRef on AutoDisposeFutureProviderRef<SearchSuggestWrapX> {
  /// The parameter `keyword` of this provider.
  String get keyword;
}

class _SearchSuggestProviderElement
    extends AutoDisposeFutureProviderElement<SearchSuggestWrapX>
    with SearchSuggestRef {
  _SearchSuggestProviderElement(super.provider);

  @override
  String get keyword => (origin as SearchSuggestProvider).keyword;
}

String _$searchSongsHash() => r'aec350dce25b5a53fc2b4dc6b4ff2cdf4c8e4efb';

/// See also [searchSongs].
@ProviderFor(searchSongs)
const searchSongsProvider = SearchSongsFamily();

/// See also [searchSongs].
class SearchSongsFamily extends Family<AsyncValue<SearchResultData>> {
  /// See also [searchSongs].
  const SearchSongsFamily();

  /// See also [searchSongs].
  SearchSongsProvider call(
    String keyword, {
    int offset = 0,
  }) {
    return SearchSongsProvider(
      keyword,
      offset: offset,
    );
  }

  @override
  SearchSongsProvider getProviderOverride(
    covariant SearchSongsProvider provider,
  ) {
    return call(
      provider.keyword,
      offset: provider.offset,
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
  String? get name => r'searchSongsProvider';
}

/// See also [searchSongs].
class SearchSongsProvider extends AutoDisposeFutureProvider<SearchResultData> {
  /// See also [searchSongs].
  SearchSongsProvider(
    String keyword, {
    int offset = 0,
  }) : this._internal(
          (ref) => searchSongs(
            ref as SearchSongsRef,
            keyword,
            offset: offset,
          ),
          from: searchSongsProvider,
          name: r'searchSongsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchSongsHash,
          dependencies: SearchSongsFamily._dependencies,
          allTransitiveDependencies:
              SearchSongsFamily._allTransitiveDependencies,
          keyword: keyword,
          offset: offset,
        );

  SearchSongsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
    required this.offset,
  }) : super.internal();

  final String keyword;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<SearchResultData> Function(SearchSongsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchSongsProvider._internal(
        (ref) => create(ref as SearchSongsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SearchResultData> createElement() {
    return _SearchSongsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSongsProvider &&
        other.keyword == keyword &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchSongsRef on AutoDisposeFutureProviderRef<SearchResultData> {
  /// The parameter `keyword` of this provider.
  String get keyword;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _SearchSongsProviderElement
    extends AutoDisposeFutureProviderElement<SearchResultData>
    with SearchSongsRef {
  _SearchSongsProviderElement(super.provider);

  @override
  String get keyword => (origin as SearchSongsProvider).keyword;
  @override
  int get offset => (origin as SearchSongsProvider).offset;
}

String _$searchAlbumsHash() => r'7e0760a2f8854bccbe2dee3c2cb2eb287094f101';

/// See also [searchAlbums].
@ProviderFor(searchAlbums)
const searchAlbumsProvider = SearchAlbumsFamily();

/// See also [searchAlbums].
class SearchAlbumsFamily extends Family<AsyncValue<List<Album>>> {
  /// See also [searchAlbums].
  const SearchAlbumsFamily();

  /// See also [searchAlbums].
  SearchAlbumsProvider call(
    String keyword, {
    int offset = 0,
  }) {
    return SearchAlbumsProvider(
      keyword,
      offset: offset,
    );
  }

  @override
  SearchAlbumsProvider getProviderOverride(
    covariant SearchAlbumsProvider provider,
  ) {
    return call(
      provider.keyword,
      offset: provider.offset,
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
  String? get name => r'searchAlbumsProvider';
}

/// See also [searchAlbums].
class SearchAlbumsProvider extends AutoDisposeFutureProvider<List<Album>> {
  /// See also [searchAlbums].
  SearchAlbumsProvider(
    String keyword, {
    int offset = 0,
  }) : this._internal(
          (ref) => searchAlbums(
            ref as SearchAlbumsRef,
            keyword,
            offset: offset,
          ),
          from: searchAlbumsProvider,
          name: r'searchAlbumsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchAlbumsHash,
          dependencies: SearchAlbumsFamily._dependencies,
          allTransitiveDependencies:
              SearchAlbumsFamily._allTransitiveDependencies,
          keyword: keyword,
          offset: offset,
        );

  SearchAlbumsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
    required this.offset,
  }) : super.internal();

  final String keyword;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<List<Album>> Function(SearchAlbumsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchAlbumsProvider._internal(
        (ref) => create(ref as SearchAlbumsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Album>> createElement() {
    return _SearchAlbumsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchAlbumsProvider &&
        other.keyword == keyword &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchAlbumsRef on AutoDisposeFutureProviderRef<List<Album>> {
  /// The parameter `keyword` of this provider.
  String get keyword;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _SearchAlbumsProviderElement
    extends AutoDisposeFutureProviderElement<List<Album>> with SearchAlbumsRef {
  _SearchAlbumsProviderElement(super.provider);

  @override
  String get keyword => (origin as SearchAlbumsProvider).keyword;
  @override
  int get offset => (origin as SearchAlbumsProvider).offset;
}

String _$searchArtistsHash() => r'687c86d2332487e4c653c708419d42667af5c722';

/// See also [searchArtists].
@ProviderFor(searchArtists)
const searchArtistsProvider = SearchArtistsFamily();

/// See also [searchArtists].
class SearchArtistsFamily extends Family<AsyncValue<List<Artists>>> {
  /// See also [searchArtists].
  const SearchArtistsFamily();

  /// See also [searchArtists].
  SearchArtistsProvider call(
    String keyword, {
    int offset = 0,
  }) {
    return SearchArtistsProvider(
      keyword,
      offset: offset,
    );
  }

  @override
  SearchArtistsProvider getProviderOverride(
    covariant SearchArtistsProvider provider,
  ) {
    return call(
      provider.keyword,
      offset: provider.offset,
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
  String? get name => r'searchArtistsProvider';
}

/// See also [searchArtists].
class SearchArtistsProvider extends AutoDisposeFutureProvider<List<Artists>> {
  /// See also [searchArtists].
  SearchArtistsProvider(
    String keyword, {
    int offset = 0,
  }) : this._internal(
          (ref) => searchArtists(
            ref as SearchArtistsRef,
            keyword,
            offset: offset,
          ),
          from: searchArtistsProvider,
          name: r'searchArtistsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchArtistsHash,
          dependencies: SearchArtistsFamily._dependencies,
          allTransitiveDependencies:
              SearchArtistsFamily._allTransitiveDependencies,
          keyword: keyword,
          offset: offset,
        );

  SearchArtistsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
    required this.offset,
  }) : super.internal();

  final String keyword;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<List<Artists>> Function(SearchArtistsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchArtistsProvider._internal(
        (ref) => create(ref as SearchArtistsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Artists>> createElement() {
    return _SearchArtistsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchArtistsProvider &&
        other.keyword == keyword &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchArtistsRef on AutoDisposeFutureProviderRef<List<Artists>> {
  /// The parameter `keyword` of this provider.
  String get keyword;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _SearchArtistsProviderElement
    extends AutoDisposeFutureProviderElement<List<Artists>>
    with SearchArtistsRef {
  _SearchArtistsProviderElement(super.provider);

  @override
  String get keyword => (origin as SearchArtistsProvider).keyword;
  @override
  int get offset => (origin as SearchArtistsProvider).offset;
}

String _$searchPlaylistsHash() => r'939352e344c344d28fe0254e4ebcf86db5c13278';

/// See also [searchPlaylists].
@ProviderFor(searchPlaylists)
const searchPlaylistsProvider = SearchPlaylistsFamily();

/// See also [searchPlaylists].
class SearchPlaylistsFamily extends Family<AsyncValue<List<Play>>> {
  /// See also [searchPlaylists].
  const SearchPlaylistsFamily();

  /// See also [searchPlaylists].
  SearchPlaylistsProvider call(
    String keyword, {
    int offset = 0,
  }) {
    return SearchPlaylistsProvider(
      keyword,
      offset: offset,
    );
  }

  @override
  SearchPlaylistsProvider getProviderOverride(
    covariant SearchPlaylistsProvider provider,
  ) {
    return call(
      provider.keyword,
      offset: provider.offset,
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
  String? get name => r'searchPlaylistsProvider';
}

/// See also [searchPlaylists].
class SearchPlaylistsProvider extends AutoDisposeFutureProvider<List<Play>> {
  /// See also [searchPlaylists].
  SearchPlaylistsProvider(
    String keyword, {
    int offset = 0,
  }) : this._internal(
          (ref) => searchPlaylists(
            ref as SearchPlaylistsRef,
            keyword,
            offset: offset,
          ),
          from: searchPlaylistsProvider,
          name: r'searchPlaylistsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchPlaylistsHash,
          dependencies: SearchPlaylistsFamily._dependencies,
          allTransitiveDependencies:
              SearchPlaylistsFamily._allTransitiveDependencies,
          keyword: keyword,
          offset: offset,
        );

  SearchPlaylistsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.keyword,
    required this.offset,
  }) : super.internal();

  final String keyword;
  final int offset;

  @override
  Override overrideWith(
    FutureOr<List<Play>> Function(SearchPlaylistsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchPlaylistsProvider._internal(
        (ref) => create(ref as SearchPlaylistsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        keyword: keyword,
        offset: offset,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Play>> createElement() {
    return _SearchPlaylistsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchPlaylistsProvider &&
        other.keyword == keyword &&
        other.offset == offset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, keyword.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchPlaylistsRef on AutoDisposeFutureProviderRef<List<Play>> {
  /// The parameter `keyword` of this provider.
  String get keyword;

  /// The parameter `offset` of this provider.
  int get offset;
}

class _SearchPlaylistsProviderElement
    extends AutoDisposeFutureProviderElement<List<Play>>
    with SearchPlaylistsRef {
  _SearchPlaylistsProviderElement(super.provider);

  @override
  String get keyword => (origin as SearchPlaylistsProvider).keyword;
  @override
  int get offset => (origin as SearchPlaylistsProvider).offset;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
