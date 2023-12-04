import 'package:flutter/material.dart';
import 'package:getfit/view/workoutHistory_view.dart';
import '../controller/workoutService.dart';
import '../model/workout_model.dart';
import 'workout_view.dart';
import 'CreateWorkoutOptions_view.dart';

class WorkoutListView extends StatefulWidget {
  const WorkoutListView({Key? key}) : super(key: key);

  @override
  _WorkoutListViewState createState() => _WorkoutListViewState();
}

class _WorkoutListViewState extends State<WorkoutListView> {
  final WorkoutService _workoutService = WorkoutService();
  List<Workout> workouts = [];

  @override
  void initState() {
    super.initState();
    _refreshWorkouts();
  }

  void _refreshWorkouts() async {
    try {
      var fetchedWorkouts = await _workoutService.getWorkouts();
      if (mounted) {
        setState(() {
          workouts = fetchedWorkouts;
        });
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Workout Plans'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WorkoutHistoryListView(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Workout>>(
        future: _workoutService.getWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No workout plans found.');
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Workout workout = snapshot.data![index];
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
                    ).then((_) => _refreshWorkouts());
                  },
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding:
                        const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color:
                          Colors.grey[200],
                      borderRadius:
                          BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.blue, width: 2), // Border
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 3),
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
          showCreateWorkoutPlan(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}

void showCreateWorkoutPlan(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const CreateWorkoutOptions();
    },
  );
}
