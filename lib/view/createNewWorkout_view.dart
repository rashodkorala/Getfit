import 'package:flutter/material.dart';
import 'package:getfit/controller/prebuiltWorkoutService.dart';
import 'package:getfit/model/workoutExercise_model.dart';
import 'package:getfit/view/ViewWorkoutPlanPage.dart';
import '../controller/exerciesService.dart';
import '../controller/workoutService.dart';
import '../model/exercise_model.dart';
import '../model/workout_model.dart';
import 'Exercise_view.dart';

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
    if (widget.workout != null || widget.isEditing == true) {
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
      // if (widget.isEditing == true) {
      //   // Update existing workout
      //   await _workoutService.updateWorkout(widget.workout!.id, newWorkout);
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Workout updated successfully!')),
      //   );
      // } else {
      //   // Save new workout
      //   if (widget.destination == 'prebuilt') {
      //     await _prebuiltWorkoutService.addPrebuiltWorkout(newWorkout);
      //   } else {
      //     await _workoutService.addWorkout(newWorkout);
      //   }
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text('Workout saved successfully!')),
      //   );
      // }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewWorkoutPlanPage(
            workout: newWorkout,
            isprebuilt: false,
          ),
        ),
      ).then((value) => Navigator.pop(context));
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
        title: Text(
          widget.isEditing == true
              ? 'Edit Workout Plan'
              : 'Create Workout Plan',
          style: TextStyle(fontSize: 18),
        ),
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
            SizedBox(
              height: 50,
              child: TextFormField(
                controller: workoutNameController,
                decoration: const InputDecoration(
                  labelText: 'Workout Name',
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              alignment: Alignment.center,
              height: 50,
              child: ElevatedButton(
                onPressed: _addExercise,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 40),
                  backgroundColor: ThemeData().colorScheme.primary,
                  foregroundColor: ThemeData().colorScheme.onSecondary,
                ),
                // ignore: prefer_const_constructors
                child: Row(
                  mainAxisSize: MainAxisSize
                      .min, // To keep the row size just as big as its children
                  children: const [
                    // Spacing between icon and text
                    Text('Add Exercise'),
                    SizedBox(width: 8),
                    Icon(
                      Icons.add,
                      size: 20,
                    ), // Replace with your desired icon
                  ],
                ),
              ),
            ),
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
                          bodyPart: exercise.bodyPart,
                          equipment: exercise.equipment,
                          gifUrl: exercise.gifUrl,
                          id: exercise.id,
                          instructions: exercise.instructions,
                          name: exercise.name,
                          secondaryMuscles: exercise.secondaryMuscles,
                          target: exercise.target,
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
  void _addSet() {
    setState(() {
      widget.exercise.sets.add(
          SetDetails(index: widget.exercise.sets.length, reps: 0, weight: 0));
    });
  }

  void _removeSet(int index) {
    setState(() {
      widget.exercise.sets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.all(2.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    capitalizeFirstLetterOfEachWord(widget.exercise.name),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow
                        .visible, // Allow text to wrap to the next line
                    softWrap: true, // Enable text wrapping
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showExerciseDialog(context, widget.exercise);
                  },
                  icon: const Icon(
                    Icons.question_mark,
                    size: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, size: 18),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            Text(
              capitalizeFirstLetterOfEachWord(widget.exercise.bodyPart),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 25.0),
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
                    Text('Set', textAlign: TextAlign.start),
                    Text('Weight (lb)', textAlign: TextAlign.center),
                    Text('Reps', textAlign: TextAlign.center),
                    SizedBox.shrink(),
                  ],
                ),
                ...List.generate(widget.exercise.sets.length, (index) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${index + 1}', textAlign: TextAlign.start),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          initialValue:
                              '${widget.exercise.sets[index].weight == 0 ? '' : widget.exercise.sets[index].weight}',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) => setState(() {
                            //handle error
                            widget.exercise.sets[index].weight =
                                value.isEmpty ? 0 : int.parse(value);
                          }),
                          decoration: const InputDecoration(
                            suffixText: 'lb',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextFormField(
                          initialValue:
                              '${widget.exercise.sets[index].reps == 0 ? '' : widget.exercise.sets[index].reps}',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          onChanged: (value) => setState(() {
                            widget.exercise.sets[index].reps =
                                value.isEmpty ? 0 : int.parse(value);
                          }),
                          decoration: const InputDecoration(
                            suffixText: '',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 18),
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

String capitalizeFirstLetterOfEachWord(String text) {
  if (text.isEmpty) return text;
  return text.split(" ").map((word) {
    if (word.isNotEmpty) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }
    return word;
  }).join(" ");
}
