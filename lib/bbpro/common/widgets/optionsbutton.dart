import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class OptionsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: backgroundColor,
          width: 1,
        ),
      ),
      child: Center(child: Icon(Icons.more_vert)),
    );
  }
}
