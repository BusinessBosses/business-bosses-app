import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CoinTile extends StatelessWidget {
  const CoinTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Stack(children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Earn Coins',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
            SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.orange.withOpacity(0.2)
                  // image: const DecorationImage(
                  //   image: AssetImage(
                  //       'assets/images/bossoftheweekback.png'), // Replace with your image path
                  //   fit: BoxFit
                  //       .cover, // Adjust the image to cover the entire container
                  // ),
                  ),
              child: Align(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                    ),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Earn now',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Wrap(children: [
                            Container(
                              width: 220,
                              child: Text(
                                'Discover many ways to earn real cash just by using the Business Bosses app.',
                                style:
                                    TextStyle(color: textColor, fontSize: 13),
                              ),
                            ),
                          ]),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.promotionscreen);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(100)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'Earn',
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 13),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.arrow_right_alt,
                                          color: Colors.orange,
                                        )
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
        Positioned(
            right: 10,
            bottom: -40,
            child: SvgPicture.asset('assets/svgs/coin.svg', height: 150,))
      ]),
    );
  }
}
