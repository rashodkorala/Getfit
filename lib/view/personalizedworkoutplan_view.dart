import 'package:flutter/material.dart';
import 'personalizedworkoutquestionnarie_view.dart';

class CreatePersonalizedWorkPlan extends StatelessWidget {
  const CreatePersonalizedWorkPlan({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate a Personalized Plan'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the questionnaire form page when the button is pressed
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalizedPlanQuestionnairePage(),
              ),
            );
          },
          child: const Text('Fill out Questionnaire Form'),
        ),
      ),
    );
  }
}
