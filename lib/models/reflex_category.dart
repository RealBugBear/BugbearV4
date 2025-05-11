import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reflex_category.g.dart';

/// Eine Reflex-Kategorie mit Score (wird in % umgerechnet).
@JsonSerializable()
class ReflexCategory {
  final String id;
  final String name;

  /// Score default = 0. Wird später in Prozent umgerechnet.
  @JsonKey(defaultValue: 0)
  double score;

  ReflexCategory({
    required this.id,
    required this.name,
    this.score = 0,
  });

  /// Factory, wird von json_serializable generiert.
  factory ReflexCategory.fromJson(Map<String, dynamic> json) =>
      _$ReflexCategoryFromJson(json);

  /// Serialisierung, wird von json_serializable generiert.
  Map<String, dynamic> toJson() => _$ReflexCategoryToJson(this);
}

/// Top-Level-Funktion zum JSON-Parsing in einem Hintergrund-Isolate.
List<ReflexCategory> parseCategories(String rawJson) {
  final List<dynamic> jsonList = jsonDecode(rawJson) as List<dynamic>;
  return jsonList
      .map((e) => ReflexCategory.fromJson(e as Map<String, dynamic>))
      .toList();
}

/// Async-Hilfsfunktion, die `parseCategories` in einem Isolate ausführt.
Future<List<ReflexCategory>> parseCategoriesIsolate(String rawJson) =>
    compute(parseCategories, rawJson);
