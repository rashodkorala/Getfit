import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> generateWorkoutPlan(Map<String, String> userAnswers) async {
  final String apiKey =
      "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"; // Replace with your OpenAI API key

  final String prompt =
      "Generate a personalized workout plan based on the user's answers:\n\n";
  final List<String> questions = userAnswers.keys.toList();
  final List<String> answers = userAnswers.values.toList();
  final String input =
      prompt + questions.join('\n') + '\n\nAnswers:\n' + answers.join('\n');

  print('Input:\n$input');

  return "Workout Plan"; // Replace with the generated workout plan
}

class PersonalizedPlanQuestionnairePage extends StatefulWidget {
  @override
  _PersonalizedPlanQuestionnairePageState createState() =>
      _PersonalizedPlanQuestionnairePageState();
}

class _PersonalizedPlanQuestionnairePageState
    extends State<PersonalizedPlanQuestionnairePage> {
  int currentStep = 0;
  List<TextEditingController> questionControllers = List.generate(
    7,
    (index) => TextEditingController(),
  );

  List<String> questions = [
    'What is your age?',
    'What is your height?',
    'What is your weight?',
    'What is your goal?',
    'Do you have any injuries (current or previous)?',
    'How often do you exercise?',
    'What do you want to focus on or improve?',
  ];

  bool isLoading = false; // Variable to track loading state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Plan Questionnaire'),
      ),
      body: isLoading
          ? _buildLoadingScreen()
          : Stepper(
              type: StepperType.vertical,
              currentStep: currentStep,
              onStepContinue: () async {
                // Validate the current step before proceeding to the next one
                if (validateCurrentStep()) {
                  // Save the current answer and move to the next step
                  saveAnswer();
                  setState(() {
                    if (currentStep < questions.length - 1) {
                      currentStep += 1;
                    } else {
                      // If all questions are answered, show loading screen
                      isLoading = true;
                    }
                  });

                  // Simulate loading for 2 seconds
                  await Future.delayed(Duration(seconds: 2));

                  // Process user answers and generate personalized plan
                  processUserAnswers();
                }
              },
              onStepCancel: () {
                // Move to the previous step
                setState(() {
                  if (currentStep > 0) {
                    currentStep -= 1;
                  }
                });
              },
              steps: List.generate(
                questions.length,
                (index) => Step(
                  title: Text('Question ${index + 1}'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(questions[index]),
                      TextFormField(
                        controller: questionControllers[index],
                        keyboardType: index == 0 || index == 1 || index == 2
                            ? TextInputType.number
                            : TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Enter your answer',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  bool validateCurrentStep() {
    // Validate the current step before proceeding to the next one
    if (currentStep == 0 || currentStep == 1 || currentStep == 2) {
      // Validate age, height, and weight
      return validateNumber(questionControllers[currentStep].text);
    }
    return true; // No validation for other questions
  }

  bool validateNumber(String? value) {
    // Validate if the input is a number
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This field is required'),
        ),
      );
      return false;
    }
    if (double.tryParse(value) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid number'),
        ),
      );
      return false;
    }
    // Additional validation based on the question
    if (questions[currentStep].contains('weight') && double.parse(value) <= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Weight should be above 5'),
        ),
      );
      return false;
    }
    return true;
  }

  void saveAnswer() {
    // Save the current answer
    String answer = questionControllers[currentStep].text;
    print('Question ${currentStep + 1}: $answer');
  }

  void processUserAnswers() async {
    // Process the answers and generate the personalized plan...
    Map<String, String> userAnswers = {};

    for (int i = 0; i < questionControllers.length; i++) {
      String question = questions[i];
      String answer = questionControllers[i].text;
      userAnswers[question] = answer;
    }

    // Generate workout plan using ChatGPT
    try {
      String workoutPlan = await generateWorkoutPlan(userAnswers);
      print('Generated Workout Plan:\n$workoutPlan');
    } catch (e) {
      print('Error generating workout plan: $e');
    }

    // Simulate stopping the loading state
    setState(() {
      isLoading = false;
    });
  }
}
