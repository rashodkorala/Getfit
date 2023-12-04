import 'package:flutter/material.dart';
import 'package:getfit/controller/workoutService.dart';
import 'package:getfit/model/workoutExercise_model.dart';
import 'package:getfit/model/workout_model.dart';
import 'package:getfit/view/Exercise_view.dart';
import 'package:getfit/view/WorkoutListView.dart';
import 'package:getfit/view/workoutTracker_view.dart';
import 'createNewWorkout_view.dart';

class ViewWorkoutPlanPage extends StatelessWidget {
  final Workout workout;
  final bool isprebuilt;
  final bool completedWorkout;

  final WorkoutService _workoutService = WorkoutService();

  ViewWorkoutPlanPage({
    required this.workout,
    required this.isprebuilt,
    this.completedWorkout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          if (!isprebuilt && !completedWorkout)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _confirmDelete(context),
            ),
          if (!isprebuilt && !completedWorkout)
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
                ).then((value) => Navigator.pop(context));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  workout.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (isprebuilt) _createWorkoutButton(context),
              ],
            ),
            Text(' Created on: ${formatDate(workout.creationDate)}',
                style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: workout.exercises.length,
                itemBuilder: (context, index) {
                  return _buildExerciseItem(
                    context,
                    workout.exercises[index],
                  );
                },
              ),
            ),
            if (!completedWorkout) _startWorkoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(BuildContext context, workoutExercise exercise) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 9.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    capitalizeFirstLetterOfEachWord(exercise.name),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow
                        .visible,
                    softWrap: true,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showExerciseDialog(context, exercise);
                    },
                    icon: const Icon(
                      Icons.question_mark,
                      size: 18,
                    )),
                Text('${exercise.sets.length} sets',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            Text(capitalizeFirstLetterOfEachWord(exercise.bodyPart),
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
              },
              children: [
                const TableRow(
                  children: [
                    Text('Set', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Weight',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Reps', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                ...exercise.sets.map((setDetail) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('${setDetail.index + 1}',
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('${setDetail.weight} lb'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('${setDetail.reps}'),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ],
        ),
      ),
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
        minimumSize: const Size(200, 40),
        backgroundColor: ThemeData().colorScheme.primary,
        foregroundColor: ThemeData().colorScheme.onSecondary,
      ),
      child: const Text('Use This Template'),
    );
  }

  Widget _startWorkoutButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutTrackerView(
                workout: workout,
              ),
            ),
          ).then((value) => Navigator.pop(context));
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 40),
          backgroundColor: ThemeData().colorScheme.primary,
          foregroundColor: ThemeData().colorScheme.onSecondary,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkoutListView()),
                  ).then((value) => Navigator.popUntil(
                      context, (route) => '/' == route.settings.name));
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

String capitalizeFirstLetterOfEachWord(String text) {
  if (text.isEmpty) return text;
  return text.split(" ").map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  }).join(" ");
}
