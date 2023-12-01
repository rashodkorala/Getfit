import 'package:flutter/material.dart';

import '../model/exercise_model.dart';
// Import your Exercise model

void showExerciseDialog(BuildContext context, Exercise exercise) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Rounded corners for the dialog
        ),
        child: Container(
          constraints:
              BoxConstraints(maxHeight: 600), // Adjust the height as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  exercise.gifUrl,
                  height: 250,
                  fit: BoxFit.cover,
                  // Include loadingBuilder and errorBuilder as before
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  exercise.name,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  exercise.instructions.join('\n\n'),
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
