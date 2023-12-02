import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_view.dart';
import 'statistics_view.dart'; // Ensure you have this file created for statistics.

class HomePage extends StatelessWidget {
  final User? currentUser;

  const HomePage({Key? key, required this.currentUser}) : super(key: key);

  Future<void> signOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userUID');
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginView()));
    } catch (error) {
      print(error.toString());
    }
  }

  void navigateToStatistics(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => StatisticsView()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${currentUser?.email ?? 'User'}!',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => navigateToStatistics(context),
              child: Text('View Statistics'),
            ),
            // Other buttons or widgets can be added here
          ],
        ),
      ),
    );
  }
}
