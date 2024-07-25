// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class WithdrawalHeaderItem extends StatefulWidget {
  const WithdrawalHeaderItem({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WithdrawalHeaderItemState createState() => _WithdrawalHeaderItemState();
}

class _WithdrawalHeaderItemState extends State<WithdrawalHeaderItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundcolorinterface,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical:15.0, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Text('Details', style: TextStyle(fontWeight: FontWeight.bold),),
          Text('Status', style: TextStyle(fontWeight: FontWeight.bold),)
        ]),
      ),
      
    );
  }
}
