import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_view.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final User? currentUser;

  const HomePage({Key? key, required this.currentUser}) : super(key: key);

  Future<void> signOut(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userUID');

      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginViewWithDarkModeSwitch(
                onDarkModeChanged: (value) {
                  // Add dark mode toggle logic here if needed
                },
              )));
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              signOut(context);
            },
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
              onPressed: () {
                readAndUploadData();
              },
              child: Text('Upload data to Firestore'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> readJsonData() async {
  final String response =
      await rootBundle.loadString('assets/data/Exerscise.json');
  final data = await json.decode(response) as List;
  return List<Map<String, dynamic>>.from(data);
}

Future<void> uploadDataToFirestore(List<Map<String, dynamic>> data) async {
  final firestoreInstance = FirebaseFirestore.instance;
  final collectionRef = firestoreInstance.collection('my_collection');

  for (var item in data) {
    await collectionRef.add(item).catchError((e) {
      print(e); // Handle the error appropriately
    });
  }
}

Future<void> readAndUploadData() async {
  final jsonData = await readJsonData();
  try {
    await uploadDataToFirestore(jsonData);
  } catch (e) {
    print(e);
  }
}
