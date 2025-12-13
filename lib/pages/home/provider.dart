import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Future<HomeData> newAlbum(Ref ref) async {
  var recommendResourceFuture = BujuanMusicManager().recommendPlaylist();
  var recommendSongsFuture = BujuanMusicManager().newSongList();
  var topArtistFuture = BujuanMusicManager().topArtist(limit: 10);
  var list = await Future.wait([recommendResourceFuture, topArtistFuture, recommendSongsFuture]);
  var recommendPlayList = list[0] as RecommendPlayListWrap;
  var artistsList = list[1] as ArtistsListWrap;
  var songEntity = list[2] as SongListWrap2;
  var songs = (songEntity.data ?? []);
  return HomeData(
      recommendPlayList,
      artistsList,
      (songs.length > 20 ? songs.sublist(0, 20) : songs)
          .map((e) => MediaItem(
              id: '${e.id}',
              title: e.name ?? "",
              duration: Duration(milliseconds: e.duration ?? 0),
              artist: (e.artists ?? []).map((e) => e.name).toList().join(' '),
              artUri: Uri.parse(e.album?.picUrl ?? ''),
              extras: {'mv': 0}))
          .toList());
}

@riverpod
Future<List<MediaItem>> recommendSongs(Ref ref) async {
  var recommendSongEntity = await BujuanMusicManager().recommendSongList();
  var list = recommendSongEntity?.data?.dailySongs ?? [];
  return list
      .map((e) => MediaItem(
          id: '${e.id}',
          title: e.name ?? "",
          duration: Duration(milliseconds: e.dt ?? 0),
          artist: (e.ar ?? []).map((e) => e.name).toList().join(' '),
          artUri: Uri.parse(e.al?.picUrl ?? ''),
          extras: {'mv': e.mv ?? 0}))
      .toList();
}

class HomeData {
  RecommendPlayListWrap recommendPlayListWrap;
  ArtistsListWrap artistsListWrap;
  List<MediaItem> medias;

  HomeData(this.recommendPlayListWrap, this.artistsListWrap, this.medias);
}
