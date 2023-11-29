import 'package:flutter/material.dart';

import '../controller/exerciesService.dart';
import '../model/exercise_model.dart';
import 'createExercise_view.dart';

class ExercisesPage extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final ExcersiceService _exerciseService = ExcersiceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Exercises'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _exerciseService.getExercises(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No exercises found.');
          } else {
            List<Exercise> exercises = snapshot.data!;
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                Exercise exercise = exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Text(exercise.description),
                  // Add more details or actions as needed
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page for adding a new exercise
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateExercisePage(),
            ),
          ).then((value) {
            // Refresh the list of exercises when returning from the add exercise page
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
