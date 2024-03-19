import 'package:business_bosses_v2/features/courses/widgets/course_history_item.dart';
import 'package:flutter/material.dart';

class Purchases extends StatefulWidget {
  const Purchases({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int i) {
                  return const CourseHistoryItem();
                },
              ),
    );
  }
}
