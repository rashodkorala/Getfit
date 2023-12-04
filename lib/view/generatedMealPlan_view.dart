import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class MealPlanScreen extends StatelessWidget {
  final String mealPlan;

  const MealPlanScreen({Key? key, required this.mealPlan}) : super(key: key);

  Future<void> generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(mealPlan, style: pw.TextStyle(fontSize: 16)),
        ),
      ),
    );

    try {
      final dir = await getExternalStorageDirectory();
      final file = File("${dir?.path}/MealPlan.pdf");
      await file.writeAsBytes(await pdf.save());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved in ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save PDF: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Personalized Meal Plan'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          mealPlan,
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
