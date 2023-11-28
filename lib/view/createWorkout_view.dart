import 'package:flutter/material.dart';

import 'createPersonalizedWorkout_view.dart';

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
                    builder: (context) => CreateIndividualWorkoutPage(),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePersonalizedWorkPlan(),
                  ),
                );
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

class CreateIndividualWorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Individual Workout Plan'),
      ),
      body: Center(
        child:
            const Text('Your individual workout plan creation form goes here.'),
        // Add form fields, buttons, and logic for creating individual workout plans
      ),
    );
  }
}

class ChoosePrebuiltWorkoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Prebuilt Workout Plan'),
      ),
      body: Center(
        child: const Text(
            'Your page to choose a prebuilt workout plan goes here.'),
        // Add UI elements and logic for choosing a prebuilt workout plan
      ),
    );
  }
}
