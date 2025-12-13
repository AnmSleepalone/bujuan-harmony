import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Future<PlaylistData> playlistDetail(Ref ref, int id) async {
  var playlistDetailEntity = await BujuanMusicManager().playListDetail('$id');
  if (playlistDetailEntity == null) {
    return PlaylistData(SinglePlayListWrap(), []);
  }
  var songDetail = await BujuanMusicManager()
      .songDetail(playlistDetailEntity.playlist!.trackIds!.map((e) => e.id ?? '0').toList());
  var medias = (songDetail?.songs ?? [])
      .map((e) => MediaItem(
          id: '${e.id}',
          title: e.name ?? "",
          duration: Duration(milliseconds: e.dt ?? 0),
          artist: (e.ar ?? []).map((e) => e.name).toList().join(' '),
          artUri: Uri.parse(e.al?.picUrl ?? ''),
          extras: {'mv': e.mv ?? 0}))
      .toList();
  return PlaylistData(playlistDetailEntity, medias);
}

class PlaylistData {
  SinglePlayListWrap detail;
  List<MediaItem> medias;

  PlaylistData(this.detail, this.medias);
}
