import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/meal_firestore_model.dart';

class FirestoreMealEntryService {
  final user = FirebaseAuth.instance.currentUser;

  final CollectionReference mealEntriesCollection;

  FirestoreMealEntryService()
      : mealEntriesCollection = FirebaseFirestore.instance
            .collection('meal_entries')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('userMealEntries');

  Future<DocumentReference<Object?>> addMealEntry(MealEntry mealEntry) async {
    return await mealEntriesCollection.add(mealEntry.toMap());
  }

  Future<List<MealEntry>> getAllMealEntries() async {
    QuerySnapshot snapshot = await mealEntriesCollection.get();
    return snapshot.docs.map((doc) => MealEntry.fromMap(doc)).toList();
  }

  Future<void> updateMealEntry(MealEntry mealEntry) async {
    return await mealEntriesCollection
        .doc(mealEntry.id)
        .update(mealEntry.toMap());
  }

  Future<void> deleteMealEntry(MealEntry mealEntry) async {
    return await mealEntriesCollection.doc(mealEntry.id).delete();
  }
}