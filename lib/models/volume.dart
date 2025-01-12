// lib/models/volume.dart
import 'package:json_annotation/json_annotation.dart';

part 'volume.g.dart';

@JsonSerializable()
class Volume {
  final String? name;
  final String? href;
  final String? number;
  final String? poster;

  Volume({
    this.name,
    this.href,
    this.number,
    this.poster,
  });

  factory Volume.fromJson(Map<String, dynamic> json) => _$VolumeFromJson(json);
  Map<String, dynamic> toJson() => _$VolumeToJson(this);
}
