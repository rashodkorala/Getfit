// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:getfit/controller/chatGPTService.dart';

import 'generatedWorkout_view.dart';

class WorkoutGeneratorQnA extends StatefulWidget {
  @override
  WorkoutGeneratorQnAState createState() => WorkoutGeneratorQnAState();
}

class WorkoutGeneratorQnAState extends State<WorkoutGeneratorQnA> {
  int currentStep = 0;

  List<String> questions = [
    'What is your age?',
    'What is your height?',
    'What is your weight?',
    'Gender',
    'What is your goal?',
    'Do you have any injuries (current or previous)?',
    'How often do you exercise?',
    'What do you want to focus on or improve?',
  ];

  List<TextEditingController> questionControllers = List.generate(
    8,
    (index) => TextEditingController(),
  );
  bool isLoading = false; // Variable to track loading state
  bool isProcessingAnswers = false;

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
                if (!isProcessingAnswers && validateCurrentStep()) {
                  saveAnswer();
                  setState(() {
                    if (currentStep < questions.length - 1) {
                      currentStep += 1;
                    } else {
                      isLoading = true;
                      isProcessingAnswers = true; // Set the flag to true
                    }
                  });

                  if (currentStep == questions.length - 1) {
                    String workoutPlan = await processUserAnswers();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GeneratedWorkoutView(workoutPlan: workoutPlan),
                      ),
                    ).then((value) => Navigator.pop(context));
                  }
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
                      SizedBox(height: 4),
                      TextFormField(
                        controller: questionControllers[index],
                        keyboardType: index == 0 || index == 1 || index == 2
                            ? TextInputType.number
                            : TextInputType.text,
                        decoration: InputDecoration(
                          hintText:
                              'Example: ${getExampleForQuestion(questions[index])}',
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Generating your personalized workout plan...',
              style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  bool validateCurrentStep() {
    if (currentStep == 0 || currentStep == 1 || currentStep == 2) {
      return validateNumber(questionControllers[currentStep].text);
    } else {
      return validateText(questionControllers[currentStep].text);
    }
  }

  bool validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      showSnackbar('This field is required');
      return false;
    }
    if (double.tryParse(value) == null) {
      showSnackbar('Please enter a valid number');
      return false;
    }
    return true;
  }

  bool validateText(String? value) {
    if (value == null || value.isEmpty) {
      showSnackbar('This field is required');
      return false;
    }
    return true;
  }

  void saveAnswer() {
    String answer = questionControllers[currentStep].text;
    print('Answer for question ${currentStep + 1}: $answer');
  }

  Future<String> processUserAnswers() async {
    Map<String, String> userAnswers = {};

    for (int i = 0; i < questionControllers.length; i++) {
      String question = questions[i];
      String answer = questionControllers[i].text;
      userAnswers[question] = answer;
    }

    String userPrompt = createPromptFromAnswers(userAnswers);

    try {
      String workoutPlan = await generateWorkoutPlan(userPrompt);

      // Navigate to the generated workout view

      // Reset isLoading and isProcessingAnswers after successful generation
      if (mounted) {
        setState(() {
          isLoading = false;
          isProcessingAnswers = false;
        });
      }

      return workoutPlan;
    } catch (e) {
      print('Error in generating: $e');

      // Handle the error, e.g., show a snackbar with an error message
      if (mounted) {
        setState(() {
          isLoading = false;
          isProcessingAnswers = false;
        });
      }
      return '';
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String getExampleForQuestion(String question) {
    switch (question) {
      case 'What is your age?':
        return 'e.g., 29';
      case 'What is your goal?':
        return 'e.g., Lose weight, Gain muscle';
      case 'Do you have any injuries (current or previous)?':
        return 'e.g., Knee injury, Back injury';
      case 'How often do you exercise?':
        return 'e.g., 3 times a week';
      case 'What do you want to focus on or improve?':
        return 'e.g., Abs, Arms, Legs';
      case 'What is your height?':
        return 'e.g., 170 cm';
      case 'What is your weight?':
        return 'e.g., 70 kg';
      case 'Gender':
        return 'Male, Female, other, prefer not to say';
      default:
        return '';
    }
  }

  String createPromptFromAnswers(Map<String, String> userAnswers) {
    String prompt =
        "I have a user who needs a personalized workout plan. Here are their details:\n";

    userAnswers.forEach((question, answer) {
      // Format each question-answer pair into a readable sentence
      String formattedQuestion = question.replaceAll('?', '');
      prompt += "- ${formattedQuestion}: ${answer}.\n";
    });

    prompt +=
        "\nCan you create a personalized workout plan based on these details and the user's goals and can you also include the number of sets and reps for each exercise? Could also style the workout plan to make it look nice.";

    return prompt;
  }

  Future<String> generateWorkoutPlan(String prompt) async {
    String workoutPlan;
    try {
      workoutPlan = await ChatGPTService().sendPromptToOpenAI(prompt);
    } catch (e) {
      print('Error in generating: $e');
      rethrow;
    }

    return workoutPlan;
  }
}
