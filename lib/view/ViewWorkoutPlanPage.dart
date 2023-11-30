import 'package:flutter/material.dart';
import 'package:getfit/model/workout_model.dart';

import 'createIndiviualWorkouts_view.dart';

class ViewWorkoutPlanPage extends StatelessWidget {
  final Workout workout;
  bool isprebuilt = false;

  ViewWorkoutPlanPage({
    required this.workout,
    required this.isprebuilt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workout.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${workout.name}'),
            Text('Created on: ${formatDate(workout.creationDate)}'),
            SizedBox(height: 16),
            Text('Exercises:'),
            _buildExerciseList(),
            if (isprebuilt == true)
              ElevatedButton(
                onPressed: () {
                  // Logic to navigate to the page for creating a workout plan
                  // You can replace this with your actual navigation logic
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateIndividualWorkoutPage(
                        from: 'user',
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

  String formatDate(DateTime date) {
    // Customize the date format as needed
    return '${date.year}-${date.month}-${date.day}';
  }
}
