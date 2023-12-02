import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getfit/controller/workoutService.dart';

import '../model/workout_model.dart';

class WorkoutTrackerService extends WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _workoutsCollection(String userId) {
    return _firestore
        .collection('profiles')
        .doc(userId)
        .collection('workoutcompleted');
  }

  @override
  Future<List<Workout>> getWorkouts() async {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        QuerySnapshot querySnapshot = await _workoutsCollection(userId).get();

        List<Workout> workouts = querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          return Workout.fromMap(data, doc.id);
        }).toList();

        return workouts;
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
      throw Exception('Failed to fetch workouts');
    }
  }

  @override
  Future<void> addWorkout(Workout workout) async {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        await _workoutsCollection(userId).add(workout.toMap());
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error adding workout to Firestore: $e');
      // Handle the error as needed
      rethrow; // Re-throw the exception for the calling code to handle
    }
  }

  @override
  Future<void> updateWorkout(String documentId, Workout updatedWorkout) async {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        await _workoutsCollection(userId)
            .doc(documentId)
            .update(updatedWorkout.toMap());
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error updating workout in Firestore: $e');
      // Handle the error as needed
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkout(String documentId) async {
    try {
      String? userId = await getUserId();
      if (userId != null) {
        await _workoutsCollection(userId).doc(documentId).delete();
      } else {
        throw Exception('User not authenticated');
      }
    } catch (e) {
      print('Error deleting workout in Firestore: $e');
      // Handle the error as needed
      rethrow;
    }
  }
}
