import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  final int completedTasks;
  final int totalTasks;
  final double completionRate;

  const StatsWidget({
    super.key,
    required this.completedTasks,
    required this.totalTasks,
    required this.completionRate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '$completedTasks/$totalTasks',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Tasks completed',
              style: TextStyle(
                color: Color(0xFF616161),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '${completionRate.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Completion rate',
              style: TextStyle(
                color: Color(0xFF616161),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
