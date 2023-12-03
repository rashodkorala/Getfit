// models/workout_completed.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutCompleted {
  final String name;
  final double weight;
  final int reps;
  final DateTime timestamp;

  WorkoutCompleted({
    required this.name,
    required this.weight,
    required this.reps,
    required this.timestamp,
  });

  factory WorkoutCompleted.fromFirestore(Map<String, dynamic> data) {
    return WorkoutCompleted(
      name: data['name'],
      weight: data['weight'],
      reps: data['reps'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
