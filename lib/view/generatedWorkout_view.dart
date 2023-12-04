import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../controller/chatGPTService.dart';
import 'package:markdown/markdown.dart' as md;

class GeneratedWorkoutView extends StatelessWidget {
  final Future<String> workoutPlanFuture;

  const GeneratedWorkoutView({Key? key, required this.workoutPlanFuture})
      : super(key: key);

  Future<void> generateAndSavePdf(
      BuildContext context, String workoutPlan) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(markdownToHtml(workoutPlan)),
          );
        },
      ),
    );

    try {
      final dir = await getExternalStorageDirectory();
      final file = File("${dir?.path}/WorkoutPlan.pdf");
      await file.writeAsBytes(await pdf.save());

      saveMd(workoutPlan, 'WorkoutPlan');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved in ${file.path}')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personalized Workout Plan'),
      ),
      body: FutureBuilder<String>(
        future: workoutPlanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingScreen();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return WorkoutPlanDisplay(workoutPlan: snapshot.data!);
          } else {
            return const Center(child: Text('No workout plan found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var workoutPlan = await workoutPlanFuture;
          if (workoutPlan != null) {
            generateAndSavePdf(context, workoutPlan);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to save PDF')),
            );
          }
        },
        tooltip: 'Save as PDF',
        child: const Icon(Icons.save),
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
}

class WorkoutPlanDisplay extends StatelessWidget {
  final String workoutPlan;

  const WorkoutPlanDisplay({Key? key, required this.workoutPlan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: workoutPlan,
      padding: const EdgeInsets.all(16),
      styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
        p: const TextStyle(fontSize: 16),
      ),
    );
  }
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

String markdownToHtml(String markdown) {
  return md.markdownToHtml(markdown,
      extensionSet: md.ExtensionSet.gitHubFlavored);
}

Future<File> saveMd(String markdownContent, String filename) async {
  final directory = await getTemporaryDirectory();
  print(directory); // or getTemporaryDirectory()
  final file = File('${directory.path}/$filename.md');
  return file.writeAsString(markdownContent);
}
