import 'package:business_bosses_v2/features/courses/widgets/course_history_item.dart';
import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:flutter/material.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
                itemCount: 5,
                itemBuilder: (BuildContext context, int i) {
                  return const DonationHistoryItem();
                },
              ),
    );
  }
}
