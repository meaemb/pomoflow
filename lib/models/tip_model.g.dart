// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipModel _$TipModelFromJson(Map<String, dynamic> json) => TipModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  provider: json['provider'] as String,
  rating: (json['rating'] as num).toDouble(),
  duration: json['duration'] as String,
  level: json['level'] as String,
  imageUrl: json['imageUrl'] as String,
  steps: (json['steps'] as List<dynamic>)
      .map((e) => TipStepModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TipModelToJson(TipModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'provider': instance.provider,
  'rating': instance.rating,
  'duration': instance.duration,
  'level': instance.level,
  'imageUrl': instance.imageUrl,
  'steps': instance.steps,
};

TipStepModel _$TipStepModelFromJson(Map<String, dynamic> json) => TipStepModel(
  title: json['title'] as String,
  description: json['description'] as String,
  fullDescription: json['fullDescription'] as String,
  duration: json['duration'] as String,
  tip: json['tip'] as String,
  durationInMinutes: (json['durationInMinutes'] as num).toInt(),
);

Map<String, dynamic> _$TipStepModelToJson(TipStepModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'fullDescription': instance.fullDescription,
      'duration': instance.duration,
      'tip': instance.tip,
      'durationInMinutes': instance.durationInMinutes,
    };
