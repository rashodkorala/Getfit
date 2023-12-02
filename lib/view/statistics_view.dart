// views/statistics_view.dart
import 'package:flutter/material.dart';
import 'package:getfit/controller/statistics_controller.dart';
import 'package:getfit/model/user_statistics.dart';
//import 'package:getfit/model/workout_completed.dart';

class StatisticsView extends StatefulWidget {
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final StatisticsController _controller = StatisticsController();
  UserStatistics? _userStatistics;
  List<WorkoutCompleted>? _workouts;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await _controller.fetchLatestUserStatistics();
    final workouts = await _controller.fetchLatestWorkouts();
    setState(() {
      _userStatistics = stats;
      _workouts = workouts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Statistics'),
      ),
      body: _userStatistics == null || _workouts == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text('Body Measurements:'),
                  // Display user statistics here
                  Text('BMI: ${_userStatistics?.bmi?.toStringAsFixed(2)}'),
                  // Display workout details here
                ],
              ),
            ),
    );
  }
}
