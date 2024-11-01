import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CoinTile extends StatelessWidget {
  const CoinTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        children: <Widget>[
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Earn Coins',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Stack(children: <Widget>[
            Column(
              children: <Widget>[
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
                              const Text(
                                'Earn now',
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(children: <Widget>[
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: const Text(
                                    'Discover ways to earn real cash',
                                    style: TextStyle(
                                        color: textColor, fontSize: 13),
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.promotionscreen);
                                    },
                                    child: Container(
                                      constraints:
                                          const BoxConstraints(minHeight: 40),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 8),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // Row will only take up the space it needs
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Earn',
                                            style: TextStyle(
                                                color: Colors.orange,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_right_alt,
                                            color: Colors.orange,
                                            size: 20,
                                          )
                                        ],
                                      ),
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
            // Positioned(
            //     right: 10,
            //     top: -20,
            //     child: SvgPicture.asset(
            //       'assets/svgs/coin.svg',
            //       height: 60,
            //     ))
          ]),
        ],
      ),
    );
  }
}
