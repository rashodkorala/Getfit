import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
// import 'package:printing/printing.dart';

class GeneratedWorkoutView extends StatelessWidget {
  final String workoutPlan;

  const GeneratedWorkoutView({Key? key, required this.workoutPlan})
      : super(key: key);

  Future<void> generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(workoutPlan, style: pw.TextStyle(fontSize: 16)),
          );
        },
      ),
    );

    try {
      //set the path where we want to save the pdf

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
        title: Text('Your Personalized Workout Plan'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          workoutPlan,
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => generateAndSavePdf(context),
        child: Icon(Icons.save),
        tooltip: 'Save as PDF',
      ),
    );
  }
}
