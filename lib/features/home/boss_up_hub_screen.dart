import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/home/widgets/bottom_bar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

/// Boss Up bottom-nav tab: the full boss up hub (challenges, events,
/// crowdfund, learning, partner deals). The social feed now lives on the
/// "For you" tab of the home screen.
class BossUpHubScreen extends StatelessWidget {
  const BossUpHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: <Widget>[
          const Padding(
            // Leave room for the floating bottom bar.
            padding: EdgeInsets.only(bottom: 90),
            child: BossupChallenge(ishome: false, isTab: true),
          ),
          BottomBar(activeIndex: 3),
        ],
      ),
    );
  }
}
