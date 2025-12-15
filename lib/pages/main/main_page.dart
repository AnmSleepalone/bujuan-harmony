import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/common/values/app_images.dart';
import 'package:bujuan_music/pages/main/menu_page.dart';
import 'package:bujuan_music/pages/main/phone/widgets.dart';
import 'package:bujuan_music/pages/main/provider.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music/widgets/backdrop.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../utils/adaptive_screen_utils.dart';


class MainPage extends StatelessWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    bool desktop = medium(context) || expanded(context);
    return Scaffold(
      body: desktop ? DesktopView(child: child) : MobileView(child: child),
    );
  }
}

class MobileView extends ConsumerWidget {
  final Widget child;

  const MobileView({super.key, required this.child});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // return SliderWidget(showBottomBar: true, child: child);
   var homeStyle = ref.watch(homeStyleProvider);
    return switch(homeStyle){
      HomeStyleType.draw => DrawerWidget(child: child),
      HomeStyleType.bottomBar => SliderWidget(showBottomBar: true, child: child),
    };
  }
}

class BottomData {
  IconData iconData;
  IconData activeIconData;
  String path;
  String title;

  BottomData(this.iconData, this.activeIconData, this.path, this.title);
}

class DesktopView extends StatelessWidget {
  final Widget child;

  const DesktopView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    var of = MediaQuery.of(context);
    return SizedBox(
      width: of.size.width,
      height: of.size.height,
      child: Stack(
        children: [
          // Consumer(builder: (context, ref, child) {
          //   var watch = ref.watch(backgroundModeNotifierProvider);
          //   return RivePlayer(
          //     asset: watch,
          //     fit: rive.Fit.cover,
          //     autoBind: true,
          //   );
          // }),
          Column(
            children: [
              SizedBox(height: 10.w),
              _buildSearch(),
              SizedBox(height: 10.w),
              Expanded(
                  child: Row(
                children: [
                  SizedBox(width: 10.w),
                  MenuPage(),
                  SizedBox(width: 10.w),
                  Expanded(child: BackdropView(child: child)),
                  SizedBox(width: 10.w),
                ],
              )),
              SizedBox(height: 10.w),
              _buildBottomBar(context),
              SizedBox(height: 10.w),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return GestureDetector(
      child: BackdropView(
        height: 52.w,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Wrap(
          runAlignment: WrapAlignment.center,
          children: [
            IconButton(
                onPressed: () => BujuanMusicHandler().skipToPrevious(),
                icon: Icon(
                  HugeIcons.strokeRoundedPrevious,
                  size: 22.sp,
                )),
            SizedBox(width: 10.w),
            Consumer(builder: (context, ref, child) {
              var playbackState = ref.watch(playbackStateProvider).value;
              return IconButton(
                  onPressed: () => BujuanMusicHandler().playOrPause(),
                  icon: Icon(
                    (playbackState?.playing ?? false) ? HugeIcons.strokeRoundedPause : HugeIcons.strokeRoundedPlay,
                    size: 22.sp,
                  ));
            }),
            SizedBox(width: 10.w),
            IconButton(
                onPressed: () => BujuanMusicHandler().skipToNext(),
                icon: Icon(
                  HugeIcons.strokeRoundedNext,
                  size: 22.sp,
                )),
            SizedBox(width: 15.w),
            Container(
              height: 40.w,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(20), borderRadius: BorderRadius.circular(30.w)),
              child: Consumer(builder: (context, ref, child) {
                var media = ref.watch(mediaItemProvider).value;
                return Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CachedImage(
                      imageUrl: media?.artUri.toString() ?? '',
                      width: 30.w,
                      height: 30.w,
                      borderRadius: 23.w,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      media?.title ?? '倦了',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    SizedBox(width: 15.w),
                    IconButton(onPressed: () {}, icon: Icon(HugeIcons.strokeRoundedFavourite)),
                  ],
                );
              }),
            ),
            SizedBox(width: 10.w),
            IconButton(onPressed: () {}, icon: Icon(HugeIcons.strokeRoundedVolumeHigh))
          ],
        ),
      ),
      onTap: () {
        var path = GoRouter.of(context).state.path;
        if (path == AppRouter.play) {
          context.pop();
          return;
        }
        context.push(AppRouter.play);
      },
    );
  }

  Widget _buildSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppImages.logo, width: 45.w, height: 45.w),
        SizedBox(width: 10.w),
        BackdropView(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          height: 46.w,
          width: 460.w,
          child: Row(
            children: [Icon(HugeIcons.strokeRoundedSearch02), SizedBox(width: 15.w), Text('Search Any...')],
          ),
        )
      ],
    );
  }
}
