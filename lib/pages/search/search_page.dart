import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/pages/search/provider.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music/widgets/items.dart';
import 'package:bujuan_music/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  String _searchKeyword = '';
  bool _showSearchResult = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch(String keyword) {
    if (keyword.trim().isEmpty) return;
    setState(() {
      _searchKeyword = keyword.trim();
      _showSearchResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '搜索歌曲、专辑、歌手、歌单',
            border: InputBorder.none,
            hintStyle: TextStyle(fontSize: 16.sp),
          ),
          style: TextStyle(fontSize: 16.sp),
          textInputAction: TextInputAction.search,
          onSubmitted: _performSearch,
          onChanged: (value) {
            // 当输入框清空时，返回热搜列表
            if (value.trim().isEmpty && _showSearchResult) {
              setState(() {
                _showSearchResult = false;
                _searchKeyword = '';
              });
            }
          },
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(HugeIcons.strokeRoundedCancel01),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _showSearchResult = false;
                  _searchKeyword = '';
                });
              },
            ),
          IconButton(
            icon: Icon(HugeIcons.strokeRoundedSearch01),
            onPressed: () => _performSearch(_searchController.text),
          ),
        ],
      ),
      body: _showSearchResult
          ? _buildSearchResult()
          : _buildHotSearchList(),
    );
  }

  // 热搜列表
  Widget _buildHotSearchList() {
    final hotSearch = ref.watch(hotSearchListProvider);
    return hotSearch.when(
      data: (list) => ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return ListTile(
            leading: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: index < 3 ? FontWeight.bold : FontWeight.normal,
                color: index < 3 ? Colors.red : null,
              ),
            ),
            title: Text(item.searchWord ?? ''),
            subtitle: item.content != null ? Text(item.content!, maxLines: 1) : null,
            onTap: () {
              _searchController.text = item.searchWord ?? '';
              _performSearch(item.searchWord ?? '');
            },
          );
        },
      ),
      loading: () => const Center(child: LoadingIndicator()),
      error: (_, __) => const Center(child: Text('加载热搜失败')),
    );
  }

  // 搜索结果
  Widget _buildSearchResult() {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '单曲'),
            Tab(text: '专辑'),
            Tab(text: '歌手'),
            Tab(text: '歌单'),
          ],
          // 1. 设置选中时的字体颜色 (例如：红色)
          labelColor: Colors.red,
          // 2. 设置未选中时的字体颜色 (例如：灰色)
          unselectedLabelColor: Colors.grey,
          // 3. (可选) 设置选中时的字体样式（例如：加粗）
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          // 4. (可选) 设置未选中时的字体样式
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSongList(),
              _buildAlbumList(),
              _buildArtistList(),
              _buildPlaylistList(),
            ],
          ),
        ),
      ],
    );
  }

  // 歌曲列表
  Widget _buildSongList() {
    final searchResult = ref.watch(searchSongsProvider(_searchKeyword));
    return searchResult.when(
      data: (result) {
        if (result.medias.isEmpty) {
          return const Center(child: Text('暂无结果'));
        }
        return ListView.builder(
          itemCount: result.medias.length,
          itemBuilder: (context, index) => MediaItemWidget(
            mediaItem: result.medias[index],
            onTap: () => BujuanMusicHandler().updateQueue(result.medias, index: index),
          ),
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (_, __) => const Center(child: Text('搜索失败')),
    );
  }

  // 专辑列表
  Widget _buildAlbumList() {
    final albums = ref.watch(searchAlbumsProvider(_searchKeyword));
    return albums.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('暂无结果'));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final album = list[index];
            return ListTile(
              leading: CachedImage(
                imageUrl: album.picUrl ?? '',
                width: 50.w,
                height: 50.w,
                borderRadius: 8.w,
              ),
              title: Text(album.name ?? ''),
              subtitle: Text(album.artist?.name ?? ''),
              onTap: () {
                final id = int.tryParse(album.id?.toString() ?? '0') ?? 0;
                context.push(AppRouter.playlist, extra: id);
              },
            );
          },
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (_, __) => const Center(child: Text('搜索失败')),
    );
  }

  // 歌手列表
  Widget _buildArtistList() {
    final artists = ref.watch(searchArtistsProvider(_searchKeyword));
    return artists.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('暂无结果'));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final artist = list[index];
            return ListTile(
              leading: CachedImage(
                imageUrl: artist.picUrl ?? '',
                width: 50.w,
                height: 50.w,
                borderRadius: 25.w,
              ),
              title: Text(artist.name ?? ''),
              subtitle: Text('专辑: ${artist.albumSize ?? 0}'),
              onTap: () {
                final id = int.tryParse(artist.id.toString()) ?? 0;
                context.push(AppRouter.artist, extra: id);
              },
            );
          },
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (_, __) => const Center(child: Text('搜索失败')),
    );
  }

  // 歌单列表
  Widget _buildPlaylistList() {
    final playlists = ref.watch(searchPlaylistsProvider(_searchKeyword));
    return playlists.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(child: Text('暂无结果'));
        }
        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final playlist = list[index];
            return ListTile(
              leading: CachedImage(
                imageUrl: playlist.coverImgUrl ?? '',
                width: 50.w,
                height: 50.w,
                borderRadius: 8.w,
              ),
              title: Text(playlist.name ?? ''),
              subtitle: Text('${playlist.trackCount ?? 0} 首歌曲'),
              onTap: () {
                final id = int.tryParse(playlist.id?.toString() ?? '0') ?? 0;
                context.push(AppRouter.playlist, extra: id);
              },
            );
          },
        );
      },
      loading: () => const Center(child: LoadingIndicator()),
      error: (_, __) => const Center(child: Text('搜索失败')),
    );
  }
}
