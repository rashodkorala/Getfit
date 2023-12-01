import 'package:flutter/material.dart';
import 'package:getfit/controller/chatGPTService.dart';

import 'generatedWorkout_view.dart';

class PersonalizedPlanQuestionnairePage extends StatefulWidget {
  @override
  _PersonalizedPlanQuestionnairePageState createState() =>
      _PersonalizedPlanQuestionnairePageState();
}

class _PersonalizedPlanQuestionnairePageState
    extends State<PersonalizedPlanQuestionnairePage> {
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
                      Future.delayed(Duration(seconds: 2));
                      processUserAnswers();
                    }
                  });
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
                      // Text(
                      //   'Example: ' + getExampleForQuestion(questions[index]),
                      //   style: TextStyle(
                      //       fontSize: 12,
                      //       fontStyle: FontStyle.italic,
                      //       color: Colors.grey),
                      // ),
                      TextFormField(
                        controller: questionControllers[index],
                        keyboardType: index == 0 || index == 1 || index == 2
                            ? TextInputType.number
                            : TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Example: ' +
                              getExampleForQuestion(questions[index]),
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

  void processUserAnswers() async {
    Map<String, String> userAnswers = {};

    for (int i = 0; i < questionControllers.length; i++) {
      String question = questions[i];
      String answer = questionControllers[i].text;
      userAnswers[question] = answer;
    }

    // Simulate stopping the loading state after processing answers
    setState(() {
      isLoading = false;
    });

    // Add code here to call the API and generate the workout plan
    String userPrompt = createPromptFromAnswers(userAnswers);
    generateWorkoutPlan(userPrompt);

    // You can replace the above line with actual API call
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
        "\nCan you create a personalized workout plan based on these details?";

    return prompt;
  }

  void generateWorkoutPlan(String prompt) async {
    try {
      String workoutPlan = await ChatGPTService().sendPromptToOpenAI(prompt);
      // print('Generated Workout Plan:\n$workoutPlan');

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutPlanScreen(workoutPlan: workoutPlan),
        ),
      );
      // Display the workout plan to the user or process it as needed
    } catch (e) {
      print('Error in generating: $e');
      // Handle the error appropriately
      throw e; // Add a throw statement to handle the potential non-nullable return type
    }
  }
}
