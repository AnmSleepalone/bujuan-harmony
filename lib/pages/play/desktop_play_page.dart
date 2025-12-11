import 'package:bujuan_music/pages/main/provider.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class DesktopPlayPage extends StatelessWidget {
  const DesktopPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: SizedBox.shrink(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () => context.pop(), icon: Icon(HugeIcons.strokeRoundedCancel01)),
            Text('Now Playing')
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: Row(
          children: [
            PlayInfoView(),
          ],
        ),
      ),
    );
  }
}

class PlayInfoView extends ConsumerWidget {
  const PlayInfoView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var media = ref.watch(mediaItemProvider).value;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CachedImage(
          imageUrl: media?.artUri.toString() ?? '',
          width: 240.w,
          height: 240.w,
          pWidth: 600,
          pHeight: 600,
          borderRadius: 120.w,
        ),//唱片
        SizedBox(height: 20.w),
        Text(media?.title??'',style: TextStyle(fontSize: 20.sp),),
        SizedBox(height: 10.w),
        Text(media?.artist??'',style: TextStyle(fontSize: 14.sp),),
      ],
    );
  }
}
