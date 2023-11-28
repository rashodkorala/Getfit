import 'package:getfit/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/login_view.dart';
import 'view/sign_up_view.dart';
import 'view/forgot_password_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
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
      home: LoginViewWithDarkModeSwitch(
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

class LoginViewWithDarkModeSwitch extends StatelessWidget {
  final ValueChanged<bool> onDarkModeChanged;

  const LoginViewWithDarkModeSwitch({
    required this.onDarkModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        actions: [
          Row(
            children: [
              Text('Dark Mode'),
              Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  onDarkModeChanged(value);
                },
              ),
            ],
          ),
        ],
      ),
      body: LoginView(),
    );
  }
}
