// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailed_manga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailedManga _$DetailedMangaFromJson(Map<String, dynamic> json) =>
    DetailedManga(
        name: json['name'] as String,
        code: json['code'] as String,
        poster: json['poster'] as String,
        synopsis: json['synopsis'] as String,
        chapters: (json['chapters'] as List<dynamic>)
            .map((e) => ChapterList.fromJson(e as Map<String, dynamic>))
            .toList(),
        volumes: (json['volumes'] as List<dynamic>)
            .map((e) => VolumeList.fromJson(e as Map<String, dynamic>))
            .toList(),
        );

Map<String, dynamic> _$DetailedMangaToJson(DetailedManga instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'poster': instance.poster,
      'synopsis': instance.synopsis,
      'chapters': instance.chapters,
      'volumes': instance.volumes,
    };
