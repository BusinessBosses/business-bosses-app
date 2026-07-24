import 'package:flutter/material.dart';

import '../settings/shop_referral_reward_screen.dart';
import 'referral_earnings_screen.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Referrals'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Earnings'),
              Tab(text: 'Rewards'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            ReferralEarningsScreen(),
            ShopReferralRewardScreen(),
          ],
        ),
      ),
    );
  }
}
