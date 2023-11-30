import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/meal_firestore_model.dart';
import '../controller/meal_firestore_controller.dart';

/* THINGS TO FIX
 * Check ID generation
 * Check database connection with form submission
 * Check form validation
 * 
 */

class AddMealScreen extends StatefulWidget {
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form field variables
  String _name = '';
  String _description = '';
  String _calories = '';
  DateTime _selectedDate = DateTime.now();
  String _mealType = 'Breakfast'; // Default value
  final List<String> mealTypes = ['Snack', 'Breakfast', 'Lunch', 'Dinner'];

  // Creating the form widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal Entry'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              // Meal name
              decoration: InputDecoration(labelText: 'Meal Name'),
              onSaved: (value) => _name = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
            ),

            // Meal description
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
            ),

            // Meal calories
            TextFormField(
              decoration: InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _calories = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter calorie count' : null,
            ),

            // Meal date
            ListTile(
              title:
                  Text('Meal Date: ${DateFormat.yMd().format(_selectedDate)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _selectedDate) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
            ),

            // Meal type
            DropdownButtonFormField(
              value: _mealType,
              items: mealTypes.map((String type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _mealType = newValue!;
                });
              },
            ),

            // Submit button
            ElevatedButton(
              child: Text('Submit'),
              onPressed: _submitForm,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Create a new MealEntry object
      MealEntry newMealEntry = MealEntry(
        id: '', // Generate an ID or leave blank if Firestore generates it
        meal_name: _name,
        meal_description: _description,
        meal_calories: _calories,
        meal_type: _mealType,
        meal_date: DateFormat.yMd().format(_selectedDate),
        rating: 0, // Or implement a way to capture rating
      );
      // Use FirestoreMealEntryService to add the new entry
      FirestoreMealEntryService().addMealEntry(newMealEntry).then((result) {
        // Handle success, perhaps pop the screen or show a success message
      }).catchError((error) {
        // Handle error
      });
    }
  }
}
