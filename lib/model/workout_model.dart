import 'package:getfit/model/workoutExercise_model.dart';

class Workout {
  String id;
  String name;
  DateTime creationDate;
  List<workoutExercise> exercises;

  Workout({
    this.id = '',
    required this.name,
    required this.creationDate,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creationDate': creationDate,
      'exercises': exercises.map((x) => x.toMap()).toList(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map, String id) {
    return Workout(
      id: id,
      name: map['name'],
      creationDate: map['creationDate'].toDate(),
      exercises: List<workoutExercise>.from(
          map['exercises']?.map((x) => workoutExercise.fromMap(x))),
    );
  }
}
