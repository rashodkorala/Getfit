import 'package:getfit/model/exercise_model.dart';

class workoutExercise extends Exercise {
  List<SetDetails> sets;

  workoutExercise({
    required super.name,
    required super.description,
    required this.sets,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'sets': sets.map((set) => set.toMap()).toList(),
    };
  }

  @override
  factory workoutExercise.fromMap(Map<String, dynamic> map) {
    return workoutExercise(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
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
