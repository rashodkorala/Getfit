import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BodyMeasurementView extends StatefulWidget {
  const BodyMeasurementView({super.key});

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
        for (var entry in _controllers.entries)
          entry.key: double.tryParse(entry.value.text) ?? 0.0,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(user.uid)
          .collection('measurements')
          .add(measurements);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Measurements saved successfully!')));

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are not logged in.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Body Measurements'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var entry in _controllers.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: entry.value,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText:
                        '${entry.key[0].toUpperCase()}${entry.key.substring(1)} (inches)',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            Center(
              child: ElevatedButton(
                onPressed: saveMeasurements,
                child: const Text('Save Measurements'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
