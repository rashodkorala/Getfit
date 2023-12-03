class Exercise {
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String id;
  final List<String> instructions;
  final String name;
  final List<String> secondaryMuscles;
  final String target;

  Exercise({
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.id,
    required this.instructions,
    required this.name,
    required this.secondaryMuscles,
    required this.target,
  });

  Map<String, dynamic> toMap() {
    return {
      'bodyPart': bodyPart,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'id': id,
      'instructions': instructions.map((e) => '').toList(),
      'name': name,
      'secondaryMuscles': secondaryMuscles.map((e) => '').toList(),
      'target': target,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      bodyPart: map['bodyPart'] ?? '',
      equipment: map['equipment'] ?? '',
      gifUrl: map['gifUrl'] ?? '',
      id: map['id'] ?? '',
      instructions: List<String>.from(map['instructions'] ?? const []),
      name: map['name'] ?? '',
      secondaryMuscles: List<String>.from(map['secondaryMuscles'] ?? const []),
      target: map['target'] ?? '',
    );
  }
}
