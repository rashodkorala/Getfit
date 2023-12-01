// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:getfit/controller/workoutService.dart';
import 'package:getfit/model/workout_model.dart';
import 'createIndiviualWorkouts_view.dart';
import 'workoutTracker_view.dart';

class ViewWorkoutPlanPage extends StatelessWidget {
  final Workout workout;
  final bool isprebuilt;

  final WorkoutService _workoutService = WorkoutService();

  ViewWorkoutPlanPage({
    required this.workout,
    required this.isprebuilt,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (!isprebuilt)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          if (!isprebuilt)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateIndividualWorkoutPage(
                      destination: 'user',
                      workout: workout,
                      isEditing: true,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('${workout.name}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(' Created on: ${formatDate(workout.creationDate)}',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            _buildExerciseList(),
            if (isprebuilt) _createWorkoutButton(context),
            _startWorkoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: workout.exercises.map((exercise) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 9.0),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Text('Set',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Weight',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Reps',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ...exercise.sets.map((setDetail) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('${setDetail.index + 1}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('${setDetail.weight} kg'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('${setDetail.reps} reps'),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _createWorkoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      child: const Text('Create a Workout Plan'),
    );
  }

  Widget _startWorkoutButton(BuildContext context) {
    return Center(
      // Wrap the ElevatedButton with a Center widget
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutTrackerView(workout: workout),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0), // Rounded edges
          ),
        ),
        child: const Text('Start Workout'),
      ),
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
                try {
                  await _workoutService.deleteWorkout(workout.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Workout deleted')),
                  );
                  Navigator.of(context).pop();
                  Navigator.pushReplacementNamed(context, '/viewworkout');
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete workout')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
