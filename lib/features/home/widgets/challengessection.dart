import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChallengesSection extends StatelessWidget {
  const ChallengesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.allCommunitiesScreen);
      },
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Challenges',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  Wrap(
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
                ],
              ),
            ),
            SizedBox(height: 10,),
             Container(
                height: 180,
                child: BossupChallenge(
                  ishome: true,
                ))
          ],
        ),
      ),
    );
  }
}
