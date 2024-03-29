import 'package:cloud_firestore/cloud_firestore.dart';

class MealEntry {
  final String id;
  final String meal_name;
  final String meal_description;
  final String meal_calories;
  final String meal_type;
  final String meal_date;
  final int rating;

  MealEntry({
    required this.id,
    required this.meal_name,
    required this.meal_description,
    required this.meal_calories,
    required this.meal_type,
    required this.meal_date,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'meal_name': meal_name,
      'meal_description': meal_description,
      'meal_calories': meal_calories,
      'meal_type': meal_type,
      'meal_date': meal_date,
      'rating': rating,
    };
  }

  static MealEntry fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return MealEntry(
      id: map['id'],
      meal_name: map['meal_name'],
      meal_description: map['meal_description'],
      meal_calories: map['meal_calories'],
      meal_type: map['meal_type'],
      meal_date: map['meal_date'],
      rating: map['rating'],
    );
  }
}
