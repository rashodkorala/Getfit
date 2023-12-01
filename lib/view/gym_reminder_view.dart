import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
              title: Text("Date: ${selectedDate.toLocal()}"),
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
    if (user != null) {
      Timestamp reminderTimestamp = Timestamp.fromDate(DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute));

      try {
        await FirebaseFirestore.instance.collection('gym_reminders').add({
          'userId': user.uid,
          'reminderTime': reminderTimestamp,
        });

        // Navigate back to home page and show the pop-up after setting the reminder
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Gym Reminder Set"),
            content: Text(
                "Gym reminder set for: ${selectedDate.toLocal()} at ${selectedTime.format(context)}"),
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
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error setting reminder: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: No user logged in'),
      ));
    }
  }

  void _initializeFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await messaging.getToken();
      User? user = FirebaseAuth.instance.currentUser;

      if (token != null && user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'token': token,
        }, SetOptions(merge: true));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFirebaseMessaging();
  }
}
