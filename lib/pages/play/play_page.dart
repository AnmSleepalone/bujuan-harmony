import 'package:bujuan_music/common/bujuan_music_handler.dart';
import 'package:bujuan_music/utils/time_utils.dart';
import 'package:bujuan_music/widgets/backdrop.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:shadex/shadex.dart';
import '../../utils/color_utils.dart';
import '../../widgets/wave.dart';
import '../main/phone/widgets.dart';
import '../main/provider.dart';
import 'lyrics_sheet.dart';
import 'comment_sheet.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PanelBackground(),
        MusicControlsSection()
      ],
    );
  }
}

class PanelBackground extends ConsumerWidget {
  const PanelBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isDark = ref.watch(themeModeNotifierProvider) == ThemeMode.dark;
    Color scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    final color = ref.watch(mediaColorProvider).maybeWhen(
        data: (c) => ColorUtils.lightenColor(
            (isDark ? c.darkMutedColor?.color : c.dominantColor?.color) ?? scaffoldColor,
            isDark ? 0.2 : 0.8),
        orElse: () => scaffoldColor);
    final gradient = LinearGradient(
        colors: [color, scaffoldColor],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);
    return BackdropView(
      gradient: gradient,
      width: double.infinity,
      height: double.infinity,
      child: SizedBox.shrink(),
    );
  }
}

class MusicControlsSection extends StatelessWidget {
  const MusicControlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30.w,
          child: Transform(
            transform: Matrix4.translationValues(0, -15, 0),
            child: Icon(Icons.remove_rounded, color: Colors.grey.withAlpha(120), size: 62.w),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                AlbumWidget(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.w),
                  child: MusicProgressBar(),
                ),
                SizedBox(height: 60.w),
                const PlaybackControls(),
                SizedBox(height: 40.w),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 音乐进度条
class MusicProgressBar extends ConsumerWidget {
  const MusicProgressBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackState = ref.watch(
        playbackStateProvider.select((state) => state.value?.updatePosition ?? Duration.zero));
    final mediaItem = ref.watch(mediaItemProvider).value;
    final position = playbackState.inMilliseconds;
    final duration = mediaItem?.duration?.inMilliseconds ?? 0;
    final progress = (duration > 0) ? position / duration : 0.0;
    var color = Theme.of(context).iconTheme.color ?? Colors.white;
    var positionDuration = TimeUtils.formatDuration(position ~/ 1000);
    var durationDuration = TimeUtils.formatDuration(duration ~/ 1000);
    return Column(
      children: [
        SizedBox(
          height: 30.w,
          child: RepaintBoundary(
            child: WaveformProgressWidget(
              progress: progress,
              min: 0,
              max: 1,
              playedColor: color.withAlpha(150),
              unplayedColor: color.withAlpha(100),
              // thumbColor: Colors.transparent,
              onChangeEnd: (value) {
                final seekTo = Duration(milliseconds: (duration * value).toInt());
                BujuanMusicHandler().seek(seekTo);
              },
            ),
          ),
        ),
        SizedBox(height: 8.w),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(positionDuration, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
            Text(durationDuration, style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
          ],
        )
      ],
    );
  }
}

class PlaybackControls extends StatelessWidget {
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 第一行：播放控制按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButton(
              image: HugeIcons.strokeRoundedPrevious,
              onTap: () => BujuanMusicHandler().skipToPrevious(),
            ),
            SizedBox(width: 30.w),
            _PlayPauseButton(),
            SizedBox(width: 30.w),
            ControlButton(
              image: HugeIcons.strokeRoundedNext,
              onTap: () => BujuanMusicHandler().skipToNext(),
            ),
          ],
        ),
        SizedBox(height: 30.w),
        // 第二行：功能按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(width: 20.w),
            // 播放列表
            Consumer(builder: (context, ref, child) {
              return ControlButton(
                image: HugeIcons.strokeRoundedPlaylist01,
                onTap: () => showPlaylistSheet(context),
              );
            }),
            // 歌词
            ControlButton(
              image: HugeIcons.strokeRoundedMusicNote04,
              onTap: () => showLyricsSheet(context),
            ),
            // 评论
            ControlButton(
              image: HugeIcons.strokeRoundedComment02,
              onTap: () => showCommentSheet(context),
            ),
            // 循环模式
            Consumer(builder: (context, ref, child) {
              var loopMode = ref.watch(loopModeNotifierProvider);
              return ControlButton(
                image: loopMode == LoopMode.one
                    ? HugeIcons.strokeRoundedRepeatOne02
                    : loopMode == LoopMode.playlist
                        ? HugeIcons.strokeRoundedRepeat
                        : HugeIcons.strokeRoundedShuffle,
                onTap: () {
                  ref.read(loopModeNotifierProvider.notifier).changeMode();
                },
              );
            }),
            SizedBox(width: 20.w),
          ],
        ),
        // 注释掉的红心按钮（保留代码以便将来恢复）
        // const ControlButton(
        //   image: HugeIcons.strokeRoundedFavourite,
        //   color: Colors.red,
        // ),
      ],
    );
  }
}

