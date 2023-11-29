import 'package:flutter/material.dart';
import 'package:getfit/model/workout_model.dart';

class ViewWorkoutPlanPage extends StatelessWidget {
  final Workout workout;

  ViewWorkoutPlanPage({required this.workout});

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
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workout.exercises.map((exercise) {
        return ListTile(
          title: Text(exercise.name),
          subtitle: Text(exercise.description),
          // Add more details or actions as needed
        );
      }).toList(),
    );
  }

  String formatDate(DateTime date) {
    // Customize the date format as needed
    return '${date.year}-${date.month}-${date.day}';
  }
}
