import 'package:flutter/material.dart';

import 'WorkoutListView.dart';

class ViewWorkoutPlanPage extends StatelessWidget {
  final WorkoutPlan workoutPlan;

  ViewWorkoutPlanPage({required this.workoutPlan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workoutPlan.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${workoutPlan.title}'),
            Text('Created on: ${formatDate(workoutPlan.creationDate)}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    // Customize the date format as needed
    return '${date.year}-${date.month}-${date.day}';
  }
}
