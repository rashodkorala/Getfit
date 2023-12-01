import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/login_view.dart';
import 'view/sign_up_view.dart';
import 'view/forgot_password_view.dart';
import 'view/home_page.dart';
import 'firebase_options.dart';

// This needs to be a top-level function for Firebase Messaging background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Set up the background messaging handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  // Add the Firebase Messaging initialization here
  Future<void> _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Requesting permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // If user granted permission, get the token
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      print(
          "FCM Token: $token"); // You can remove this line after confirming token retrieval works
      // Perform the necessary actions with the token
    } else {
      // Handle the case where the user did not grant permissions
      print('User declined or has not accepted permission');
    }
  }

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
        //'/remindersettings': (context) => ReminderSettingsScreen(),
      },
    );
  }
}
