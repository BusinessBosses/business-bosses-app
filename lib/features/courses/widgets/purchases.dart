import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/courses/widgets/course_history_item.dart';
import 'package:flutter/material.dart';

class Purchases extends StatefulWidget {
  final List<dynamic> history;
  const Purchases({super.key, required this.history});

  @override
  // ignore: library_private_types_in_public_api
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.history.isEmpty
          ? const SafetyModel(
              isLoading: false,
              title: 'No Course Purchases Found',
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
