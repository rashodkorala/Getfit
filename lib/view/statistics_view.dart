// Assuming this file is saved as statistics_view.dart in the views directory
import 'package:flutter/material.dart';
import 'package:getfit/controller/statistics_controller.dart';
import 'package:getfit/model/user_statistics.dart';
import 'package:getfit/model/workout_completed.dart';

class StatisticsView extends StatefulWidget {
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  final StatisticsController _controller = StatisticsController();
  UserStatistics? _userStatistics;
  List<WorkoutCompleted>? _workouts;
  bool _isLoading = true;

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
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Statistics'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_userStatistics != null) ...[
                    const Text('Latest Measurements:\n'),
                    Text('Chest: ${_userStatistics!.chest} inches'),
                    Text('Waist: ${_userStatistics!.waist} inches'),
                    Text('Hips: ${_userStatistics!.hips} inches'),
                    Text('Arm: ${_userStatistics!.arm} inches'),
                    Text('Thigh: ${_userStatistics!.thigh} inches'),
                    Text('Calf: ${_userStatistics!.calf} inches'),
                  ],
                  if (_workouts != null && _workouts!.isNotEmpty) ...[
                    const Text('Latest Workout:\n'),
                    for (var workout in _workouts!) ...[
                      Text('Name: ${workout.name}'),
                      Text('Weight: ${workout.weight} lbs'),
                      Text('Reps: ${workout.reps}'),
                    ],
                  ],
                ],
              ),
            ),
    );
  }
}
