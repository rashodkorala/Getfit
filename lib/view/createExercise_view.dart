// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:getfit/controller/exerciesService.dart';

import '../model/exercise_model.dart';

class CreateExercisePage extends StatefulWidget {
  const CreateExercisePage({super.key});

  @override
  _CreateExercisePageState createState() => _CreateExercisePageState();
}

class _CreateExercisePageState extends State<CreateExercisePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ExcersiceService _exerciseService = ExcersiceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Exercise Name'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Enter exercise name',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Exercise Description'),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter exercise description',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                saveExercise();
              },
              child: const Text('Save Exercise'),
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
