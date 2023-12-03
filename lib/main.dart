import 'package:flutter/material.dart';
import 'package:getfit/view/image_diary_add.dart'; // Import your ImageDiaryScreen
import 'package:getfit/view/image_diary_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(), // Changed here
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ImageDiaryView()),
            );
          },
          child: Text('Open Image Diary'),
        ),
      ),
    );
  }
}
