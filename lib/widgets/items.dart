import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../router/app_router.dart';

class MediaItemWidget extends StatelessWidget {
  final MediaItem mediaItem;
  final VoidCallback? onTap;

  const MediaItemWidget({super.key, required this.mediaItem, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.w),
      leading: CachedImage(
        imageUrl: mediaItem.artUri?.toString() ?? '',
        width: 42.w,
        height: 42.w,
        borderRadius: 24.w,
        pWidth: 100,
        pHeight: 100,
      ),
      title: Text(mediaItem.title,style: TextStyle(fontSize: 14.sp),),
      subtitle: Text(mediaItem.artist ?? '',style: TextStyle(fontSize: 12.sp),),
      trailing: mediaItem.extras?['mv'] != 0
          ? IconButton(
              onPressed: () {
                BujuanMusicHandler().pause();
                context.push(AppRouter.mv, extra: mediaItem.extras?['mv']);
              },
              icon: Icon(HugeIcons.strokeRoundedTv01, size: 20.sp))
          : null,
      onTap: () => onTap?.call(),
    );
  }
}
