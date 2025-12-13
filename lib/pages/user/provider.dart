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
    print('[UserPage] userInfo from Hive: ${userInfo.isEmpty ? "empty" : "exists"}');

    if (userInfo.isNotEmpty) {
      var user = NeteaseAccountProfile.fromJson(jsonDecode(userInfo));
      print('[UserPage] userId: ${user.userId}');

      var userPlaylistEntity = await BujuanMusicManager().userPlayList('${user.userId ?? 0}');
      print('[UserPage] API returned playlist count: ${userPlaylistEntity.playlist?.length ?? 0}');

      return UserData(userPlaylistEntity ?? MultiPlayListWrap2(), user);
    }

    print('[UserPage] No user info found, returning empty UserData');
    return UserData(MultiPlayListWrap2(), NeteaseAccountProfile());
  } catch (e, stackTrace) {
    print('[UserPage] Error loading user data: $e');
    print('[UserPage] StackTrace: $stackTrace');
    return UserData(MultiPlayListWrap2(), NeteaseAccountProfile());
  }
}

class UserData {
  MultiPlayListWrap2 likeList;
  NeteaseAccountProfile userInfo;

  UserData(this.likeList, this.userInfo);
}
