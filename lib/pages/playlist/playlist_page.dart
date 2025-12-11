import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/pages/main/phone/widgets.dart';
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

class MobilePlayList extends StatelessWidget {
  final PlaylistData details;

  const MobilePlayList({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(details.detail.playlist?.name??''),),
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: details.medias.length,
            itemBuilder: (context, index) => MediaItemWidget(
              mediaItem: details.medias[index],
              onTap: () => BujuanMusicHandler().updateQueue(details.medias, index: index),
            ),
          ),
          SliverToBoxAdapter(
            child: DynamicPadding(hasBottom: false,),
          )
        ],
      ),
    );
  }
}

class DesktopPlayList extends StatelessWidget {
  final PlaylistData details;

  const DesktopPlayList({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(), icon: Icon(HugeIcons.strokeRoundedCancel01)),
        title: Text(details.detail.playlist?.name ?? ''),
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
                    imageUrl: details.detail.playlist?.coverImgUrl ?? '',
                    width: 200.w,
                    height: 200.w,
                    borderRadius: 100.w,
                  ),
                  SizedBox(height: 20.w),
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Text(
                          details.detail.playlist?.description ?? '暂无描述！！',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ))
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
            padding: EdgeInsets.only(top: 0, bottom: 45.w),
            itemCount: details.medias.length,
            itemBuilder: (context, index) => MediaItemWidget(
              mediaItem: details.medias[index],
              onTap: () => BujuanMusicHandler().updateQueue(details.medias, index: index),
            ),
          ))
        ],
      ),
    );
  }
}
