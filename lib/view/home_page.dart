import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getfit/view/settings_view.dart';
import 'package:getfit/view/login_view.dart';
import 'dart:io';
import 'package:getfit/view/chatbot_screen.dart';
import 'package:getfit/view/water_intake_page.dart';
import 'package:getfit/view/personalizedmealplanquestionnaire_view.dart';
import 'package:getfit/view/WorkoutListView.dart';

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
    fetchUserProfile();

    _pages = [
      WorkoutListView(),
      //FoodIntakePage(),
      WaterIntakePage(),
      PersonalizedMealPlanQuestionnairePage(),
    ];
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
      fetchUserProfile();
    }
  }

  Future<void> logOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginViewWithDarkModeSwitch(
            onDarkModeChanged: (value) {},
          ),
        ),
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  void navigateToChatbot(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(currentUser: widget.currentUser),
      ),
    );
  }

  int _currentIndex = 0;
  late List<Widget> _pages;



  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;

      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutListView()),
        );
      }

      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WaterIntakePage()),
        );
      }

      if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PersonalizedMealPlanQuestionnairePage()),
        );
      }
    });
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
            Text(
              'Welcome, ${userProfile?['name'] ?? widget.currentUser?.email ?? 'Guest'}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
                    Text(
                      '${userProfile?['description'] ?? 'No bio available'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            if (userProfile != null) ...[
              SizedBox(height: 20),
              _buildProfileInfo('Gender', userProfile?['gender'] ?? 'N/A'),
              _buildProfileInfo('Age', userProfile?['age']?.toString() ?? 'N/A'),
              _buildProfileInfo('Weight (kg)', userProfile?['weight']?.toString() ?? 'N/A'),
              _buildProfileInfo('Height (cm)', userProfile?['height']?.toString() ?? 'N/A'),
              _buildProfileInfo('Activity Level', userProfile?['activityLevel'] ?? 'N/A'),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoBox('BMI', userProfile?['bmi']?.toString() ?? 'N/A'),
                  _buildInfoBox('TDEE', '${userProfile?['tdee']?.toString() ?? 'N/A'} Calories'),
                ],
              ),
              // Add other fields as needed
            ],
            Spacer(), // To push the chat button to the bottom
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Have a question? Ask our chat bot!',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: () {
                      navigateToChatbot(context);
                    },
                    child: Icon(Icons.chat),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workout',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: 'Water Intake',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: 'Food Intake',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Meal Plans',
          ),
        ],
      ),
    );
  }


  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: 160,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blue.shade900,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade300,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}



