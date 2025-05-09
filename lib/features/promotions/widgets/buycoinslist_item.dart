// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BuyCoinsListItem extends StatelessWidget {
  final String? coinamount;
  final String? coinprice;

  const BuyCoinsListItem({
    super.key,
    this.coinamount,
    this.coinprice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SvgPicture.asset('assets/svgs/coin.svg'),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  coinamount ?? '100',
                  style: const TextStyle(fontWeight: FontWeight.bold)
                ),
                const SizedBox(width: 5,),
                Text(
                  '(\$${coinprice ?? '4.99'})',
                  style:  TextStyle(fontWeight: FontWeight.w700, color: textColor.withOpacity(0.4)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 1,
              color: backgroundcolorinterface,
            ),
          )
        ],
      ),
    );
  }
}
