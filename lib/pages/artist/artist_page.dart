import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/pages/artist/provider.dart';
import 'package:bujuan_music/pages/main/phone/widgets.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music/widgets/items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../utils/adaptive_screen_utils.dart';
import '../../widgets/loading.dart';

class ArtistPage extends ConsumerWidget {
  final int id;

  const ArtistPage(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool desktop = medium(context) || expanded(context);
    final artist = ref.watch(artistDetailProvider(id));
    return Scaffold(
      body: artist.when(
        data: (details) =>
            desktop ? DesktopArtist(details: details) : MobileArtist(details: details),
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, stack) {
          print('Artist page error: $error');
          print('Stack: $stack');
          return const Center(child: Text('Oops, something unexpected happened'));
        },
      ),
    );
  }
}

class MobileArtist extends StatelessWidget {
  final ArtistData details;

  const MobileArtist({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(details.artist.name ?? ''),
      ),
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
            child: DynamicPadding(
              hasBottom: false,
            ),
          )
        ],
      ),
    );
  }
}

class DesktopArtist extends StatelessWidget {
  final ArtistData details;

  const DesktopArtist({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(), icon: Icon(HugeIcons.strokeRoundedCancel01)),
        title: Text(details.artist.name ?? ''),
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
                    imageUrl: details.artist.picUrl ?? '',
                    width: 200.w,
                    height: 200.w,
                    borderRadius: 100.w,
                  ),
                  SizedBox(height: 20.w),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (details.artist.briefDesc?.isNotEmpty == true)
                            Text(
                              details.artist.briefDesc ?? '',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          if (details.artist.briefDesc?.isNotEmpty == true) SizedBox(height: 10.w),
                          if (details.artist.musicSize != null)
                            Text(
                              '音乐数: ${details.artist.musicSize}',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          if (details.artist.musicSize != null) SizedBox(height: 10.w),
                          if (details.artist.albumSize != null)
                            Text(
                              '专辑数: ${details.artist.albumSize}',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          if (details.artist.albumSize != null) SizedBox(height: 10.w),
                          Text(
                            '热门歌曲: ${details.medias.length} 首',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                        ],
                      ),
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
