import 'dart:convert';

import 'package:bujuan_music/common/values/app_config.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@riverpod
Future<UserData> newAlbum(Ref ref) async {
  try {
    String userInfo = GetIt.I<Box>().get(AppConfig.userInfoKey, defaultValue: '');
    if (userInfo.isNotEmpty) {
      var user = NeteaseAccountProfile.fromJson(jsonDecode(userInfo));
      var userPlaylistEntity = await BujuanMusicManager().userPlayList('${user.userId ?? 0}');
      return UserData(userPlaylistEntity ?? MultiPlayListWrap2(), user);
    }
    return UserData(MultiPlayListWrap2(), NeteaseAccountProfile());
  } catch (e) {
    return UserData(MultiPlayListWrap2(), NeteaseAccountProfile());
  }
}

class UserData {
  MultiPlayListWrap2 likeList;
  NeteaseAccountProfile userInfo;

  UserData(this.likeList, this.userInfo);
}
