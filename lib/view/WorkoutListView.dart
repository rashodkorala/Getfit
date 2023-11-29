import 'package:flutter/material.dart';
import '../controller/workoutService.dart';
import '../model/workout_model.dart';
import 'ViewWorkoutPlanPage.dart';
import 'createWorkout_view.dart';

class WorkoutListView extends StatefulWidget {
  const WorkoutListView({Key? key}) : super(key: key);

  @override
  _WorkoutListViewState createState() => _WorkoutListViewState();
}

class _WorkoutListViewState extends State<WorkoutListView> {
  final WorkoutService _workoutService = WorkoutService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Workout Plans'),
      ),
      body: FutureBuilder<List<Workout>>(
        future: _workoutService.getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
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
                  // Add more details as needed
                  onTap: () {
                    // Navigate to the ViewWorkoutPlanPage when the ListTile is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewWorkoutPlanPage(workout: workout),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page for creating a new workout plan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateWorkoutPlanPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String formatDate(DateTime date) {
    // Customize the date format as needed
    return '${date.year}-${date.month}-${date.day}';
  }
}
