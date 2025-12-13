import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:palette_generator/palette_generator.dart';

import '../main/provider.dart';

part 'provider.g.dart';

@riverpod
Future<PaletteGenerator> getImageColor(Ref ref, ImageProvider imageProvider) async {
  return await PaletteGenerator.fromImageProvider(imageProvider, size: const Size(300, 300));
}

/// 当前播放歌曲的歌词
@riverpod
Future<SongLyricWrap?> currentSongLyrics(Ref ref) async {
  final mediaItem = ref.watch(mediaItemProvider).value;
  if (mediaItem == null) return null;

  try {
    return await BujuanMusicManager().songLyric(mediaItem.id);
  } catch (e) {
    print('获取歌词失败: $e');
    return null;
  }
}

/// 当前播放歌曲的评论
@riverpod
Future<CommentListWrap?> currentSongComments(Ref ref) async {
  final mediaItem = ref.watch(mediaItemProvider).value;
  if (mediaItem == null) return null;

  try {
    return await BujuanMusicManager().commentList(
      mediaItem.id,
      'song',
      limit: 50, // 一次加载50条评论
    );
  } catch (e) {
    print('获取评论失败: $e');
    return null;
  }
}
