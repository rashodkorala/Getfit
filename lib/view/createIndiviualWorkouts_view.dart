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
  final bool? isEditing;

  CreateIndividualWorkoutPage({
    required this.destination,
    this.workout,
    this.isEditing,
  });

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
    if (widget.workout != null && widget.isEditing == true) {
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

  void _saveOrUpdateWorkout() async {
    String workoutName = workoutNameController.text;
    if (workoutName.isEmpty || selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a name and exercises')),
      );
      return;
    }

    Workout newWorkout = Workout(
      name: workoutName,
      exercises: selectedExercises,
      creationDate: DateTime.now(),
    );

    try {
      if (widget.isEditing == true) {
        // Update existing workout
        await _workoutService.updateWorkout(widget.workout!.id, newWorkout);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout updated successfully!')),
        );
      } else {
        // Save new workout
        if (widget.destination == 'prebuilt') {
          await _prebuiltWorkoutService.addPrebuiltWorkout(newWorkout);
        } else {
          await _workoutService.addWorkout(newWorkout);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout saved successfully!')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      print('Error saving workout: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save workout')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing == true
            ? 'Edit Workout Plan'
            : 'Create Workout Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveOrUpdateWorkout,
          ),
        ],
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
            Expanded(
              child: ListView.builder(
                itemCount: selectedExercises.length,
                itemBuilder: (context, index) => ExerciseTile(
                  exercise: selectedExercises[index],
                  onRemove: () {
                    setState(() {
                      selectedExercises.removeAt(index);
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _addExercise,
              child: const Text('Add Exercise'),
            ),
          ],
        ),
      ),
    );
  }

  void _addExercise() {
    // Existing logic to add an exercise
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
}

class ExerciseTile extends StatefulWidget {
  final workoutExercise exercise;
  final VoidCallback onRemove;

  const ExerciseTile({
    Key? key,
    required this.exercise,
    required this.onRemove,
  }) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  List<bool> _completedSets;

  _ExerciseTileState() : _completedSets = [];

  @override
  void initState() {
    super.initState();
    _completedSets =
        List.generate(widget.exercise.sets.length, (index) => false);
  }

  void _addSet() {
    setState(() {
      widget.exercise.sets.add(
          SetDetails(index: widget.exercise.sets.length, reps: 0, weight: 0));
      _completedSets.add(false);
    });
  }

  void _removeSet(int index) {
    setState(() {
      widget.exercise.sets.removeAt(index);
      _completedSets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise.name,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: IntrinsicColumnWidth(),
              },
              children: [
                const TableRow(
                  children: [
                    Text('Set'),
                    Text('Weight'),
                    Text('Reps'),
                    SizedBox
                        .shrink(), // Placeholder for the remove button column
                  ],
                ),
                ...List.generate(widget.exercise.sets.length, (index) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text('${index + 1}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          initialValue: '${widget.exercise.sets[index].weight}',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) => setState(() {
                            widget.exercise.sets[index].weight =
                                int.parse(value);
                          }),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          initialValue: '${widget.exercise.sets[index].reps}',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) => setState(() {
                            widget.exercise.sets[index].reps = int.parse(value);
                          }),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeSet(index),
                      ),
                    ],
                  );
                }),
              ],
            ),
            TextButton(
              onPressed: _addSet,
              child: const Text('Add Set'),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
