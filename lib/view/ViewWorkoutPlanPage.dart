// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:getfit/controller/workoutService.dart';
import 'package:getfit/model/workout_model.dart';

import 'createIndiviualWorkouts_view.dart';

class ViewWorkoutPlanPage extends StatelessWidget {
  final Workout workout;
  final bool isprebuilt;

  WorkoutService _workoutService = WorkoutService();

  ViewWorkoutPlanPage({
    required this.workout,
    required this.isprebuilt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
        actions: <Widget>[
          if (isprebuilt == false)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          if (isprebuilt == false)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateIndividualWorkoutPage(
                      destination: 'user',
                      workout: workout,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${workout.name}'),
            Text('Created on: ${formatDate(workout.creationDate)}'),
            const SizedBox(height: 16),
            const Text('Exercises:'),
            _buildExerciseList(),
            if (isprebuilt == true)
              ElevatedButton(
                onPressed: () async {
                  //show create workout page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateIndividualWorkoutPage(
                        destination: 'user',
                        workout: workout,
                      ),
                    ),
                  );
                },
                child: const Text('Create a Workout Plan'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workout.exercises.map((exercise) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(exercise.name),
              subtitle: Text(exercise.description),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: exercise.sets.map((setDetail) {
                  return Text(
                      'Set ${setDetail.index + 1}: ${setDetail.reps} reps, ${setDetail.weight} kgs');
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this workout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                // Logic to delete the workout
                // For example, remove it from a list or database

                try {
                  // Delete the workout from Firestore
                  await _workoutService.deleteWorkout(workout.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Workout deleted'),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete workout'),
                    ),
                  );
                }
                Navigator.of(context).pop();

                // Potentially navigate back or show a confirmation
              },
            ),
          ],
        );
      },
    );
  }

  String formatDate(DateTime date) {
    // Customize the date format as needed
    return '${date.year}-${date.month}-${date.day}';
  }
}
