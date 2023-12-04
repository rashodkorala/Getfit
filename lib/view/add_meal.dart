import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/meal_firestore_model.dart';
import '../controller/meal_firestore_controller.dart'; // Adjust this import based on your file structure

class AddMealScreen extends StatefulWidget {


  AddMealScreen({Key? key}) : super(key: key);

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
              decoration: InputDecoration(labelText: 'Meal Name'),
              onSaved: (value) => _name = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Calories'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _calories = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter calorie count' : null,
            ),
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
      MealEntry newMealEntry = MealEntry(
        id: '', // Firestore will generate the ID
        meal_name: _name,
        meal_description: _description,
        meal_calories: _calories,
        meal_type: _mealType,
        meal_date: DateFormat.yMd().format(_selectedDate),
        rating: 0, // Default rating or implement a way to capture this
      );

      FirestoreMealEntryService()
          .addMealEntry(newMealEntry)
          .then((result) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Meal Added Successfully')));
        Navigator.pop(
            context); // Optional: Return to the previous screen after submission
      }).catchError((error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding meal')));
      });
    }
  }
}
