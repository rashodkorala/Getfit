import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getfit/view/home_page.dart';

class ProfileCreationPage extends StatefulWidget {
  final User? currentUser;

  const ProfileCreationPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _ProfileCreationPageState createState() => _ProfileCreationPageState();
}

class _ProfileCreationPageState extends State<ProfileCreationPage> {
  TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController activityLevelController = TextEditingController();

  Future<bool> hasCompletedProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('profileCompleted') ?? false;
  }

  Future<void> saveProfileData() async {
    String gender = genderController.text;
    int age = int.tryParse(ageController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    String activityLevel = activityLevelController.text;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      CollectionReference profiles = firestore.collection('profiles');

      DocumentReference profileRef = profiles.doc(widget.currentUser?.uid);

      await profileRef.set({
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'activityLevel': activityLevel,
      });

      await firestore.collection('users').doc(widget.currentUser?.uid).update({
        'profileCompleted': true,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('profileCompleted', true); // Update local storage

      bool completed = await hasCompletedProfile(); // Check if profile completed

      if (completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(currentUser: widget.currentUser)),
        );
      }
    } catch (e) {
      print('Error saving profile data: $e');
      // Handle any potential errors here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: heightController,
              decoration: InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: activityLevelController,
              decoration: InputDecoration(labelText: 'Activity Level'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                saveProfileData();
              },
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
