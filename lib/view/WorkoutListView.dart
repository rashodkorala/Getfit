import 'package:flutter/material.dart';
import 'ViewWorkoutPlanPage.dart';
import 'createWorkout_view.dart';

class WorkoutPlan {
  final String title;
  final DateTime creationDate;

  WorkoutPlan({required this.title, required this.creationDate});
}

class WorkoutListView extends StatelessWidget {
  final List<WorkoutPlan> workoutPlans = [
    WorkoutPlan(title: 'Workout Plan 1', creationDate: DateTime.now()),
    WorkoutPlan(title: 'Workout Plan 2', creationDate: DateTime.now()),
    // Add more WorkoutPlan instances as needed
  ];

  WorkoutListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Workout Plans'),
      ),
      body: ListView.builder(
        itemCount: workoutPlans.length,
        itemBuilder: (context, index) {
          WorkoutPlan plan = workoutPlans[index];

          return ListTile(
            title: Text(plan.title),
            subtitle: Text('Created on: ${formatDate(plan.creationDate)}'),
            // Add more details as needed
            onTap: () {
              // Navigate to the ViewWorkoutPlanPage when the ListTile is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewWorkoutPlanPage(workoutPlan: plan),
                ),
              );
            },
          );
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
