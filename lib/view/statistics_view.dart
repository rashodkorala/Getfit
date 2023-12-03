// views/statistics_view.dart

import 'package:flutter/material.dart';
import 'package:getfit/controller/statistics_controller.dart';
import 'package:getfit/model/user_statistics.dart';

class StatisticsView extends StatefulWidget {
  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  UserStatistics? _userStatistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final stats = await StatisticsController().fetchLatestUserStatistics();
    setState(() {
      _userStatistics = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Your Statistics'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Statistics'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_userStatistics != null) ...[
              const Text('Body Measurements:\n '),
              //Text('Date: ${_userStatistics!.timestamp}'),
              Text('Chest: ${_userStatistics!.chest} inches'),
              Text('Waist: ${_userStatistics!.waist} inches'),
              Text('Hips: ${_userStatistics!.hips} inches'),
              Text('Arm: ${_userStatistics!.arm} inches'),
              Text('Thigh: ${_userStatistics!.thigh} inches'),
              Text('Calf: ${_userStatistics!.calf} inches'),
              // Display other measurements as needed
            ] else ...[
              Text('No measurements found.')
            ],
          ],
        ),
      ),
    );
  }
}
