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
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No workout plans found.');
          } else {
            List<Workout> workouts = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                childAspectRatio: 2, // Square items
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                Workout workout = workouts[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewWorkoutPlanPage(
                          workout: workout,
                          isprebuilt: false,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding:
                        const EdgeInsets.all(4), // Padding inside the container
                    decoration: BoxDecoration(
                      color:
                          Colors.grey[200], // Background color of the container
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                      border:
                          Border.all(color: Colors.blue, width: 2), // Border
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workout.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Created on: ${formatDate(workout.creationDate)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateWorkoutPlanBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}

void showCreateWorkoutPlanBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return CreateWorkoutPlanBottomSheet();
    },
  );
}
