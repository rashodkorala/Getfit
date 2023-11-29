import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/workout_model.dart';

class WorkoutService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _workoutsCollection =
      FirebaseFirestore.instance.collection('workouts');

  Future<List<Workout>> getWorkouts() async {
    try {
      QuerySnapshot querySnapshot = await _workoutsCollection.get();

      List<Workout> workouts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Workout.fromMap(data);
      }).toList();

      return workouts;
    } catch (e) {
      print('Error fetching workouts: $e');
      throw Exception('Failed to fetch workouts');
    }
  }

  Future<void> addWorkout(Workout workout) async {
    try {
      await _workoutsCollection.add(workout.toMap());
    } catch (e) {
      print('Error adding workout to Firestore: $e');
      // Handle the error as needed
      throw e; // Re-throw the exception for the calling code to handle
    }
  }

  Future<void> updateWorkout(String documentId, Workout updatedWorkout) async {
    try {
      await _workoutsCollection
          .doc(documentId)
          .update(updatedWorkout.toMap());
    } catch (e) {
      print('Error updating workout in Firestore: $e');
      // Handle the error as needed
      throw e;
    }
  }

  Future<void> deleteWorkout(String documentId) async {
    try {
      await _workoutsCollection.doc(documentId).delete();
    } catch (e) {
      print('Error deleting workout in Firestore: $e');
      // Handle the error as needed
      throw e;
    }
  }
}
