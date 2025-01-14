import 'package:json_annotation/json_annotation.dart';

part 'manga.g.dart';

@JsonSerializable()
class Manga {
  final String name;
  final String code;
  final String poster;

  Manga({
    required this.name,
    required this.code,
    required this.poster,
  });

  factory Manga.fromJson(Map<String, dynamic> json) => _$MangaFromJson(json);

  Map<String, dynamic> toJson() => _$MangaToJson(this);
}
