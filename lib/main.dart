import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/login_view.dart';
import 'view/sign_up_view.dart';
import 'view/forgot_password_view.dart';
import 'view/home_page.dart';
import 'package:getfit/firebase_options.dart';
import 'package:getfit/model/user_profile_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is already logged in
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userUID = prefs.getString('userUID');

  User? currentUser = FirebaseAuth.instance.currentUser;
  UserProfile? userProfile;

  if (userUID != null && userUID.isNotEmpty) {
    userProfile = await UserProfile().getUserProfile(userUID);
  }

  runApp(MyApp(isLoggedIn: userUID != null && userUID.isNotEmpty, currentUser: currentUser, userProfile: userProfile));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final User? currentUser;
  final UserProfile? userProfile;

  const MyApp({Key? key, required this.isLoggedIn, this.currentUser, this.userProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _isDarkMode = false;

    return MaterialApp(
      title: 'Get Fit',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: isLoggedIn
          ? HomePage(currentUser: currentUser!, userProfile: userProfile!)
          : LoginViewWithDarkModeSwitch(
        onDarkModeChanged: (value) {
          _isDarkMode = value;
        },
      ),
      routes: {
        '/signup': (context) => SignUpView(),
        '/forgotpassword': (context) => ForgotPasswordView(),
      },
    );
  }
}

