import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BodyMeasurementView extends StatefulWidget {
  @override
  _BodyMeasurementViewState createState() => _BodyMeasurementViewState();
}

class _BodyMeasurementViewState extends State<BodyMeasurementView> {
  final Map<String, TextEditingController> _controllers = {
    'chest': TextEditingController(),
    'waist': TextEditingController(),
    'hips': TextEditingController(),
    'arm': TextEditingController(),
    'thigh': TextEditingController(),
    'calf': TextEditingController(),
  };

  Future<void> saveMeasurements() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.isAnonymous) {
      final measurements = {
        for (var entry in _controllers.entries) entry.key: entry.value.text
      };

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .collection('measurements')
          .add(measurements); // Save the measurements to Firestore

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Measurements saved successfully!')));

      // Navigate back to the HomePage
      Navigator.of(context).popUntil(
          (route) => route.isFirst); // This assumes HomePage is the first route
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('You are not logged in.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Body Measurements'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in _controllers.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: entry.value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText:
                        '${entry.key[0].toUpperCase()}${entry.key.substring(1)} (inches)',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            Center(
              child: ElevatedButton(
                onPressed: saveMeasurements,
                child: Text('Save Measurements'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
