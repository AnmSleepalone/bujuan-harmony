import 'dart:async';

import 'package:bujuan_music/pages/play/provider.dart';
import 'package:bujuan_music/utils/lyric_parser.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../main/provider.dart';

/// 歌词Sheet - 支持卡拉OK样式滚动
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
              // 歌词内容（使用独立的StatefulWidget）
              Expanded(
                child: _LyricsContent(scrollController: scrollController),
              ),
            ],
          ),
        );
      },
    ),
  );
}

/// 歌词内容组件
class _LyricsContent extends ConsumerStatefulWidget {
  final ScrollController scrollController;

  const _LyricsContent({required this.scrollController});

  @override
  ConsumerState<_LyricsContent> createState() => _LyricsContentState();
}

class _LyricsContentState extends ConsumerState<_LyricsContent> {
  int _currentLineIndex = -1;
  Duration _lastPosition = Duration.zero;
  Timer? _scrollDebounceTimer;

  /// 用于获取每个歌词行的精确位置
  final List<GlobalKey> _lineKeys = [];

  /// 估算的平均行高
  static const double _estimatedLineHeight = 80.0;

  @override
  void dispose() {
    _scrollDebounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 监听播放进度
    final position = ref.watch(playbackStateProvider
        .select((state) => state.value?.updatePosition ?? Duration.zero));

    // 获取歌词数据
    final lyricsAsync = ref.watch(currentSongLyricsProvider);

    return lyricsAsync.when(
      data: (lyrics) {
        if (lyrics == null) {
          return _buildEmptyState('暂无歌词');
        }

        // 解析歌词
        final parsedLyrics = parseLyrics(
          lyrics.lrc.lyric,
          lyrics.tlyric.lyric,
        );

        if (parsedLyrics.isEmpty) {
          return _buildEmptyState('暂无歌词');
        }

        // 更新当前歌词行
        _updateCurrentLine(position, parsedLyrics);

        // 确保有足够的GlobalKey
        while (_lineKeys.length < parsedLyrics.lines.length) {
          _lineKeys.add(GlobalKey());
        }

        return RepaintBoundary(
          child: ListView.builder(
            controller: widget.scrollController,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.w),
            itemCount: parsedLyrics.lines.length,
            itemBuilder: (context, index) {
              final lyricLine = parsedLyrics.lines[index];
              final isCurrent = index == _currentLineIndex;
              final isPrevious = index == _currentLineIndex - 1;
              final isNext = index == _currentLineIndex + 1;

              return Container(
                key: _lineKeys[index],
                child: _buildLyricLine(
                  lyricLine,
                  isCurrent: isCurrent,
                  isPrevious: isPrevious,
                  isNext: isNext,
                ),
              );
            },
          ),
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
  }

  /// 更新当前歌词行并触发滚动
  void _updateCurrentLine(Duration position, ParsedLyrics lyrics) {
    final newIndex = lyrics.findCurrentLineIndex(position);

    if (newIndex != _currentLineIndex && newIndex >= 0) {
      setState(() {
        _currentLineIndex = newIndex;
      });

      // 检测是否快进/快退（位置变化超过3秒）
      final positionDiff = (position - _lastPosition).abs();
      final isSeek = positionDiff > Duration(seconds: 3);

      _lastPosition = position;

      // 取消之前的防抖timer
      _scrollDebounceTimer?.cancel();

      if (isSeek) {
        // 快进/快退：立即滚动，不使用动画
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToCurrentLine(useAnimation: false);
        });
      } else {
        // 正常播放：使用防抖，避免频繁滚动
        _scrollDebounceTimer = Timer(Duration(milliseconds: 100), () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCurrentLine(useAnimation: true);
          });
        });
      }
    } else {
      // 即使行号未变化，也更新位置记录
      _lastPosition = position;
    }
  }

  /// 自动滚动到当前歌词行（居中显示）
  /// [useAnimation] 是否使用动画，快进时设为false可避免乱跳
  void _scrollToCurrentLine({bool useAnimation = true}) {
    if (_currentLineIndex < 0 || !widget.scrollController.hasClients) return;
    if (_currentLineIndex >= _lineKeys.length) return;

    final key = _lineKeys[_currentLineIndex];
    final currentContext = key.currentContext;

    if (currentContext != null) {
      // Widget 已渲染，使用 ensureVisible 精确定位
      Scrollable.ensureVisible(
        currentContext,
        duration: useAnimation ? Duration(milliseconds: 300) : Duration.zero,
        curve: Curves.easeOut,
        alignment: 0.3, // 显示在屏幕 30% 位置（偏上）
      );
    } else {
      // Widget 未渲染（快进到远处），先用估算位置跳转
      final estimatedOffset = _currentLineIndex * _estimatedLineHeight -
          MediaQuery.of(context).size.height / 3;
      final clampedOffset = estimatedOffset.clamp(
        0.0,
        widget.scrollController.position.maxScrollExtent,
      );

      // 先跳转到估算位置
      widget.scrollController.jumpTo(clampedOffset);

      // 等待渲染完成后，再用 ensureVisible 精确定位
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final keyAfterJump = _lineKeys[_currentLineIndex];
        final contextAfterJump = keyAfterJump.currentContext;
        if (contextAfterJump != null) {
          Scrollable.ensureVisible(
            contextAfterJump,
            duration: Duration(milliseconds: 150),
            curve: Curves.easeOut,
            alignment: 0.3,
          );
        }
      });
    }
  }

  /// 构建单行歌词组件（带卡拉OK效果）
  Widget _buildLyricLine(
    LyricLine line, {
    required bool isCurrent,
    bool isPrevious = false,
    bool isNext = false,
  }) {
    // 根据位置计算样式参数
    final opacity = isCurrent
        ? 1.0
        : (isPrevious || isNext)
            ? 0.6
            : 0.3;
    final scale = isCurrent ? 1.15 : 1.0;
    final fontWeight = isCurrent ? FontWeight.bold : FontWeight.normal;
    final textColor = isCurrent ? Color(0XFF1ED760) : null;

    return AnimatedOpacity(
      opacity: opacity,
      duration: Duration(milliseconds: 300),
      child: AnimatedScale(
        scale: scale,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.w),
          child: Column(
            children: [
              // 原文歌词
              Text(
                line.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: fontWeight,
                  color: textColor,
                  height: 1.5,
                ),
              ),
              // 翻译歌词
              if (line.translation != null && line.translation!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 6.w),
                  child: Text(
                    line.translation!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: isCurrent ? Colors.grey[400] : Colors.grey,
                      height: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
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
