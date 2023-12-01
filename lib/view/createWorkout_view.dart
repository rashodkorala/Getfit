import 'package:flutter/material.dart';

import 'createIndiviualWorkouts_view.dart';
import 'prebuiltWorkoutplans_view.dart';

class CreateWorkoutPlanBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize
          .min, // Important to make the bottom sheet flexible in height
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateIndividualWorkoutPage(
                  destination: 'user',
                ),
              ),
            );
          },
          child: const Text('Create a Workout Plan'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Your personalized plan logic
          },
          child: const Text('Generate a Personalized Plan'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChoosePrebuiltWorkoutPage(),
              ),
            );
          },
          child: const Text('Choose a Prebuilt Workout Plan'),
        ),
      ],
    );
  }
}
