import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Future<ArtistData> artistDetail(Ref ref, int id) async {
  var artistDetailWrap = await BujuanMusicManager().artistDetailAndSongList('$id');
  if (artistDetailWrap.code != 200 || artistDetailWrap.artist == null) {
    throw Exception('获取艺术家详情失败');
  }

  var hotSongs = artistDetailWrap.hotSongs ?? [];
  var medias = hotSongs
      .map((e) => MediaItem(
          id: '${e.id}',
          title: e.name ?? "",
          duration: Duration(milliseconds: e.dt ?? 0),
          artist: (e.ar ?? []).map((e) => e.name).toList().join(' '),
          artUri: Uri.parse(e.al?.picUrl ?? ''),
          extras: {'mv': e.mv ?? 0}))
      .toList();

  return ArtistData(artistDetailWrap.artist!, medias);
}

class ArtistData {
  Artists artist;
  List<MediaItem> medias;

  ArtistData(this.artist, this.medias);
}
