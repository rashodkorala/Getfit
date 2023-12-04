import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// view that lets the user set gym reminders with date and time which are then stored in firebase
class GymReminderView extends StatefulWidget {
  @override
  _GymReminderViewState createState() => _GymReminderViewState();
}

class _GymReminderViewState extends State<GymReminderView> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Gym Reminder'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Date: ${selectedDate.toLocal().toString()}"),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text("Time: ${selectedTime.format(context)}"),
              trailing: const Icon(Icons.keyboard_arrow_down),
              onTap: () => _selectTime(context),
            ),
            ElevatedButton(
              onPressed: () => _setReminder(),
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  void _setReminder() async {
    User? user = FirebaseAuth.instance.currentUser;
    String? token = await FirebaseMessaging.instance.getToken();

    if (user != null && token != null) {
      final DateTime reminderDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      final Timestamp reminderTimestamp =
          Timestamp.fromDate(reminderDateTime.toUtc());

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .collection('gym_reminders')
          .add({
        'userId': user.uid,
        'reminderTime': reminderTimestamp,
        'token': token,
      });

      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Gym Reminder Set"),
          content: Text(
              "Gym reminder set for: ${reminderDateTime.toLocal().toString().split('.').first}"), // Updated line
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: No user logged in'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }

  void _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();

      User? user = FirebaseAuth.instance.currentUser;
      if (token != null && user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'token': token,
        }, SetOptions(merge: true));
      }
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
