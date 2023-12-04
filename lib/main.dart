import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'view/view_meal.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Main Page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => ViewMealScreen(userId: user.uid)),
                );
              }
            },
            child: Text('Add Meal'),
          ),
        ),
      ),
    );
  }
}
