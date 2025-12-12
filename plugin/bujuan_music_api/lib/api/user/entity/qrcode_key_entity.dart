import 'package:bujuan_music_api/generated/json/base/json_field.dart';
import 'package:bujuan_music_api/generated/json/qrcode_key_entity.g.dart';
import 'dart:convert';
export 'package:bujuan_music_api/generated/json/qrcode_key_entity.g.dart';

@JsonSerializable()
class QrcodeKeyEntity {
	int? code = 0;
	String? unikey = '';

	QrcodeKeyEntity();

	factory QrcodeKeyEntity.fromJson(Map<String, dynamic> json) => $QrcodeKeyEntityFromJson(json);

	Map<String, dynamic> toJson() => $QrcodeKeyEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}