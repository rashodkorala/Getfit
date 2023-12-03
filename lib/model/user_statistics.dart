// models/user_statistics.dart
class UserStatistics {
  final double? chest;
  final double? waist;
  final double? hips;
  final double? arm;
  final double? thigh;
  final double? calf;
  final double? height;
  final double? weight;
  final DateTime? timestamp;

  UserStatistics({
    this.chest,
    this.waist,
    this.hips,
    this.arm,
    this.thigh,
    this.calf,
    this.height,
    this.weight,
    this.timestamp,
  });

  double? get bmi => weight != null && height != null
      ? (weight! / ((height! / 100) * (height! / 100)))
      : null;

  // Factory method to create a UserStatistics from Firestore data
  factory UserStatistics.fromFirestore(Map<String, dynamic> data) {
    return UserStatistics(
      chest: data['chest'],
      waist: data['waist'],
      hips: data['hips'],
      arm: data['arm'],
      thigh: data['thigh'],
      calf: data['calf'],
      height: data['height'],
      weight: data['weight'],
      timestamp: data['timestamp']?.toDate(),
    );
  }
}

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

  // Factory method to create a WorkoutCompleted from Firestore data
  factory WorkoutCompleted.fromFirestore(Map<String, dynamic> data) {
    return WorkoutCompleted(
      name: data['name'],
      weight: data['weight'],
      reps: data['reps'],
      timestamp: data['timestamp'].toDate(),
    );
  }
}
