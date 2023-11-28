// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:getfit/view/WorkoutListView.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetFit',
      home: WorkoutListView(),
    );
  }
}
