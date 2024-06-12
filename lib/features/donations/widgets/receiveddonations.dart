import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:flutter/material.dart';

class ReceivedDonations extends StatefulWidget {
  final List<dynamic> history;
  const ReceivedDonations({super.key, required this.history});

  @override
  // ignore: library_private_types_in_public_api
  _ReceivedDonationsState createState() => _ReceivedDonationsState();
}

class _ReceivedDonationsState extends State<ReceivedDonations> {
  @override
  Widget build(BuildContext context) {
    return widget.history.isEmpty
        ? const SafetyModel(
            isLoading: false,
            title: 'No Received Funds Found',
            icon: Icon(Icons.warning),
          )
        : ListView.builder(
            itemCount: widget.history.length,
            itemBuilder: (BuildContext context, int i) {
              final String prevdate =
                  i == 0 ? '' : formatDate(widget.history[i - 1]['date']);
              return DonationHistoryItem(item: widget.history[i], previousDate: prevdate,);
            },
          );
  }
}
