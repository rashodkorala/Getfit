import 'package:cloud_firestore/cloud_firestore.dart';

import 'Exerice_model.dart';

class Workout {
  String name;
  DateTime creationDate;
  List<Exercise> exercises;

  Workout({
    required this.name,
    required this.creationDate,
    required this.exercises,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'creationDate': creationDate,
      'exercises': exercises.map((exercise) => exercise.toMap()).toList(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      name: map['name'] ?? '',
      creationDate: (map['creationDate'] as Timestamp).toDate(),
      exercises: (map['exercises'] as List<dynamic>)
          .map((exercise) => Exercise.fromMap(exercise))
          .toList(),
    );
  }
}
