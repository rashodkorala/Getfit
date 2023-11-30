import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SettingsPage extends StatefulWidget {
  final User? currentUser;

  const SettingsPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String selectedActivityLevel = 'Sedentary'; // Default value for dropdown
  String selectedGender = 'Male'; // Default value for gender dropdown
  TextEditingController bmiController = TextEditingController();
  TextEditingController tdeeController = TextEditingController();
  File? selectedProfilePicture;
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfileData();
    loadImagePathFromLocal();
  }

  Future<void> fetchProfileData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await firestore.collection('profiles').doc(widget.currentUser?.uid).get();

    if (snapshot.exists) {
      setState(() {
        //genderController.text = snapshot.data()?['gender'] ?? '';
        nameController.text = snapshot.data()?['name']?.toString() ?? '';
        ageController.text = snapshot.data()?['age']?.toString() ?? '';
        weightController.text = snapshot.data()?['weight']?.toString() ?? '';
        heightController.text = snapshot.data()?['height']?.toString() ?? '';
        selectedActivityLevel = snapshot.data()?['activityLevel'] ?? 'Sedentary';
        selectedGender = snapshot.data()?['gender'] ?? 'Male';
        bmiController.text = snapshot.data()?['bmi'] ?? '';
        tdeeController.text = snapshot.data()?['tdee'] ?? '';
        selectedProfilePicture = File(snapshot.data()?['profilePicture'] ?? '');
        descriptionController.text = snapshot.data()?['description'] ?? '';

      });
    }
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedProfilePicture = File(pickedFile.path);
        saveImagePathToLocal(pickedFile.path);
      });
    }
  }

  Future<void> saveImagePathToLocal(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profilePicturePath', imagePath);
  }

  Future<void> loadImagePathFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profilePicturePath');
    if (imagePath != null) {
      setState(() {
        selectedProfilePicture = File(imagePath);
      });
    }
  }

  Future<void> updateProfile() async {
    String name = nameController.text;
    String gender = selectedGender;
    int age = int.tryParse(ageController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double height = double.tryParse(heightController.text) ?? 0.0;
    String activityLevel = selectedActivityLevel;
    double bmi = calculateBMI(weight, height);
    double tdee = calculateTDEE(weight, height, age, gender, activityLevel);
    String profilePicture = selectedProfilePicture != null
      ? 'assets/default_profile_image.png'
      : '';
    String description = descriptionController.text;



    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      CollectionReference profiles = firestore.collection('profiles');

      await profiles.doc(widget.currentUser?.uid).set({
        'name': name,
        'gender': gender,
        'age': age,
        'weight': weight,
        'height': height,
        'activityLevel': activityLevel,
        'bmi': bmi,
        'tdee': tdee,
        'profilePicture': profilePicture,
        'description': description,
      }, SetOptions(merge: true));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('profileCompleted', true);

      Navigator.pop(context, selectedProfilePicture);
    } catch (e) {
      print('Error updating profile data: $e');
    }
  }

  double calculateBMI(double weight, double height) {
    double bmi = weight / ((height / 100) * (height / 100));
    return double.parse(bmi.toStringAsFixed(2));
  }

  double calculateTDEE(double weight, double height, int age, String gender, String activitylevel) {
    double bmr;
    if (gender == 'Male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
      return double.parse(bmr.toStringAsFixed(2));
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    switch (activitylevel) {
      case 'Sedentary':
        return double.parse((bmr * 1.2).toStringAsFixed(2));
      case 'Lightly active':
        return double.parse((bmr * 1.375).toStringAsFixed(2));
      case 'Moderately active':
        return double.parse((bmr * 1.55).toStringAsFixed(2));
      case 'Very active':
        return double.parse((bmr * 1.725).toStringAsFixed(2));
      case 'Super active':
        return double.parse((bmr * 1.9).toStringAsFixed(2));
      default:
        return double.parse(bmr.toStringAsFixed(2));
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
            GestureDetector(
              onTap: () {
                _getImage();
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: selectedProfilePicture != null
                          ? ClipOval(
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.file(
                            selectedProfilePicture!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : Icon(
                        Icons.account_circle,
                        size: 120,
                        color: Colors.grey,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 130,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _getImage();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                  labelText: 'Bio',
                  hintText: 'Write a short bio...',
                border: OutlineInputBorder(),
              ),
                keyboardType: TextInputType.text,
                maxLines: 1,
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'User Name'),
              keyboardType: TextInputType.text,
            ),
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
