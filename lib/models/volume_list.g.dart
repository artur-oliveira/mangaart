// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VolumeList _$VolumeListFromJson(Map<String, dynamic> json) => VolumeList(
      language: json['language'] as String?,
      languageCode: json['languageCode'] as String?,
      volumes: (json['volumes'] as List<dynamic>)
          .map((e) => Volume.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VolumeListToJson(VolumeList instance) =>
    <String, dynamic>{
      'language': instance.language,
      'languageCode': instance.languageCode,
      'volumes': instance.volumes,
    };
