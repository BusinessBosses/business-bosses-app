import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';

// ignore: public_member_api_docs
class UnReadDot extends StatelessWidget {
  // ignore: public_member_api_docs
  const UnReadDot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.0,
      width: 8.0,
      decoration: BoxDecoration(
        color: primaryColorLT,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
