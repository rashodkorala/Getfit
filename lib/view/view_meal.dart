import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../model/meal_firestore_model.dart';
import 'add_meal.dart';

class ViewMealScreen extends StatefulWidget {

  ViewMealScreen({Key? key}) : super(key: key);

  @override
  _ViewMealScreenState createState() => _ViewMealScreenState();
}

class _ViewMealScreenState extends State<ViewMealScreen> {
  late final CollectionReference mealEntriesCollection;

  @override
  void initState() {
    super.initState();
    mealEntriesCollection = FirebaseFirestore.instance
        .collection('meal_entries')
        .doc()
        .collection('userMealEntries');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Meals'),
      ),
      body: StreamBuilder(
        stream: mealEntriesCollection
            .orderBy('meal_date', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No meals to show'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              MealEntry meal = MealEntry.fromMap(
                  snapshot.data!.docs[index].data() as DocumentSnapshot<Object?>);
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd()
                            .format(DateTime.parse(meal.meal_date)),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        meal.meal_type,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Text(meal.meal_name),
                      Text(meal.meal_description),
                      // Add more details as needed
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddMealScreen()),
          );
        },
        tooltip: 'Add Meal',
        child: Icon(Icons.add),
      ),
    );
  }
}
