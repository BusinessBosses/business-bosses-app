import 'package:flutter/material.dart';

import '../../../common/widgets/buttons/button.dart';

Future<dynamic> optionsDialog(BuildContext context, Function() ontap) {
  return showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            'You can only post once in 12 weeks. Are you sure you want to proceed?',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: MediaQuery.of(context).size.height / 55),
          ),
          actions: <Widget>[
            but(context, 'Cancel', true, () {
              Navigator.pop(context);
            }),
            but(context, 'Post', false, ontap)
          ],
        );
      });
}
