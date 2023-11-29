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
        title: const Text('Create Individual Workout Plan'),
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
            SizedBox(height: 16),
            Text('Available Exercises:'),
            _buildAvailableExercisesList(),
            SizedBox(height: 16),
            Text('Selected Exercises:'),
            _buildSelectedExercisesList(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Perform the action to save the selected exercises
                _saveSelectedExercises();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableExercisesList() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: availableExercises.length,
        itemBuilder: (context, index) {
          Exercise exercise = availableExercises[index];
          return ListTile(
            title: Text(exercise.name),
            onTap: () {
              setState(() {
                selectedExercises.add(exercise);
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectedExercisesList() {
    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: selectedExercises.length,
        itemBuilder: (context, index) {
          Exercise exercise = selectedExercises[index];
          return ListTile(
            title: Text(exercise.name),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  selectedExercises.removeAt(index);
                });
              },
            ),
          );
        },
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
}
