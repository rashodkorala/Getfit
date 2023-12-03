// ignore_for_file: use_super_parameters, avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

import '../controller/chatGPTService.dart';
// import 'package:printing/printing.dart';

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
            child:
                pw.Text(workoutPlan, style: const pw.TextStyle(fontSize: 16)),
          );
        },
      ),
    );

    try {
      final dir = await getExternalStorageDirectory();
      final file = File("${dir?.path}/WorkoutPlan1.pdf");
      await file.writeAsBytes(await pdf.save());
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text(
                snapshot.data!,
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else {
            return const Center(child: Text('No workout plan found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ignore: unnecessary_null_comparison
          if (workoutPlanFuture != null) {
            var workoutPlan = await workoutPlanFuture;
            // ignore: use_build_context_synchronously
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
