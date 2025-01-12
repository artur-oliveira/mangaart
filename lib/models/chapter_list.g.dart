// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterList _$ChapterListFromJson(Map<String, dynamic> json) => ChapterList(
      language: json['language'] as String?,
      languageCode: json['languageCode'] as String?,
      chapters: (json['chapters'] as List<dynamic>)
          .map((e) => Chapter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChapterListToJson(ChapterList instance) =>
    <String, dynamic>{
      'language': instance.language,
      'languageCode': instance.languageCode,
      'chapters': instance.chapters,
    };
