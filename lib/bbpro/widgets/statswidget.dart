import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final double completionRate;

  const StatsWidget({
    Key? key,
    required this.completedTasks,
    required this.totalTasks,
    required this.completionRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$completedTasks/$totalTasks',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Tasks completed',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '${completionRate.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Completion rate',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
