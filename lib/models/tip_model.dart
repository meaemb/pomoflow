import 'package:json_annotation/json_annotation.dart';

part 'tip_model.g.dart';

@JsonSerializable()
class TipModel {
  final String id;
  final String name;
  final String description;
  final String provider;
  final double rating;
  final String duration;
  final String level;
  final String imageUrl;
  final List<TipStepModel> steps;

  TipModel({
    required this.id,
    required this.name,
    required this.description,
    required this.provider,
    required this.rating,
    required this.duration,
    required this.level,
    required this.imageUrl,
    required this.steps,
  });

  factory TipModel.fromJson(Map<String, dynamic> json) =>
      _$TipModelFromJson(json);

  Map<String, dynamic> toJson() => _$TipModelToJson(this);
}

@JsonSerializable()
class TipStepModel {
  final String title;
  final String description;
  final String fullDescription;
  final String duration;
  final String tip;
  final int durationInMinutes;

  TipStepModel({
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.duration,
    required this.tip,
    required this.durationInMinutes,
  });

  factory TipStepModel.fromJson(Map<String, dynamic> json) =>
      _$TipStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$TipStepModelToJson(this);
}