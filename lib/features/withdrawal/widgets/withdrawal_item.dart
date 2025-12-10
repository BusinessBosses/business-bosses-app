// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/features/donations/widgets/donationhistoryitem.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class WithdrawalItem extends StatefulWidget {
  final dynamic item;
  const WithdrawalItem({super.key, this.item});

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalItemState createState() => _WithdrawalItemState();
}

class _WithdrawalItemState extends State<WithdrawalItem> {
  @override
  Widget build(BuildContext context) {
    String dateTimeString = widget.item['date'];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                  Text(
                    widget.item['amount'],
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '(\$${(num.parse(widget.item['amount']) / 100).toStringAsFixed(1)})',
                    style: const TextStyle(color: Colors.black26),
                  ),
                ]),
                Text(formatDateTimeToAgo(dateTimeString)),
              ],
            ),
            Text(
              widget.item['status'],
              style: widget.item['status'] == 'Pending'
                  ? const TextStyle(color: Colors.grey)
                  : const TextStyle(color: Colors.greenAccent),
            ),
          ]),
        ),
        Container(
          color: backgroundcolorinterface,
          height: 1,
        )
      ],
    );
  }
}
