import 'package:business_bosses_v2/features/courses/widgets/course_history_item.dart';
import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:flutter/material.dart';

class ReceivedDonations extends StatefulWidget {
  const ReceivedDonations({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReceivedDonationsState createState() => _ReceivedDonationsState();
}

class _ReceivedDonationsState extends State<ReceivedDonations> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int i) {
                  return const DonationHistoryItem();
                },
              ),
    );
  }
}
