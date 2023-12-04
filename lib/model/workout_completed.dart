// models/workout_completed.dart

import 'package:cloud_firestore/cloud_firestore.dart';

//gets info from firebase
class WorkoutCompleted {
  final String? name;
  final double? weight;
  final int? reps;
  final DateTime? creationDate;

  WorkoutCompleted({
    required this.name,
    required this.weight,
    required this.reps,
    required this.creationDate,
  });

  factory WorkoutCompleted.fromFirestore(Map<String, dynamic> data) {
    return WorkoutCompleted(
      name: data['name'],
      weight: data['weight'],
      reps: data['reps'],
      creationDate: (data['creationDate'] as Timestamp).toDate(),
    );
  }
}
