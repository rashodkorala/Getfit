import 'package:flutter/material.dart';
import 'package:getfit/controller/chatGPTService.dart';
import 'generatedMealPlan_view.dart';

class PersonalizedMealPlanQuestionnairePage extends StatefulWidget {
  @override
  _PersonalizedMealPlanQuestionnairePageState createState() =>
      _PersonalizedMealPlanQuestionnairePageState();
}

class _PersonalizedMealPlanQuestionnairePageState
    extends State<PersonalizedMealPlanQuestionnairePage> {
  int currentStep = 0;

  List<String> questions = [
    'What is your age?',
    'What is your height in centimeters?',
    'What is your weight in kilograms?',
    'What is your gender?',
    'What are your dietary restrictions?',
    'What is your weight goal?',
    'How many meals do you prefer per day?',
    'Do you have any food allergies?',
    'How many meal plans do you want?',
  ];

  List<TextEditingController> questionControllers = List.generate(
    9,
    (index) => TextEditingController(),
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan Questionnaire'),
      ),
      body: isLoading ? _buildLoadingScreen() : _buildQuestionnaire(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildQuestionnaire() {
    return Stepper(
      type: StepperType.vertical,
      currentStep: currentStep,
      onStepContinue: _onStepContinue,
      onStepCancel: _onStepCancel,
      steps: List.generate(
        questions.length,
        (index) => Step(
          title: Text('Question ${index + 1}'),
          content: TextFormField(
            controller: questionControllers[index],
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: questions[index],
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }

  void _onStepContinue() {
    if (currentStep < questions.length - 1) {
      setState(() => currentStep++);
    } else {
      _generateMealPlan();
    }
  }

  void _onStepCancel() {
    if (currentStep > 0) {
      setState(() => currentStep--);
    }
  }

  void _generateMealPlan() async {
    setState(() => isLoading = true);

    // Collect user inputs
    Map<String, String> userInputs = {
      for (int i = 0; i < questionControllers.length; i++)
        questions[i]: questionControllers[i].text
    };

    // Create the prompt for the OpenAI API
    String prompt =
        "Please create a personalized meal plan with the following details:\n" +
            userInputs.entries.map((e) => "- ${e.key}: ${e.value}").join('\n');

    try {
      // Use ChatGPTService to send the prompt and get the meal plan
      String mealPlan = await ChatGPTService().sendPromptToOpenAI(prompt);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MealPlanScreen(mealPlan: mealPlan),
        ),
      );
    } catch (e) {
      print('Error in generating meal plan: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating meal plan: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
