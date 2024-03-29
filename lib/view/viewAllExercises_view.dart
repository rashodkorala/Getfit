import 'package:flutter/material.dart';
import 'package:getfit/view/Exercise_view.dart';
import '../controller/exerciesService.dart';
import '../model/exercise_model.dart';

class ViewAllExercises extends StatefulWidget {
  @override
  _ExercisesPageState createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ViewAllExercises> {
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
            return Center(child: CircularProgressIndicator());
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
                    subtitle: Text(exercise.bodyPart),
                    onTap: () => showExerciseDialog(context, exercise));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
