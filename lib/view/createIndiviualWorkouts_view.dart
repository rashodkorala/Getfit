// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:getfit/controller/prebuiltWorkoutService.dart';
import 'package:getfit/model/workoutExercise_model.dart';
import '../controller/exerciesService.dart';
import '../controller/workoutService.dart';
import '../model/exercise_model.dart';
import '../model/workout_model.dart';

class CreateIndividualWorkoutPage extends StatefulWidget {
  final String destination;
  final Workout? workout;

  bool? isprebuilt; // Optional Workout object for editing

  CreateIndividualWorkoutPage(
      {required this.destination, this.workout, isprebuilt});

  @override
  _CreateIndividualWorkoutPageState createState() =>
      _CreateIndividualWorkoutPageState();
}

class _CreateIndividualWorkoutPageState
    extends State<CreateIndividualWorkoutPage> {
  final ExcersiceService _excersiceService = ExcersiceService();
  final WorkoutService _workoutService = WorkoutService();
  final prebuiltWorkoutService _prebuiltWorkoutService =
      prebuiltWorkoutService();

  List<Exercise> availableExercises = [];
  List<workoutExercise> selectedExercises = [];
  TextEditingController workoutNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAvailableExercises();
    _initializePage();
  }

  void _initializePage() {
    if (widget.workout != null) {
      workoutNameController.text = widget.workout!.name;
      selectedExercises = widget.workout!.exercises;
    }
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Workout Plan Name:'),
            TextField(
              controller: workoutNameController,
              decoration: const InputDecoration(
                hintText: 'Enter workout plan name',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Selected Exercises:'),
            _showSelectedExercises(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _addExercise,
                  child: const Text('Add Exercise'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (widget.workout != null && widget.isprebuilt == true) {
                      _updateWorkout();
                      Navigator.pop(context);
                    } else {
                      _saveSelectedExercises();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
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
          print(workout.toMap());
          // Save the workout to Firestore using the WorkoutService
          if (widget.destination == 'prebuilt') {
            await _prebuiltWorkoutService.addPrebuiltWorkout(workout);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Workout saved successfully to prebuilt!'),
              ),
            );
            // navigate to show all workouts
            Navigator.pushNamed(context, '/prebuiltworkout');
          } else {
            await _workoutService.addWorkout(workout);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Workout saved successfully!'),
              ),
            );
            // navigate to show all workouts
            Navigator.pushNamed(context, '/viewworkout');
          }
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
                      selectedExercises.add(
                        workoutExercise(
                          name: exercise.name,
                          description: exercise.description,
                          sets: [],
                        ),
                      );
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
    if (selectedExercises.isEmpty) {
      return const Text('No exercises selected');
    } else {
      return Expanded(
        child: _SelectedExercise(),
      );
    }
  }

  //create widget to show the selected exercises
  Widget _SelectedExercise() {
    return ListView.builder(
      itemCount: selectedExercises.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedExercises[index].name),
              // Show the sets for the selected exercise
              _showSets(selectedExercises[index]),
              // Add a button to add sets for the selected exercise
              ElevatedButton(
                  onPressed: () {
                    _addset(selectedExercises[index].sets);
                  },
                  child: const Text('Add Set')),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Remove the selected exercise from the list of selected exercises
              setState(() {
                selectedExercises.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }

  _showSets(workoutExercise selectedExercis) {
    if (selectedExercis.sets.isEmpty) {
      return const Text('No sets added');
    } else {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: selectedExercis.sets.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                  'Set ${selectedExercis.sets[index].index + 1}: ${selectedExercis.sets[index].reps} reps, ${selectedExercis.sets[index].weight} kg'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // Remove the selected exercise from the list of selected exercises
                  setState(() {
                    selectedExercis.sets.removeAt(index);
                  });
                },
              ),
            );
          });
    }
  }

  void _addset(List<SetDetails> sets) {
    int reps = 0;
    int weight = 0;
    // Show a dialog with a list of available exercises
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add set'),
          content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter reps',
                    ),
                    onChanged: (value) {
                      reps = int.parse(value);
                    },
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter weight',
                    ),
                    onChanged: (value) {
                      weight = int.parse(value);
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          sets.add(SetDetails(
                              index: sets.length, reps: reps, weight: weight));
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Add Set')),
                  const SizedBox(height: 16.0),
                ],
              )),
        );
      },
    );
  }

  void _updateWorkout() async {
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
          // print(workout.toMap());
          // Save the workout to Firestore using the WorkoutService
          await _workoutService.updateWorkout(widget.workout!.id, workout);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Workout updated successfully!'),
            ),
          );
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
