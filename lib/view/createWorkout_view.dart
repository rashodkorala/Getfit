import 'package:flutter/material.dart';

import 'createIndiviualWorkouts_view.dart';
import 'prebuiltWorkoutplans_view.dart';

class CreateWorkoutPlanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout Plan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Logic to navigate to the page for creating a workout plan
                // You can replace this with your actual navigation logic
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
                // Logic to generate a personalized plan
                // You can replace this with your actual logic
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const CreatePersonalizedWorkPlan(),
                //   ),
                // );
              },
              child: const Text('Generate a Personalized Plan'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to choose a prebuilt workout plan
                // You can replace this with your actual logic
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
        ),
      ),
    );
  }
}
