import 'package:getfit/model/workoutExercise_model.dart';

class Workout {
  String id;
  String name;
  DateTime creationDate;
  List<workoutExercise> exercises;
  String? lastperformed;
  String? duration;

  Workout({
    this.id = '',
    required this.name,
    required this.creationDate,
    required this.exercises,
    this.lastperformed,
    this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'creationDate': creationDate,
      'exercises': exercises.map((x) => x.toMap()).toList(),
      'lastperformed': lastperformed ?? '',
      'duration': duration ?? '',
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map, String id) {
    return Workout(
      id: id,
      name: map['name'],
      creationDate: map['creationDate'].toDate(),
      exercises: List<workoutExercise>.from(
          map['exercises']?.map((x) => workoutExercise.fromMap(x))),
      lastperformed: map['lastperformed'] ?? '',
      duration: map['duration'] ?? '',
    );
  }
}
