/// lib/models/program.dart
class ProgramModel {
  final String id;
  final String name;
  final String? description;

  ProgramModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory ProgramModel.fromMap(Map<String, dynamic> data, String docId) {
    return ProgramModel(
      id: docId,
      name: data['name'] as String,
      description: data['description'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
  };
}
