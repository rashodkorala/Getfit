// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:getfit/controller/workoutcompletedService.dart';
import 'dart:async';

import 'package:getfit/model/workout_model.dart';
import 'package:getfit/view/workoutHistory_view.dart';

import '../model/workoutExercise_model.dart';

class WorkoutTrackerView extends StatefulWidget {
  final Workout workout;

  const WorkoutTrackerView({super.key, required this.workout});

  @override
  _WorkoutTrackerViewState createState() => _WorkoutTrackerViewState();
}

class _WorkoutTrackerViewState extends State<WorkoutTrackerView> {
  late Timer _timer;
  String durationpreformed = '';
  Duration _duration = const Duration();

  WorkoutcompletedService workoutcompletedService = WorkoutcompletedService();

  @override
  void initState() {
    super.initState();
    // Start the timer when the page is opened
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _duration = _duration + const Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Make sure to cancel the timer when leaving the page
    super.dispose();
  }

  void _finishWorkout() async {
    // Filter out only completed sets for each exercise

    // Calculate the duration of the workout
    var duration = _formatDuration(_duration);
    widget.workout.duration = duration;

    widget.workout.lastperformed = DateTime.now().toString();
    // Update the workout in the database
    try {
      await workoutcompletedService.addWorkout(widget.workout);
    } catch (e) {
      print(e);
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutHistoryListView(),
      ),
    );
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
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _finishWorkout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('Finish Workout'),
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

  const ExerciseTile({super.key, required this.exercise});

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
      widget.exercise.sets[index].isCompleted = _completedSets[index];
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
                4: IntrinsicColumnWidth(),
              },
              children: [
                const TableRow(
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
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                          ),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      Checkbox(
                        value: _completedSets[index],
                        onChanged: (bool? newValue) {
                          _toggleSetComplete(index);
                        },
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
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
              child: const Text('Add Set'),
            ),
          ],
        ),
      ),
    );
  }
}
