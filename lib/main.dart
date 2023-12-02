import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/login_view.dart';
import 'view/sign_up_view.dart';
import 'view/forgot_password_view.dart';
import 'view/home_page.dart';
import 'package:getfit/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if the user is already logged in
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? userUID = prefs.getString('userUID');

  runApp(MyApp(isLoggedIn: userUID != null && userUID.isNotEmpty));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Get Fit',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: widget.isLoggedIn
          ? HomePage(currentUser: FirebaseAuth.instance.currentUser)
          : LoginViewWithDarkModeSwitch(
        onDarkModeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
      ),
      routes: {
        '/signup': (context) => SignUpView(),
        '/forgotpassword': (context) => ForgotPasswordView(),
      },
    );
  }
}
