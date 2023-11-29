import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await saveUserCredentials(currentUser.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(currentUser: currentUser)),
        );
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> saveUserCredentials(String userUID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userUID', userUID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Get Fit',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                signIn(context);
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text('Sign Up'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgotpassword');
              },
              child: Text('Forgot Password?'),
            ),
          ],
        ),
      ),
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
