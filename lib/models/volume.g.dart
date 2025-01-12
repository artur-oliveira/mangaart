// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volume.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volume _$VolumeFromJson(Map<String, dynamic> json) => Volume(
      name: json['name'] as String?,
      href: json['href'] as String?,
      number: json['number'] as String?,
      poster: json['poster'] as String?,
    );

Map<String, dynamic> _$VolumeToJson(Volume instance) => <String, dynamic>{
      'name': instance.name,
      'href': instance.href,
      'number': instance.number,
      'poster': instance.poster,
    };
