import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/exercise_model.dart';

class ExcersiceService {
  final CollectionReference _exercisesCollection =
      FirebaseFirestore.instance.collection('exercises');

  Future<List<Exercise>> getExercises() async {
    try {
      QuerySnapshot querySnapshot = await _exercisesCollection.get();

      List<Exercise> exercises = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Exercise.fromMap(data);
      }).toList();

      return exercises;
    } catch (e) {
      print('Error fetching exercises: $e');
      throw Exception('Failed to fetch exercises');
    }
  }

  Future<void> addExercise(Exercise exercise) async {
    try {
      await _exercisesCollection.add(exercise.toMap());
    } catch (e) {
      print('Error adding exercise to Firestore: $e');
      // Handle the error as needed
      throw e; // Re-throw the exception for the calling code to handle
    }
  }

  Future<void> updateExercise(
      String documentId, Exercise updatedExercise) async {
    try {
      await _exercisesCollection
          .doc(documentId)
          .update(updatedExercise.toMap());
    } catch (e) {
      print('Error updating exercise in Firestore: $e');
      // Handle the error as needed
      throw e;
    }
  }

  Future<void> deleteExercise(String documentId) async {
    try {
      await _exercisesCollection.doc(documentId).delete();
    } catch (e) {
      print('Error deleting exercise in Firestore: $e');
      // Handle the error as needed
      throw e;
    }
  }
}
