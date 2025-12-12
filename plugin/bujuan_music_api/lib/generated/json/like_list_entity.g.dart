import 'package:bujuan_music_api/generated/json/base/json_convert_content.dart';
import 'package:bujuan_music_api/api/user/entity/like_list_entity.dart';

LikeListEntity $LikeListEntityFromJson(Map<String, dynamic> json) {
  final LikeListEntity likeListEntity = LikeListEntity();
  final List<int>? ids = (json['ids'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<int>(e) as int).toList();
  if (ids != null) {
    likeListEntity.ids = ids;
  }
  final int? checkPoint = jsonConvert.convert<int>(json['checkPoint']);
  if (checkPoint != null) {
    likeListEntity.checkPoint = checkPoint;
  }
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    likeListEntity.code = code;
  }
  return likeListEntity;
}

Map<String, dynamic> $LikeListEntityToJson(LikeListEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['ids'] = entity.ids;
  data['checkPoint'] = entity.checkPoint;
  data['code'] = entity.code;
  return data;
}

extension LikeListEntityExtension on LikeListEntity {
  LikeListEntity copyWith({
    List<int>? ids,
    int? checkPoint,
    int? code,
  }) {
    return LikeListEntity()
      ..ids = ids ?? this.ids
      ..checkPoint = checkPoint ?? this.checkPoint
      ..code = code ?? this.code;
  }
}