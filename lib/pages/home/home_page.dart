import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/common/values/app_images.dart';
import 'package:bujuan_music/pages/home/provider.dart';
import 'package:bujuan_music/pages/main/phone/widgets.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music/widgets/items.dart';
import 'package:bujuan_music/widgets/loading.dart';
import 'package:bujuan_music/widgets/main_appbar.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../utils/adaptive_screen_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  //粒子
  @override
  Widget build(BuildContext context) {
    bool desktop = medium(context) || expanded(context);
    return Scaffold(
      appBar: desktop ? null : mainAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final album = ref.watch(newAlbumProvider);
          return album.when(
            data: (homeData) =>
                desktop ? DesktopHome(homeData: homeData) : MobileHome(homeData: homeData),
            loading: () => const Center(child: LoadingIndicator()),
            error: (_, __) => const Center(child: Text('Oops, something unexpected happened')),
          );
        },
      ),
    );
  }
}

class MobileHome extends StatelessWidget {
  final HomeData homeData;

  const MobileHome({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    return _buildContent(homeData, context);
  }

  Widget _buildContent(HomeData homeData, BuildContext context) {
    final aristList = homeData.artistsListWrap.artists;
    final albumList = homeData.recommendPlayListWrap.recommend;
    final songList = homeData.medias;
    var of2 = MediaQuery.of(context);
    return CustomScrollView(
      slivers: [
        SliverPadding(padding: EdgeInsets.symmetric(vertical: 5.w)),
        SliverToBoxAdapter(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: GestureDetector(
            child: Image.asset(AppImages.banner, width: 345.w, height: 148.w, fit: BoxFit.fill),
            onTap: () => context.push(AppRouter.today),
          ),
        )),
        SliverToBoxAdapter(child: _buildTitle('Top Arist', onTap: () {})),
        SliverToBoxAdapter(child: _buildAristList(aristList)),
        SliverToBoxAdapter(child: _buildTitle('Top Album', onTap: () {})),
        SliverToBoxAdapter(child: _buildAlbumList(albumList)),
        SliverToBoxAdapter(child: _buildTitle('New Song', onTap: () {})),
        _buildSongList(songList),
        SliverToBoxAdapter(
          child: DynamicPadding(),
        )
      ],
    );
  }

  Widget _buildAlbumList(List<Play>? artists) {
    return SizedBox(
      height: 168.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        scrollDirection: Axis.horizontal,
        itemCount: artists?.length ?? 0,
        separatorBuilder: (_, __) => SizedBox(width: 15.w),
        itemBuilder: (context, index) {
          final album = artists?[index];
          return GestureDetector(
            child: SizedBox(
              width: 138.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedImage(
                    imageUrl: album?.picUrl ?? '',
                    width: 138.w,
                    height: 138.w,
                    pHeight: 300,
                    pWidth: 300,
                    fit: BoxFit.cover,
                    borderRadius: 16.w,
                  ),
                  SizedBox(height: 3.w),
                  Text(
                    '  ${album?.name}',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () {
              context.push(AppRouter.playlist, extra: artists?[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildAristList(List<Artists>? artists) {
    return SizedBox(
      height: 118.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        scrollDirection: Axis.horizontal,
        itemCount: artists?.length ?? 0,
        separatorBuilder: (_, __) => SizedBox(width: 15.w),
        itemBuilder: (context, index) {
          final album = artists?[index];
          return GestureDetector(
            child: SizedBox(
              width: 88.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CachedImage(
                    imageUrl: album?.picUrl ?? '',
                    width: 88.w,
                    height: 88.w,
                    pHeight: 200,
                    pWidth: 200,
                    fit: BoxFit.cover,
                    borderRadius: 44.w,
                  ),
                  SizedBox(height: 3.w),
                  Text(
                    '  ${album?.name}',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            onTap: () {
              context.push(AppRouter.playlist, extra: artists?[index].id);
            },
          );
        },
      ),
    );
  }

  Widget _buildSongList(List<MediaItem> songs) {
    return SliverList.builder(
      itemCount: songs.length > 20 ? 20 : songs.length,
      itemBuilder: (context, index) => MediaItemWidget(
        mediaItem: songs[index],
        onTap: () => BujuanMusicHandler().updateQueue(songs, index: index),
      ),
    );
  }

  Widget _buildTitle(String title, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.w),
      child: Row(
        children: [
          Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
          const Spacer(),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Text(
                    'See all',
                    style: TextStyle(
                        fontSize: 14.sp, color: Color(0XFF1ED760), fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.keyboard_arrow_right_outlined, size: 20.sp, color: Color(0XFF1ED760)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class DesktopHome extends StatelessWidget {
  final HomeData homeData;

  const DesktopHome({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    var recommend = homeData.recommendPlayListWrap.recommend;
    var medias = homeData.medias;
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.w),
          Text(
            'Top Recommendation',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.w),
          SizedBox(
            height: 190.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                child: Container(
                  width: 155.w,
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withAlpha(60)),
                      borderRadius: BorderRadius.circular(20.w)),
                  child: Column(
                    children: [
                      CachedImage(
                        imageUrl: recommend?[index].picUrl ?? '',
                        width: 150.w,
                        height: 150.w,
                        borderRadius: 20.w,
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        '  ${recommend[index].name}',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  context.push(AppRouter.playlist, extra: recommend[index].id);
                },
              ),
              itemCount: recommend!.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10.w),
            ),
          ),
          SizedBox(height: 20.w),
          Text(
            'Recommended daily',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.w),
          SizedBox(
            height: 130.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => GestureDetector(
                child: SizedBox(
                  width: 85.w,
                  child: Column(
                    children: [
                      CachedImage(
                        imageUrl: medias[index].artUri.toString() ?? '',
                        width: 80.w,
                        height: 80.w,
                        borderRadius: 40.w,
                      ),
                      SizedBox(height: 5.w),
                      Text(
                        medias[index].title,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.w),
                      Text(
                        medias[index].artist ?? '',
                        style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                onTap: () => BujuanMusicHandler().updateQueue(medias, index: index),
              ),
              itemCount: medias.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10.w),
            ),
          ),
        ],
      ),
    );
  }
}
