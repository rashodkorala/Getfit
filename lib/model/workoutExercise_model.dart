import 'package:getfit/model/exercise_model.dart';

class workoutExercise extends Exercise {
  late List<SetDetails> sets;

  workoutExercise({
    required super.bodyPart,
    required super.equipment,
    required super.gifUrl,
    required super.id,
    required super.instructions,
    required super.name,
    required super.secondaryMuscles,
    required super.target,
    required this.sets,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'bodyPart': bodyPart,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'id': id,
      'instructions': instructions,
      'name': name,
      'secondaryMuscles': secondaryMuscles,
      'target': target,
      'sets': sets.map((e) => e.toMap()).toList(),
    };
  }

  factory workoutExercise.fromMap(Map<String, dynamic> map) {
    return workoutExercise(
      bodyPart: map['bodyPart'] ?? '',
      equipment: map['equipment'] ?? '',
      gifUrl: map['gifUrl'] ?? '',
      id: map['id'] ?? '',
      instructions: List<String>.from(map['instructions'] ?? const []),
      name: map['name'] ?? '',
      secondaryMuscles: List<String>.from(map['secondaryMuscles'] ?? const []),
      target: map['target'] ?? '',
      sets: (map['sets'] as List).map((x) => SetDetails.fromMap(x)).toList(),
    );
  }
}

class SetDetails {
  int index;
  late int weight;
  late int reps;
  bool? isCompleted;

  SetDetails(
      {required this.index, this.reps = 0, this.weight = 0, this.isCompleted});

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'weight': weight,
      'reps': reps,
      'isCompleted': isCompleted == true ? 1 : 0,
    };
  }

  factory SetDetails.fromMap(Map<String, dynamic> map) {
    return SetDetails(
      index: map['index'] ?? 0,
      weight: map['weight'] ?? 0,
      reps: map['reps'] ?? 0,
      isCompleted: map['isCompleted'] == 1 ? true : false,
    );
  }
}
