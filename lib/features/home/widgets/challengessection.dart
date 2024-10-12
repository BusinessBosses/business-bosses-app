import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChallengesSection extends StatefulWidget {
  final Color? backgroundColor;
  final Function? onTap;
  const ChallengesSection({super.key, this.backgroundColor, this.onTap});

  @override
  State<ChallengesSection> createState() => _ChallengesSectionState();
}

class _ChallengesSectionState extends State<ChallengesSection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(BossupChallenge(
          backgroundColor: widget.backgroundColor ?? Colors.white,
          ishome: false,
        ));
      },
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Challenges',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (widget.onTap != null) {
                        widget.onTap!();
                      }
                    },
                    child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: <Widget>[
                          const Text(
                            'View all',
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(width: 5.0),
                          SvgPicture.asset(
                            'assets/svgs/nexticon.svg',
                            // ignore: deprecated_member_use
                            color: textColor,
                            height: 8,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                height: 200,
                child: BossupChallenge(
                  backgroundColor: widget.backgroundColor ?? Colors.white,
                  ishome: true,
                ))
          ],
        ),
      ),
    );
  }
}
