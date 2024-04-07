import 'package:business_bosses_v2/features/courses/widgets/course_history_item.dart';
import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:flutter/material.dart';

class OutgoneDonations extends StatefulWidget {
  const OutgoneDonations({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OutgoneDonationsState createState() => _OutgoneDonationsState();
}

class _OutgoneDonationsState extends State<OutgoneDonations> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int i) {
                  return const DonationHistoryItem();
                },
              ),
    );
  }
}
