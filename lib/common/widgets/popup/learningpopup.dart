import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class LearningPopUp extends StatelessWidget {
  /// Boss Up Challenge Pop Up
  const LearningPopUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'LEARNING',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Welcome to Boss Up Learning',
                textAlign: TextAlign.center,
                style: bodyText1.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.red)),
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                      'A collaborative environment that encourages learning and professional development. '
                      'Start a Topic'
                      ' post articles, insights, and resources others can learn from To sell your products and services, list on '
                      'MarketPlace',
                      style: bodyText2),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            SizedBox(
              height: SizeConfig.safeBlockHorizontal * 3,
            ),
          ],
        ),
      ),
    );
  }
}
