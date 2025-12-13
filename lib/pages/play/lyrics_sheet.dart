import 'package:bujuan_music/pages/play/provider.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../main/provider.dart';

/// 歌词Sheet
void showLyricsSheet(BuildContext context) {
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
              Consumer(builder: (context, ref, child) {
                final mediaItem = ref.watch(mediaItemProvider).value;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                  child: Row(
                    children: [
                      if (mediaItem?.artUri != null)
                        CachedImage(
                          imageUrl: mediaItem!.artUri.toString(),
                          width: 48.w,
                          height: 48.w,
                          borderRadius: 24.w,
                          pWidth: 100,
                          pHeight: 100,
                        ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mediaItem?.title ?? '',
                              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              mediaItem?.artist ?? '',
                              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Divider(height: 1.w),
              // 歌词内容
              Expanded(
                child: Consumer(builder: (context, ref, child) {
                  final lyricsAsync = ref.watch(currentSongLyricsProvider);

                  return lyricsAsync.when(
                    data: (lyrics) {
                      if (lyrics == null) {
                        return _buildEmptyState('暂无歌词');
                      }

                      final lrcLines = _parseLyric(lyrics.lrc.lyric);
                      final trcLines = _parseLyric(lyrics.tlyric.lyric);
                      final hasTranslation = trcLines.isNotEmpty;

                      if (lrcLines.isEmpty) {
                        return _buildEmptyState('暂无歌词');
                      }

                      return ListView.builder(
                        controller: scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
                        itemCount: lrcLines.length,
                        itemBuilder: (context, index) {
                          final lyricLine = lrcLines[index];
                          final translationLine = hasTranslation && index < trcLines.length
                              ? trcLines[index]
                              : null;

                          return Padding(
                            padding: EdgeInsets.only(bottom: 20.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 原文歌词
                                Text(
                                  lyricLine,
                                  style: TextStyle(fontSize: 15.sp, height: 1.5),
                                ),
                                // 翻译歌词
                                if (translationLine != null && translationLine.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.w),
                                    child: Text(
                                      translationLine,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: Colors.grey,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16.w),
                          Text('加载中...', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    error: (_, __) => _buildEmptyState('加载失败，请重试'),
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

/// 空状态组件
Widget _buildEmptyState(String message) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(HugeIcons.strokeRoundedMusicNote04, size: 64.sp, color: Colors.grey),
        SizedBox(height: 16.w),
        Text(message, style: TextStyle(fontSize: 16.sp, color: Colors.grey)),
      ],
    ),
  );
}

/// 解析LRC格式歌词，去除时间标签
List<String> _parseLyric(String? lyricText) {
  if (lyricText == null || lyricText.isEmpty) return [];

  return lyricText
      .split('\n')
      .where((line) => line.trim().isNotEmpty)
      .map((line) {
        // 移除时间标签 [00:12.50]
        return line.replaceAll(RegExp(r'\[\d+:\d+\.\d+\]'), '').trim();
      })
      .where((line) => line.isNotEmpty)
      .toList();
}
