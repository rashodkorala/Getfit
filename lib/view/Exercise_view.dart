import 'package:flutter/material.dart';
import '../model/exercise_model.dart';

void showExerciseDialog(BuildContext context, Exercise exercise) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.all(10.0),
          constraints:
              BoxConstraints(maxHeight: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Image.network(
                    exercise.gifUrl,
                    fit: BoxFit.fill,
                    gaplessPlayback: true,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error,
                        StackTrace? stackTrace) {
                      return Center(
                        child: Text('No image found',
                            style: TextStyle(fontSize: 16)),
                      );
                    },
                  ),
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
                  'Instructions',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    exercise.instructions.join('\n\n'),
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
