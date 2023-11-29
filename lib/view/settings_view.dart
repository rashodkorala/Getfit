import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getfit/view/home_page.dart';

class SettingsPage extends StatefulWidget {
  final User? currentUser;

  const SettingsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController genderController;
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late String selectedActivityLevel;

  @override
  void initState() {
    super.initState();
    genderController = TextEditingController();
    ageController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();
    selectedActivityLevel = 'Low';

    // Fetch profile data and set the text controllers
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('profiles').doc(widget.currentUser?.uid).get();

    if (snapshot.exists) {
      Map<String, dynamic>? userProfile = snapshot.data();
      setState(() {
        genderController.text = userProfile?['gender'] ?? '';
        ageController.text = userProfile?['age']?.toString() ?? '';
        weightController.text = userProfile?['weight']?.toString() ?? '';
        heightController.text = userProfile?['height']?.toString() ?? '';
        selectedActivityLevel = userProfile?['activityLevel'] ?? 'Low';
      });
    }
  }

  Future<void> updateProfile() async {
    // Retrieve entered data
    String gender = genderController.text;
    int age = int.tryParse(ageController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    String activityLevel = selectedActivityLevel;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      CollectionReference profiles = firestore.collection('profiles');

      await profiles.doc(widget.currentUser?.uid).set({
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'activityLevel': activityLevel,
      }, SetOptions(merge: true));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('profileCompleted', true);

      // Navigate back to the home page or profile page after updating
      Navigator.pop(context);
    } catch (e) {
      print('Error updating profile data: $e');
    }
  }

  @override
  void dispose() {
    // Dispose the controllers
    genderController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
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
            DropdownButton<String>(
              value: selectedActivityLevel,
              items: [
                DropdownMenuItem<String>(
                  value: 'Low',
                  child: Text('Low'),
                ),
                DropdownMenuItem<String>(
                  value: 'Moderate',
                  child: Text('Moderate'),
                ),
                DropdownMenuItem<String>(
                  value: 'High',
                  child: Text('High'),
                ),
              ],
              onChanged: (newValue) {
                setState(() {
                  selectedActivityLevel = newValue!;
                });
              },
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                updateProfile();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
