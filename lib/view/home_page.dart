import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getfit/view/settings_view.dart';
import 'package:getfit/view/login_view.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  final User? currentUser;

  const HomePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? userProfile;
  File? selectedProfilePicture;

  @override
  void initState() {
    super.initState();
    // Fetch user profile data
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('profiles').doc(widget.currentUser?.uid).get();

    if (snapshot.exists) {
      setState(() {
        userProfile = snapshot.data();
      });
    }
  }

  void navigateToSettings(BuildContext context) async {
    final selectedPicture = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(currentUser: widget.currentUser),
      ),
    );

    if (selectedPicture != null) {
      setState(() {
        this.selectedProfilePicture = selectedPicture as File;
      });
      // Refresh data when returning from SettingsPage
      fetchUserProfile();
    }
  }



  Future<void> logOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut(); // Sign out the user from Firebase Auth

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginViewWithDarkModeSwitch(
            onDarkModeChanged: (value) {
              // Add dark mode toggle logic here if needed
            },
          ),
        ),
      );
    } catch (e) {
      print('Error logging out: $e');
      // Handle logout error if any
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              navigateToSettings(context);
            },
            icon: Icon(Icons.settings),
          ),
          IconButton(
            onPressed: () {
              logOut(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome, ${userProfile?['name'] ?? widget.currentUser?.email ?? 'Guest'}!'),
            SizedBox(height: 20),
            if (userProfile != null)
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    selectedProfilePicture != null
                        ? CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      backgroundImage: FileImage(selectedProfilePicture!),
                    )
                        : CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.account_circle, size: 60),
                    ),
                    SizedBox(height: 20),
                    Text('${userProfile?['description'] ?? 'No bio available'}'),
                  ],
                ),
              ),
            if (userProfile != null) ...[
              Text('${userProfile?['gender'] ?? 'N/A'}'),
              Text('Age: ${userProfile?['age'] ?? 'N/A'}'),
              Text('Weight (kg): ${userProfile?['weight'] ?? 'N/A'}'),
              Text('Height (cm): ${userProfile?['height'] ?? 'N/A'}'),
              Text('${userProfile?['activityLevel'] ?? 'N/A'}'),
              Text('BMI: ${userProfile?['bmi'] ?? 'N/A'}'),
              Text('TDEE: ${userProfile?['tdee'] ?? 'N/A'} Calories'),
              // Add other fields as needed
            ],
          ],
        ),
      ),
    );
  }
}
