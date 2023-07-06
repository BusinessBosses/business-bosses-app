import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class OpportunitiesPopup extends StatelessWidget {
  /// Boss Up Challenge Pop Up
  const OpportunitiesPopup({Key? key}) : super(key: key);

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
              'OPPORTUNITIES',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            Text('Welcome to Boss Up Opportunities',
                textAlign: TextAlign.center,
                style: bodyText1.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.red)),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                      'a collaborative environment that encourages sharing and discovering opportunities for professional and business growth. '
                      'Share Opportunity'
                      ' post Distribution, Co-Founders, Affiliate Marketing, Franchises & Licensing, Investment & Grant opportunities others can gain from. To sell your products and services, list on '
                      'MarketPlace'
                      '',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
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
