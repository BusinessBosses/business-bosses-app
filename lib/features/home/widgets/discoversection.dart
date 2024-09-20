import 'package:business_bosses_v2/features/home/widgets/cointile.dart';
import 'package:business_bosses_v2/features/home/widgets/howtousetile.dart';
import 'package:business_bosses_v2/features/home/widgets/protile.dart';
import 'package:business_bosses_v2/features/home/widgets/relevantpeopletile.dart';
import 'package:flutter/material.dart';

class DiscoverSection extends StatelessWidget {
  const DiscoverSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: const <Widget>[
          // Padding(
          //   padding: EdgeInsets.only(
          //       left: 15.0,
          //       right: 15,
          //       top: 15),
          //   child: SearchSection(),
          // ),
          SizedBox(height: 15),
          HowtouseTile(),
          SizedBox(height: 15),
          ProTile(),
          SizedBox(height: 15),
          RelevantPeopleTile(),
          SizedBox(height: 15),
          CoinTile(),
          // BossOfWeekProfileTile(),
          SizedBox(height: 15),
          SizedBox(height: 10),
          SizedBox(height: 15),
          SizedBox(height: 15),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
