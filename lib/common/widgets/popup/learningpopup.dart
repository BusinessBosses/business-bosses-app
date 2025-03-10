import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
          children: <Widget>[
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
                    fontWeight: FontWeight.w700, color: textColor)),
            const SizedBox(
              height: 20,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      'A collaborative environment that encourages learning and professional development. '
                      'Share resources,'
                      ' post articles, insights, and resources others can learn from.',
                      style: bodyText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/svgs/report.svg',
                    colorFilter:
                        const ColorFilter.mode(primaryColorLT, BlendMode.srcIn),
                    height: 20,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Expanded(
                    child: Text(
                      'To sell your products and services, list on Marketplace',
                      style: TextStyle(color: primaryColorLT),
                      overflow: TextOverflow
                          .visible, // or TextOverflow.ellipsis if you want an ellipsis when it overflows
                      softWrap:
                          true, // This allows the text to wrap to the next line
                    ),
                  ),
                ],
              ),
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
