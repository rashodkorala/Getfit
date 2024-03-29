import 'package:flutter/material.dart';
import 'package:getfit/controller/prebuiltWorkoutService.dart';
import 'package:getfit/view/workout_view.dart';
import 'package:getfit/view/createNewWorkout_view.dart';
import '../model/workout_model.dart';

class ChoosePrebuiltWorkoutPage extends StatefulWidget {
  @override
  _ChoosePrebuiltWorkoutPageState createState() =>
      _ChoosePrebuiltWorkoutPageState();
}

class _ChoosePrebuiltWorkoutPageState extends State<ChoosePrebuiltWorkoutPage> {
  final prebuiltWorkoutService _prebuiltWorkoutService =
      prebuiltWorkoutService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prebuilt Workout Plans'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add new workout plan',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateIndividualWorkoutPage(
                          destination: 'prebuilt',
                        )),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Workout>>(
        future: _prebuiltWorkoutService.getPrebuiltWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No prebuilt workouts available');
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Workout workout = snapshot.data![index];
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
                                isprebuilt: true,
                              )),
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
