// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reflex_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReflexCategory _$ReflexCategoryFromJson(Map<String, dynamic> json) =>
    ReflexCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      score: (json['score'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ReflexCategoryToJson(ReflexCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'score': instance.score,
    };
