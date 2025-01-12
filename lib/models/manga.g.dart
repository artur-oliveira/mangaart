// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manga _$MangaFromJson(Map<String, dynamic> json) => Manga(
      name: json['name'] as String?,
      code: json['code'] as String,
      poster: json['poster'] as String,
    );

Map<String, dynamic> _$MangaToJson(Manga instance) => <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'poster': instance.poster,
    };
