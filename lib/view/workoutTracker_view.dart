import 'package:flutter/material.dart';
import 'dart:async';

import 'package:getfit/model/workout_model.dart';

import '../model/workoutExercise_model.dart';

class WorkoutTrackerView extends StatefulWidget {
  final Workout workout;

  const WorkoutTrackerView({Key? key, required this.workout}) : super(key: key);

  @override
  _WorkoutTrackerViewState createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  late Timer _timer;
  String durationpreformed = '';
  Duration _duration = Duration();

  @override
  void initState() {
    super.initState();
    // Start the timer when the page is opened
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _duration = _duration + Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Make sure to cancel the timer when leaving the page
    super.dispose();
  }

  void _finishWorkout() {
    // Logic to handle the end of a workout
    durationpreformed = _formatDuration(_duration);
    _timer.cancel(); // Stop the timer
    Navigator.pop(context); // Go back to the previous screen
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.workout.name}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.workout.exercises.length,
                itemBuilder: (context, index) {
                  workoutExercise exercise = widget.workout.exercises[index];
                  return ExerciseTile(exercise: exercise);
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Text(
                  'Workout Timer: ${_formatDuration(_duration)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _finishWorkout,
                  child: Text('Finish Workout'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseTile extends StatefulWidget {
  final workoutExercise exercise;

  const ExerciseTile({Key? key, required this.exercise}) : super(key: key);

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

  void _toggleSetComplete(int index) {
    setState(() {
      _completedSets[index] = !_completedSets[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.exercise.name,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(),
                1: FlexColumnWidth(),
                2: FlexColumnWidth(),
                3: IntrinsicColumnWidth(),
                4: IntrinsicColumnWidth(),
              },
              children: [
                TableRow(
                  children: [
                    Text('Set'),
                    Text('Weight'),
                    Text('Reps'),
                    Text(''),
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
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TextFormField(
                          initialValue: '${widget.exercise.sets[index].reps}',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Checkbox(
                        value: _completedSets[index],
                        onChanged: (bool? newValue) {
                          _toggleSetComplete(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeSet(index),
                      ),
                    ],
                  );
                }),
              ],
            ),
            TextButton(
              onPressed: _addSet,
              child: Text('Add Set'),
              style: TextButton.styleFrom(primary: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
