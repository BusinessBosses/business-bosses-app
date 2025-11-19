import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class DonationPopup extends StatelessWidget {
  /// Boss Up Challenge Pop Up
  const DonationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                // padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Lottie.asset(
                  'assets/anim/donate.json',
                  height: 120,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Crowdfund',
              textAlign: TextAlign.start,
              style: bodyText1.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    'The crowdfund feature is a dedicated space where entrepreneurs can support each other\'s initiatives, or projects. By sharing and receiving digital coins to kickstart and support their business. Users can set donation goals, share their stories, and engage with Backers.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'How it works',
              textAlign: TextAlign.start,
              style: bodyText1.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Select "Enter" and provide details about your business project, fundraising goal, and timeline.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Upload images or videos to personalise your campaign and make it compelling.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• Share your crowdfund, encourage friends, family, and followers to donate and help you reach your goal.',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '• You can only post one donation at a time',
                    style: bodyText2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Support crowdfund projects to get featured and become backer of the week',
              textAlign: TextAlign.center,
              style: bodyText1.copyWith(
                  fontWeight: FontWeight.w700, color: Colors.black),
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
