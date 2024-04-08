import 'package:business_bosses_v2/features/courses/widgets/course_history_item.dart';
import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int i) {
                  return const CourseHistoryItem();
                },
              ),
    );
  }
}
