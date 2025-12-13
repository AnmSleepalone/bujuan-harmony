import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

// 搜索类型枚举
enum SearchType {
  song,     // 单曲
  album,    // 专辑
  artist,   // 歌手
  playlist, // 歌单
}

// 热搜列表
@riverpod
Future<List<SearchKeyDetailedItem>> hotSearchList(Ref ref) async {
  var result = await BujuanMusicManager().searchHotKeyDetailed();
  return result.data ?? [];
}

// 搜索建议
@riverpod
Future<SearchSuggestWrapX> searchSuggest(Ref ref, String keyword) async {
  if (keyword.isEmpty) {
    return SearchSuggestWrapX();
  }
  return await BujuanMusicManager().searchSuggest(keyword);
}

// 搜索歌曲
@riverpod
Future<SearchResultData> searchSongs(Ref ref, String keyword, {int offset = 0}) async {
  if (keyword.isEmpty) {
    return SearchResultData([], 0);
  }

  var result = await BujuanMusicManager().searchSong(keyword, offset: offset, limit: 30);
  var songs = result.result?.songs ?? [];

  var medias = songs.map((e) {
    // 确保 picUrl 不为空，否则使用默认占位符
    final picUrl = e.album?.picUrl ?? '';
    final artUri = picUrl.isNotEmpty
        ? Uri.parse(picUrl)
        : Uri.parse('https://via.placeholder.com/300');

    return MediaItem(
      id: '${e.id}',
      title: e.name ?? "",
      duration: Duration(milliseconds: e.duration ?? 0),
      artist: (e.artists ?? []).map((e) => e.name).toList().join(' '),
      artUri: artUri,
      extras: {'mv': e.mvid ?? 0}
    );
  }).toList();

  return SearchResultData(medias, medias.length);
}

// 搜索专辑
@riverpod
Future<List<Album>> searchAlbums(Ref ref, String keyword, {int offset = 0}) async {
  if (keyword.isEmpty) {
    return [];
  }

  var result = await BujuanMusicManager().searchAlbum(keyword, offset: offset, limit: 30);
  return result.result?.albums ?? [];
}

// 搜索歌手
@riverpod
Future<List<Artists>> searchArtists(Ref ref, String keyword, {int offset = 0}) async {
  if (keyword.isEmpty) {
    return [];
  }

  var result = await BujuanMusicManager().searchArtists(keyword, offset: offset, limit: 30);
  return result.result?.artists ?? [];
}

// 搜索歌单
@riverpod
Future<List<Play>> searchPlaylists(Ref ref, String keyword, {int offset = 0}) async {
  if (keyword.isEmpty) {
    return [];
  }

  var result = await BujuanMusicManager().searchPlaylist(keyword, offset: offset, limit: 30);
  return result.result?.playlists ?? [];
}

// 搜索结果数据类
class SearchResultData {
  final List<MediaItem> medias;
  final int totalCount;

  SearchResultData(this.medias, this.totalCount);
}
