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
  //TextEditingController genderController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String selectedActivityLevel = 'Sedentary'; // Default value for dropdown
  String selectedGender = 'Male'; // Default value for gender dropdown

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('profiles').doc(widget.currentUser?.uid).get();

    if (snapshot.exists) {
      setState(() {
        //genderController.text = snapshot.data()?['gender'] ?? '';
        ageController.text = snapshot.data()?['age']?.toString() ?? '';
        weightController.text = snapshot.data()?['weight']?.toString() ?? '';
        heightController.text = snapshot.data()?['height']?.toString() ?? '';
        selectedActivityLevel = snapshot.data()?['activityLevel'] ?? 'Sedentary';
        selectedGender = snapshot.data()?['gender'] ?? 'Male';
      });
    }
  }

  Future<void> updateProfile() async {
    String gender = selectedGender;
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

      Navigator.pop(context);
    } catch (e) {
      print('Error updating profile data: $e');
    }
  }

  double calculateBMI(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  double calculateTDEE(double weight, double height, int age, String gender, String activitylevel) {
    double bmr;
    if (gender == 'Male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    switch (activitylevel) {
      case 'Sedentary':
        return bmr * 1.2;
      case 'Lightly active':
        return bmr * 1.375;
      case 'Moderately active':
        return bmr * 1.55;
      case 'Very active':
        return bmr * 1.725;
      case 'Super active':
        return bmr * 1.9;
      default:
        return bmr;
    }
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
            DropdownButton<String>(
              value: selectedGender,
              items: [
                DropdownMenuItem<String>(
                  value: 'Male',
                  child: Text('Male'),
                ),
                DropdownMenuItem<String>(
                  value: 'Female',
                  child: Text('Female'),
                ),
                DropdownMenuItem<String>(
                  value: 'Other',
                  child: Text('Other'),
                ),
              ],
              onChanged: (newValue) {
                setState(() {
                  selectedGender = newValue!;
                });
              },
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
                  value: 'Sedentary',
                  child: Text('Sedentary'),
                ),
                DropdownMenuItem<String>(
                  value: 'Lightly Active',
                  child: Text('Lightly Active'),
                ),
                DropdownMenuItem<String>(
                  value: 'Moderately Active',
                  child: Text('Moderately Active'),
                ),
                DropdownMenuItem<String>(
                  value: 'Very active',
                  child: Text('Very active'),
                ),
                DropdownMenuItem<String>(
                  value: 'Super active',
                  child: Text('Super active'),
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
