import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class BossUpChallangePopUpcopy extends StatelessWidget {
  /// Boss Up Challenge Pop Up
  const BossUpChallangePopUpcopy({Key? key}) : super(key: key);

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
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            Text(
              'BOSS UP CHALLENGE',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            Text("Become 'Boss of the week' and get free promotion for a week",
                textAlign: TextAlign.center,
                style: bodyText1.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.red)),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('●  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Start a topic in Boss up challenge group, introduce yourself and business',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('●  ', style: bodyText2),
                Expanded(
                  child: Text(
                      "The user with highest post likes in a week, will become the winner of 'Boss of week'",
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('●  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'The winner will be promoted on the App for a week',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('●  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Users can enter the challenge once every 12 weeks',
                      style: bodyText2),
                ),
              ],
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
