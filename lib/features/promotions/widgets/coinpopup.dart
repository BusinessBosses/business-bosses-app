import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class CoinPopup extends StatelessWidget {
  /// Boss Up Challenge Pop Up
  const CoinPopup({Key? key}) : super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            Text(
              'Business Bosses Coins',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('What are Bosses Coins?',
                textAlign: TextAlign.start,
                style: bodyText1.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.red)),
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      'Bosses Coins are Business Bosses in-app currency that you can use to give or receive money from people.',
                      style: bodyText2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
             Text('How do I earn Bosses Coins?',
                textAlign: TextAlign.start,
                style: bodyText1.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.red)),
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      'You can earn Coins by winning challenges, inviting friends, selling your product or services, creating content. You can also buy Coins or become a premium users and get 500 Coins monthly.',
                      style: bodyText2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
             const SizedBox(
              height: 20,
            ),
             Text('How do I spend Bosses Coins?',
                textAlign: TextAlign.start,
                style: bodyText1.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.red)),
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      'You can give Coins to support other people’s work and receive them from people who love your work.',
                      style: bodyText2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),

             const SizedBox(
              height: 20,
            ),
             Text('How do I withdraw my Bosses Coins to cash?',
                textAlign: TextAlign.start,
                style: bodyText1.copyWith(
                    fontWeight: FontWeight.w700, color: Colors.red)),
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      'Use the withdraw button to withdraw your coins to cash. The minimum withdrawal amount is 5,000 Coins (\$50 USD). The payment processor will apply withdrawal fees, and transfers may take up to 7 business days.',
                      style: bodyText2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(
              height: 20,
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
