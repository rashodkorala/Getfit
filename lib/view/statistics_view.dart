import 'package:flutter/material.dart';
import 'package:getfit/controller/statistics_controller.dart';
import 'package:getfit/model/user_statistics.dart';
import 'package:getfit/model/workout_completed.dart';
import 'package:getfit/view/body_measuremeant_view.dart';

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
  void navigateToMeasurements(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BodyMeasurementView()));
  }

//display the data in a table
  DataTable buildMeasurementsTable(UserStatistics stats) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Measurement')),
        DataColumn(label: Text('Value (inches)')),
      ],
      rows: [
        DataRow(cells: [
          const DataCell(Text('Chest')),
          DataCell(Text('${stats.chest?.toStringAsFixed(2)}')),
        ]),
        DataRow(cells: [
          const DataCell(Text('Waist')),
          DataCell(Text('${stats.waist?.toStringAsFixed(2)}')),
        ]),
        DataRow(cells: [
          const DataCell(Text('Hips')),
          DataCell(Text('${stats.hips?.toStringAsFixed(2)}')),
        ]),
        DataRow(cells: [
          const DataCell(Text('Arm')),
          DataCell(Text('${stats.arm?.toStringAsFixed(2)}')),
        ]),
        DataRow(cells: [
          const DataCell(Text('Thigh')),
          DataCell(Text('${stats.thigh?.toStringAsFixed(2)}')),
        ]),
        DataRow(cells: [
          const DataCell(Text('Calf')),
          DataCell(Text('${stats.calf?.toStringAsFixed(2)}')),
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Statistics'),
        actions: [
          IconButton(
            onPressed: () {
              navigateToMeasurements(context);
            },
            icon: Icon(Icons.balance),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_userStatistics != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Latest Measurements:',
                          style: TextStyle(fontSize: 18)),
                    ),
                    buildMeasurementsTable(_userStatistics!),
                  ],
                  const SizedBox(height: 20),
                  if (_workouts != null && _workouts!.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Latest Workout:',
                          style: TextStyle(fontSize: 18)),
                    ),
                    for (var workout in _workouts!) ...[
                      Text('Name: ${workout.name}'),
                      Text('Weight: ${workout.weight} lbs'),
                      Text('Reps: ${workout.reps}'),
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
    );
  }
}
