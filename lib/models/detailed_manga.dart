// lib/models/detailed_manga.dart
import 'package:json_annotation/json_annotation.dart';
import 'chapter_list.dart';
import 'volume_list.dart';

part 'detailed_manga.g.dart';

@JsonSerializable()
class DetailedManga {
  final String? name;
  final String? code;
  final String? poster;
  final String? synopsis;
  final List<ChapterList> chapters;
  final List<VolumeList> volumes;

  DetailedManga({
    this.name,
    this.code,
    this.poster,
    this.synopsis,
    required this.chapters,
    required this.volumes,
  });

  factory DetailedManga.fromJson(Map<String, dynamic> json) =>
      _$DetailedMangaFromJson(json);

  Map<String, dynamic> toJson() => _$DetailedMangaToJson(this);
}
