import 'package:getfit/model/workoutExercise_model.dart';

class Workout {
  String name;
  DateTime creationDate;
  List<workoutExercise> exercises;

  Workout({
    required this.name,
    required this.creationDate,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'creationDate': creationDate,
      'exercises': exercises.map((x) => x.toMap()).toList(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      name: map['name'],
      creationDate: map['creationDate'].toDate(),
      exercises: List<workoutExercise>.from(
          map['exercises']?.map((x) => workoutExercise.fromMap(x))),
    );
  }       
}
