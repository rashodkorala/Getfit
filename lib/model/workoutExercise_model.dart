import 'package:getfit/model/exercise_model.dart';

class workoutExercise extends Exercise {
  int sets = 0;
  int reps = 0;

  workoutExercise({
    required String name,
    required String description,
    required this.sets,
    required this.reps,
  }) : super(name: name, description: description);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'sets': sets,
      'reps': reps,
    };
  }

  factory workoutExercise.fromMap(Map<String, dynamic> map) {
    return workoutExercise(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      sets: map['sets'] ?? 0,
      reps: map['reps'] ?? 0,
    );
  }
}
