import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/courses/widgets/course_history_item.dart';
import 'package:flutter/material.dart';

class Leads extends StatefulWidget {
  final List<dynamic> history;
  const Leads({super.key, required this.history});

  @override
  // ignore: library_private_types_in_public_api
  _LeadsState createState() => _LeadsState();
}

class _LeadsState extends State<Leads> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.history.isEmpty
          ? const SafetyModel(
              isLoading: false,
              title: 'No Course Leads Found',
              icon: Icon(Icons.warning),
            )
          : ListView.builder(
              itemCount: widget.history.length,
              itemBuilder: (BuildContext context, int i) {
                final dynamic currentHistory = widget.history[i];
                return CourseHistoryItem(
                  history: currentHistory,
                );
              },
            ),
    );
  }
}
