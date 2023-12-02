import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WaterIntakePage extends StatefulWidget {
  @override
  _WaterIntakePageState createState() => _WaterIntakePageState();
}

class _WaterIntakePageState extends State<WaterIntakePage> {
  double totalIntake = 0.0;
  final double cupSize = 0.25;
  final double bottleHeight = 200.0;

  @override
  void initState() {
    super.initState();
    fetchWaterIntake();
  }

  Future<void> fetchWaterIntake() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('profiles')
          .doc(uid)
          .collection('waterIntake')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        double lastIntake = snapshot.docs.first.data()['intake'];
        setState(() {
          totalIntake = lastIntake;
        });
      }
    } catch (e) {
      print('Error fetching water intake: $e');
    }
  }

  Future<void> updateWaterIntake(double newIntake) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (newIntake > 0) {
        await firestore.collection('profiles').doc(uid).collection('waterIntake').add({
          'intake': newIntake,
          'timestamp': DateTime.now(),
        });
      } else {
        QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
            .collection('profiles')
            .doc(uid)
            .collection('waterIntake')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          String docId = snapshot.docs.first.id;
          await firestore.collection('profiles').doc(uid).collection('waterIntake').doc(docId).delete();
          setState(() {
            totalIntake = 0.0; // Reset the local intake to 0 after deletion
          });
        }
      }
    } catch (e) {
      print('Error updating water intake: $e');
    }
  }

  void incrementIntake() {
    setState(() {
      totalIntake += cupSize;
      updateWaterIntake(totalIntake);
    });
  }

  void decrementIntake() {
    setState(() {
      totalIntake -= cupSize;
      updateWaterIntake(totalIntake);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Intake'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: bottleHeight,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: AnimatedContainer(
                    height: (totalIntake / 1.0) * bottleHeight,
                    width: 80.0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Total Intake: ${totalIntake.toStringAsFixed(2)} L',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: incrementIntake,
                  child: Icon(Icons.add),
                ),
                SizedBox(width: 20.0),
                FloatingActionButton(
                  onPressed: decrementIntake,
                  child: Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
