import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getfit/controller/exerciesService.dart';

import '../model/Exerice_model.dart';

class CreateExercisePage extends StatefulWidget {
  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  ExcersiceService _exerciseService = ExcersiceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Exercise Name'),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter exercise name',
              ),
            ),
            SizedBox(height: 16),
            Text('Exercise Description'),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter exercise description',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                saveExercise();
              },
              child: Text('Save Exercise'),
            ),
          ],
        ),
      ),
    );
  }

  void saveExercise() async {
    String name = _nameController.text;
    String description = _descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      try {
        Exercise newExercise = Exercise(name: name, description: description);
        await _exerciseService.addExercise(newExercise);

        // Clear the text controllers after saving
        _nameController.clear();
        _descriptionController.clear();

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        print('Error saving exercise: $e');
        // Handle error appropriately
      }
    } else {
      print('Please fill in both exercise name and description.');
      // Handle validation error appropriately
    }
  }
}
