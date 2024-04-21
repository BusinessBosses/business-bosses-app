import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:flutter/material.dart';

class AllTransactions extends StatefulWidget {
  final List<dynamic> history;
  const AllTransactions({super.key, required this.history});

  @override
  // ignore: library_private_types_in_public_api
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  @override
  Widget build(BuildContext context) {
    return widget.history.isEmpty
        ? const SafetyModel(
            isLoading: false,
            title: 'No Donations Found',
            icon: Icon(Icons.warning),
          )
        : ListView.builder(
            itemCount: widget.history.length,
            itemBuilder: (BuildContext context, int i) {
              final history = widget.history[i];
              return DonationHistoryItem(
                item: history,
              );
            },
          );
  }
}
