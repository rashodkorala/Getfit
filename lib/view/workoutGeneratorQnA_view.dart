import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Plan Questionnaire'),
      ),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: currentStep,
        onStepContinue: () async {
          if (validateCurrentStep()) {
            if (currentStep == questions.length - 1) {
              String workoutPlanPrompt = processUserAnswers();
              print('Workout plan prompt: $workoutPlanPrompt');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeneratedWorkoutView(
                    workoutPlanFuture: generateWorkoutPlan(workoutPlanPrompt),
                  ),
                ),
              ).then((value) => Navigator.pop(context));
            }
          }

          setState(() {
            if (currentStep < questions.length - 1) {
              currentStep += 1;
              print('Current step: $currentStep');
              print('Questions length: ${questions.length}');
            }
          });
        },
        onStepCancel: () {
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

  String processUserAnswers() {
    Map<String, String> userAnswers = {};

    for (int i = 0; i < questionControllers.length; i++) {
      String question = questions[i];
      String answer = questionControllers[i].text;
      userAnswers[question] = answer;
    }

    String userPrompt = createPromptFromAnswers(userAnswers);

    return userPrompt;
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
      String formattedQuestion = question.replaceAll('?', '');
      prompt += "- ${formattedQuestion}: ${answer}.\n";
    });

    prompt +=
        "\nBased on the above details, please create a personalized workout plan with the number of sets and reps for each exercise. Format the plan in Markdown into a table format, with the exercise name, number of sets, and number of reps in each row. create a table for each day ";

    return prompt;
  }
}
