// lib/models/volume_list.dart
import 'package:json_annotation/json_annotation.dart';
import 'volume.dart';

part 'volume_list.g.dart';

@JsonSerializable()
class VolumeList {
  final String? language;
  final String? languageCode;
  final List<Volume> volumes;

  VolumeList({
    this.language,
    this.languageCode,
    required this.volumes,
  });

  factory VolumeList.fromJson(Map<String, dynamic> json) => _$VolumeListFromJson(json);
  Map<String, dynamic> toJson() => _$VolumeListToJson(this);
}
