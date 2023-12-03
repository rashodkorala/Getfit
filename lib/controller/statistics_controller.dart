// controllers/statistics_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:getfit/model/user_statistics.dart';

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
}