class _PlayPauseButton extends ConsumerWidget {
  const _PlayPauseButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(mediaColorProvider).maybeWhen(
          data: (c) => c.dominantColor!,
          orElse: () => PaletteColor(Colors.white, 1),
        );
    var playing = ref.watch(playbackStateProvider.select((state) => state.value?.playing ?? false));
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: ColorUtils.lightenColor(color.color, 0.8),
        borderRadius: BorderRadius.circular(50.w),
      ),
      child: IconButton(
        onPressed: () => BujuanMusicHandler().playOrPause(),
        icon: Icon(
          playing ? HugeIcons.strokeRoundedPause : HugeIcons.strokeRoundedPlay,
          size: 24.sp,
        ),
      ),
    );
  }
}

class AlbumWidget extends ConsumerWidget {
  const AlbumWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var media = ref.watch(mediaItemProvider).value;
    return Column(
      children: [
        SizedBox(height: 40.w),
        Shadex(
          shadowColor: Colors.grey.withAlpha(220),
          shadowBlurRadius: 8.0,
          shadowOffset: Offset(5, 5),
          child: CachedImage(
            imageUrl: media?.artUri?.toString() ?? '',
            width: 280.w,
            height: 280.w,
            borderRadius: 140.w,
          ),
        ),
        SizedBox(height: 25.w),
        Container(
          height: 35.w,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 5.w),
          child: Text(
            media?.title ?? '',
            style: TextStyle(fontSize: 18.sp,overflow: TextOverflow.ellipsis),
            maxLines: 1,
          ),
        ),
        Container(
          height: 24.w,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 3.w),
          child: Text(
            media?.artist ?? '',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey,overflow: TextOverflow.ellipsis),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 20.w),
      ],
    );
  }
}

/// 播放列表Sheet
void showPlaylistSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.w)),
          ),
          child: Column(
            children: [
              // 顶部指示条
              Container(
                margin: EdgeInsets.only(top: 8.w),
                width: 40.w,
                height: 4.w,
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(100),
                  borderRadius: BorderRadius.circular(2.w),
                ),
              ),
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                child: Consumer(builder: (context, ref, child) {
                  final queue = ref.watch(queueStreamProvider).value ?? [];
                  return Row(
                    children: [
                      Text('播放列表', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Text('共${queue.length}首', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                    ],
                  );
                }),
              ),
              Divider(height: 1.w),
              // List
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final queue = ref.watch(queueStreamProvider).value ?? [];
                  final currentIndex = BujuanMusicHandler().currentIndex;

                  if (queue.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(HugeIcons.strokeRoundedMusicNote04, size: 64.sp, color: Colors.grey),
                          SizedBox(height: 16.w),
                          Text('播放列表为空', style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
                          SizedBox(height: 8.w),
                          Text('去首页添加歌曲吧', style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: queue.length,
                    itemBuilder: (context, index) {
                      final item = queue[index];
                      final isPlaying = index == currentIndex;
                      return Dismissible(
                        key: Key('${item.id}_$index'),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          BujuanMusicHandler().removeFromQueue(index);
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20.w),
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
                          leading: CachedImage(
                            imageUrl: item.artUri?.toString() ?? '',
                            width: 48.w,
                            height: 48.w,
                            borderRadius: 24.w,
                            pWidth: 100,
                            pHeight: 100,
                          ),
                          title: Text(
                            item.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isPlaying ? Color(0XFF1ED760) : null,
                              fontWeight: isPlaying ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item.artist ?? '',
                            style: TextStyle(fontSize: 12.sp),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: isPlaying
                              ? Icon(HugeIcons.strokeRoundedVolumeHigh, size: 20.sp, color: Color(0XFF1ED760))
                              : IconButton(
                                  icon: Icon(Icons.close, size: 20.sp),
                                  onPressed: () {
                                    BujuanMusicHandler().removeFromQueue(index);
                                  },
                                ),
                          onTap: () {
                            BujuanMusicHandler().skipToQueueItem(index);
                          },
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    ),
  );
}

