import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getfit/controller/workoutService.dart';

import '../model/workout_model.dart';

class prebuiltWorkoutService extends WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _prebuiltWorkoutsCollection() {
    return _firestore.collection('prebuiltWorkouts');
  }

  Future<List<Workout>> getPrebuiltWorkouts() async {
    try {
      QuerySnapshot querySnapshot = await _prebuiltWorkoutsCollection().get();

      List<Workout> workouts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Workout.fromMap(data, doc.id);
      }).toList();

      return workouts;
    } catch (e) {
      print('Error fetching workouts: $e');
      throw Exception('Failed to fetch workouts');
    }
  }

  Future<void> addPrebuiltWorkout(Workout workout) async {
    try {
      await _prebuiltWorkoutsCollection().add(workout.toMap());
    } catch (e) {
      print('Error adding workout to Firestore: $e');
      // Handle the error as needed
      throw e; // Re-throw the exception for the calling code to handle
    }
  }

  Future<void> updatePrebuiltWorkout(
      String documentId, Workout updatedWorkout) async {
    try {
      await _prebuiltWorkoutsCollection()
          .doc(documentId)
          .update(updatedWorkout.toMap());
    } catch (e) {
      print('Error updating workout in Firestore: $e');
      // Handle the error as needed
      throw e; // Re-throw the exception for the calling code to handle
    }
  }

  Future<void> deletePrebuiltWorkout(String documentId) async {
    try {
      await _prebuiltWorkoutsCollection().doc(documentId).delete();
    } catch (e) {
      print('Error deleting workout from Firestore: $e');
      // Handle the error as needed
      throw e; // Re-throw the exception for the calling code to handle
    }
  }
}
