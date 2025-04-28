import 'package:json_annotation/json_annotation.dart';

part 'question.g.dart';

@JsonSerializable()
class Question {
  final int id;
  final Map<String, String> text;    // keys: 'de' und 'en'
  final List<String> reflexIds;

  Question({
    required this.id,
    required this.text,
    required this.reflexIds,
  });

  /// erzeugt eine Instanz aus JSON
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  /// wandelt die Instanz zurück in JSON
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
