// controllers/statistics_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getfit/model/user_statistics.dart';
//import 'models/workout_completed.dart';

class StatisticsController {
  Future<UserStatistics?> fetchLatestUserStatistics() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .collection('measurements')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return UserStatistics.fromFirestore(snapshot.docs.first.data());
      }
    }
    return null;
  }

  Future<List<WorkoutCompleted>> fetchLatestWorkouts() async {
    final user = FirebaseAuth.instance.currentUser;
    List<WorkoutCompleted> workouts = [];
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .collection('workoutcompleted')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      for (var doc in snapshot.docs) {
        workouts.add(WorkoutCompleted.fromFirestore(doc.data()));
      }
    }
    return workouts;
  }
}
