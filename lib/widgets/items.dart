import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

import '../pages/main/provider.dart';
import '../router/app_router.dart';

class MediaItemWidget extends ConsumerStatefulWidget {
  final MediaItem mediaItem;
  final VoidCallback? onTap;

  const MediaItemWidget({super.key, required this.mediaItem, this.onTap});

  @override
  ConsumerState<MediaItemWidget> createState() => _MediaItemWidgetState();
}

class _MediaItemWidgetState extends ConsumerState<MediaItemWidget> {
  bool _isLoading = false;

  void _handleTap() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    widget.onTap?.call();

    // 短暂延迟后恢复状态
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 监听当前播放的歌曲 - 使用 valueOrNull 确保安全访问
    final asyncMedia = ref.watch(mediaItemProvider);
    final currentMedia = asyncMedia.valueOrNull;
    final isPlaying = currentMedia?.id == widget.mediaItem.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleTap,
        splashColor: Color(0XFF1ED760).withAlpha(30),
        highlightColor: Color(0XFF1ED760).withAlpha(20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
          child: Row(
            children: [
              // 封面图片
              Stack(
                children: [
                  CachedImage(
                    imageUrl: widget.mediaItem.artUri?.toString() ?? '',
                    width: 48.w,
                    height: 48.w,
                    borderRadius: 8.w,
                    pWidth: 100,
                    pHeight: 100,
                  ),
                  // 正在播放指示器
                  if (isPlaying)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(100),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Icon(
                          HugeIcons.strokeRoundedMusicNote03,
                          color: Color(0XFF1ED760),
                          size: 20.w,
                        ),
                      ),
                    ),
                  // 加载中指示器
                  if (_isLoading && !isPlaying)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(100),
                          borderRadius: BorderRadius.circular(8.w),
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0XFF1ED760)),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              // 歌曲信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mediaItem.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isPlaying ? FontWeight.w600 : FontWeight.normal,
                        color: isPlaying ? Color(0XFF1ED760) : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.w),
                    Text(
                      widget.mediaItem.artist ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // MV 按钮
              if (widget.mediaItem.extras?['mv'] != 0)
                IconButton(
                  onPressed: () {
                    BujuanMusicHandler().pause();
                    context.push(AppRouter.mv, extra: widget.mediaItem.extras?['mv']);
                  },
                  icon: Icon(HugeIcons.strokeRoundedTv01, size: 20.sp),
                ),
              // 播放中指示
              if (isPlaying)
                Icon(
                  HugeIcons.strokeRoundedVolumeHigh,
                  size: 18.sp,
                  color: Color(0XFF1ED760),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
