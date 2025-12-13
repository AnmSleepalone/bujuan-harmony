import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Future<MvData> mvUrl(Ref ref, int id) async {
  var mv = await BujuanMusicManager().mvUrl('$id');
  return MvData(mv ?? MvUrlWrap());
}

class MvData {
  MvUrlWrap mvUrl;

  MvData(this.mvUrl);
}
