import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:flutter/material.dart';

class OutgoneDonations extends StatefulWidget {
  final List<dynamic> history;
  const OutgoneDonations({super.key, required this.history});

  @override
  // ignore: library_private_types_in_public_api
  _OutgoneDonationsState createState() => _OutgoneDonationsState();
}

class _OutgoneDonationsState extends State<OutgoneDonations> {
  @override
  Widget build(BuildContext context) {
    return widget.history.isEmpty
        ? const SafetyModel(
            isLoading: false,
            title: 'No Outgone Donations Found',
            icon: Icon(Icons.warning),
          )
        : ListView.builder(
            itemCount: widget.history.length,
            itemBuilder: (BuildContext context, int i) {
              final item = widget.history[i];
              final prevdate =
                  i == 0 ? "" : formatDate(widget.history[i - 1]['date']);
              return DonationHistoryItem(
                item: item, previousDate: prevdate,
              );
            },
          );
  }
}
