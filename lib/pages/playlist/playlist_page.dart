import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/pages/main/phone/widgets.dart';
import 'package:bujuan_music/pages/main/provider.dart';
import 'package:bujuan_music/pages/playlist/provider.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music/widgets/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../utils/adaptive_screen_utils.dart';
import '../../widgets/loading.dart';

class PlaylistPage extends ConsumerWidget {
  final int id;

  const PlaylistPage(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool desktop = medium(context) || expanded(context);
    final album = ref.watch(playlistDetailProvider(id));
    return Scaffold(
      body: album.when(
        data: (details) =>
        desktop ? DesktopPlayList(details: details) : MobilePlayList(details: details),
        loading: () => const Center(child: LoadingIndicator()),
        error: (_, __) => const Center(child: Text('Oops, something unexpected happened')),
      ),
    );
  }
}

class MobilePlayList extends ConsumerStatefulWidget {
  final PlaylistData details;

  const MobilePlayList({super.key, required this.details});

  @override
  ConsumerState<MobilePlayList> createState() => _MobilePlayListState();
}

class _MobilePlayListState extends ConsumerState<MobilePlayList> {
  final ScrollController _scrollController = ScrollController();
  String? _lastScrolledToId; // 记录上次滚动到的歌曲 ID

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentSong(MediaItem? currentMedia) {
    if (currentMedia == null) return;
    // 只有当歌曲变化时才滚动
    if (_lastScrolledToId == currentMedia.id) return;

    final index = widget.details.medias.indexWhere((m) => m.id == currentMedia.id);
    if (index != -1) {
      _lastScrolledToId = currentMedia.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final targetOffset = index * 68.w; // 估算每项高度
          _scrollController.animateTo(
            targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听当前播放歌曲 - 使用 valueOrNull 确保安全访问
    final currentMedia = ref.watch(mediaItemProvider).valueOrNull;

    // 首次加载时滚动到当前歌曲
    _scrollToCurrentSong(currentMedia);

    return Scaffold(
      appBar: AppBar(title: Text(widget.details.detail.playlist?.name ?? '')),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList.builder(
            itemCount: widget.details.medias.length,
            itemBuilder: (context, index) => MediaItemWidget(
              mediaItem: widget.details.medias[index],
              onTap: () => BujuanMusicHandler().updateQueue(widget.details.medias, index: index),
            ),
          ),
          SliverToBoxAdapter(
            child: DynamicPadding(hasBottom: false),
          )
        ],
      ),
    );
  }
}

class DesktopPlayList extends ConsumerStatefulWidget {
  final PlaylistData details;

  const DesktopPlayList({super.key, required this.details});

  @override
  ConsumerState<DesktopPlayList> createState() => _DesktopPlayListState();
}

class _DesktopPlayListState extends ConsumerState<DesktopPlayList> {
  final ScrollController _scrollController = ScrollController();
  String? _lastScrolledToId; // 记录上次滚动到的歌曲 ID

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentSong(MediaItem? currentMedia) {
    if (currentMedia == null) return;
    // 只有当歌曲变化时才滚动
    if (_lastScrolledToId == currentMedia.id) return;

    final index = widget.details.medias.indexWhere((m) => m.id == currentMedia.id);
    if (index != -1) {
      _lastScrolledToId = currentMedia.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          final targetOffset = index * 68.w;
          _scrollController.animateTo(
            targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听当前播放歌曲 - 使用 valueOrNull 确保安全访问
    final currentMedia = ref.watch(mediaItemProvider).valueOrNull;

    // 首次加载时滚动到当前歌曲
    _scrollToCurrentSong(currentMedia);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(), icon: Icon(HugeIcons.strokeRoundedCancel01)),
        title: Text(widget.details.detail.playlist?.name ?? ''),
        backgroundColor: Colors.transparent,
      ),
      body: Row(
        children: [
          SizedBox(
            width: 260.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
              child: Column(
                children: [
                  CachedImage(
                    imageUrl: widget.details.detail.playlist?.coverImgUrl ?? '',
                    width: 200.w,
                    height: 200.w,
                    borderRadius: 100.w,
                  ),
                  SizedBox(height: 20.w),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          widget.details.detail.playlist?.description ?? '暂无描述！！',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(top: 0, bottom: 45.w),
            itemCount: widget.details.medias.length,
            itemBuilder: (context, index) => MediaItemWidget(
              mediaItem: widget.details.medias[index],
              onTap: () => BujuanMusicHandler().updateQueue(widget.details.medias, index: index),
            ),
          ))
        ],
      ),
    );
  }
}
