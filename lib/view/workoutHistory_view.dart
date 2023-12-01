import 'package:flutter/material.dart';
import 'package:getfit/controller/workoutcompletedService.dart';
import '../model/workout_model.dart';
import 'ViewWorkoutPlanPage.dart';
// import 'createWorkout_view.dart';

class WorkoutHistoryListView extends StatefulWidget {
  const WorkoutHistoryListView({Key? key}) : super(key: key);

  @override
  _WorkoutListViewState createState() => _WorkoutListViewState();
}

class _WorkoutListViewState extends State<WorkoutHistoryListView> {
  final WorkoutcompletedService _workoutService = WorkoutcompletedService();

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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigate to the page for creating a new workout plan
      //     showCreateWorkoutPlanBottomSheet(context);
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }

  String formatDate(DateTime date) {
    // Customize the date format as needed
    return '${date.year}-${date.month}-${date.day}';
  }
}

// void showCreateWorkoutPlanBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext context) {
//       return CreateWorkoutPlanBottomSheet();
//     },
//   );
// }
