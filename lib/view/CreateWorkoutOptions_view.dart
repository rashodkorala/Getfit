import 'package:flutter/material.dart';

import 'createIndiviualWorkouts_view.dart';
import 'prebuiltWorkoutplans_view.dart';

class CreateWorkoutOptions extends StatelessWidget {
  const CreateWorkoutOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IntrinsicWidth(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeData().colorScheme.primary,
              foregroundColor: ThemeData().colorScheme.onSecondary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateIndividualWorkoutPage(
                    destination: 'user',
                  ),
                ),
              ).then((value) => Navigator.pop(context));
            },
            child: const Text('Create New Workout Plan'),
          ),
        ),
        SizedBox(height: 20),
        IntrinsicWidth(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeData().colorScheme.primary,
              foregroundColor: ThemeData().colorScheme.onSecondary,
            ),
            onPressed: () {
              // Your personalized plan logic
            },
            child: const Text('Create Personalized Plan'),
          ),
        ),
        SizedBox(height: 20),
        IntrinsicWidth(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeData().colorScheme.primary,
              foregroundColor: ThemeData().colorScheme.onSecondary,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChoosePrebuiltWorkoutPage(),
                ),
              ).then((value) => Navigator.pop(context));
            },
            child: const Text('Choose From A Template'),
          ),
        ),
      ],
    );
  }
}
