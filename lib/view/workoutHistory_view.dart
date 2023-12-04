import 'package:flutter/material.dart';
import 'package:getfit/controller/workoutTrackerService.dart';
import 'package:getfit/view/workout_view.dart';
import '../model/workout_model.dart';

class WorkoutHistoryListView extends StatefulWidget {
  const WorkoutHistoryListView({Key? key}) : super(key: key);

  @override
  _WorkoutListViewState createState() => _WorkoutListViewState();
}

class _WorkoutListViewState extends State<WorkoutHistoryListView> {
  final WorkoutTrackerService _workoutService = WorkoutTrackerService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: FutureBuilder<List<Workout>>(
        future: _workoutService.getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No workout plans found.');
          } else {
            List<Workout> workouts = snapshot.data!;
            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                Workout workout = workouts[index];

                return ListTile(
                  title: Text(workout.name),
                  subtitle:
                      Text('Created on: ${formatDate(workout.creationDate)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewWorkoutPlanPage(
                          workout: workout,
                          isprebuilt: false,
                          completedWorkout: true,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
