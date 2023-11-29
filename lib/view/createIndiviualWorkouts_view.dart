import 'package:flutter/material.dart';
import '../controller/exerciesService.dart';
import '../controller/workoutService.dart';
import '../model/exercise_model.dart';
import '../model/workout_model.dart';

class CreateIndividualWorkoutPage extends StatefulWidget {
  @override
  _CreateIndividualWorkoutPageState createState() =>
      _CreateIndividualWorkoutPageState();
}

class _CreateIndividualWorkoutPageState
    extends State<CreateIndividualWorkoutPage> {
  final ExcersiceService _excersiceService = ExcersiceService();
  final WorkoutService _workoutService = WorkoutService();
  List<Exercise> availableExercises = [];
  List<Exercise> selectedExercises = [];
  TextEditingController workoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAvailableExercises();
  }

  void _loadAvailableExercises() async {
    try {
      List<Exercise> exercises = await _excersiceService.getExercises();
      setState(() {
        availableExercises = exercises;
      });
    } catch (e) {
      print('Error loading exercises: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout Plan'),
        //add a button to the app bar to save the workout with text save and a icon
        actions: [
          TextButton(
            onPressed: () {
              // Perform the action to save the selected exercises
              _saveSelectedExercises();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Workout Plan Name:'),
            TextField(
              controller: workoutNameController,
              decoration: InputDecoration(
                hintText: 'Enter workout plan name',
              ),
            ),
            const SizedBox(height: 16.0),
            Text('Selected Exercises:'),
            _showSelectedExercises(),
            ElevatedButton(
              onPressed: () {
                // Perform the action to save the selected exercises
                _addExercise();
              },
              child: const Text('add exercise'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSelectedExercises() async {
    try {
      String workoutName = workoutNameController.text;

      if (workoutName.isNotEmpty && selectedExercises.isNotEmpty) {
        // Get the authenticated user's ID
        String? userId = await _workoutService.getUserId();

        if (userId != null) {
          // Create a Workout instance with the selected exercises
          Workout workout = Workout(
            name: workoutName,
            exercises: selectedExercises,
            creationDate: DateTime.now(),
          );

          // Save the workout to Firestore using the WorkoutService
          await _workoutService.addWorkout(workout);

          // After saving, you might want to navigate to a different page or show a confirmation
          //show a confirmation
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Workout saved successfully!'),
            ),
          );
          // navigate to show all workouts
          Navigator.pushNamed(context, '/viewworkout');
        } else {
          throw Exception('User not authenticated');
        }
      } else {
        // Handle the case where workout name or selected exercises are empty
      }
    } catch (e) {
      // Handle errors (e.g., show an error message)
      print('Error saving workout: $e');
    }
  }

  void _addExercise() {
    // Show a dialog with a list of available exercises
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select an exercise'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: availableExercises.length,
              itemBuilder: (BuildContext context, int index) {
                Exercise exercise = availableExercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  onTap: () {
                    // Add the selected exercise to the list of selected exercises
                    setState(() {
                      selectedExercises.add(exercise);
                    });
                    // Close the dialog
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  _showSelectedExercises() {
    if (selectedExercises.isNotEmpty) {
      return SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          itemCount: selectedExercises.length,
          itemBuilder: (BuildContext context, int index) {
            Exercise exercise = selectedExercises[index];
            return ListTile(
              title: Text(exercise.name),
              onTap: () {
                // Remove the selected exercise from the list of selected exercises
                setState(() {
                  selectedExercises.remove(exercise);
                });
              },
            );
          },
        ),
      );
    } else {
      return const Text('No exercises selected');
    }
  }
}
