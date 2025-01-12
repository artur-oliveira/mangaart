// lib/models/chapter_list.dart
import 'package:json_annotation/json_annotation.dart';
import 'chapter.dart';

part 'chapter_list.g.dart';

@JsonSerializable()
class ChapterList {
  final String? language;
  final String? languageCode;
  final List<Chapter> chapters;

  ChapterList({
    this.language,
    this.languageCode,
    required this.chapters,
  });

  factory ChapterList.fromJson(Map<String, dynamic> json) => _$ChapterListFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterListToJson(this);
}