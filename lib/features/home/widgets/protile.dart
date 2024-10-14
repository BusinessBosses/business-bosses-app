import 'package:business_bosses_v2/features/premium/proscreen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProTile extends StatelessWidget {
  const ProTile({super.key});

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
                'Upgrade to Pro',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: proprimaryColor,
              // image: const DecorationImage(
              //   image: AssetImage(
              //       'assets/images/probackgroundpic.png'), // Replace with your image path
              //   fit: BoxFit
              //       .cover, // Adjust the image to cover the entire container
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
                          'Upgrade now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Wrap(children: <Widget>[
                          Text(
                            '\$9.99',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'per month',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Get.to(() => const ProScreen());
                              },
                              child: Container(
                                constraints:
                                    const BoxConstraints(minHeight: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.white),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Upgrade',
                                      style: TextStyle(
                                          color: proprimaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_right_alt,
                                      size: 20,
                                      color: proprimaryColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   width: 8,
                            // ),
                            // GestureDetector(
                            //   onTap: () {
                            //     Get.to(ProScreen());
                            //   },
                            //   child: Container(
                            //     constraints: BoxConstraints(
                            //         minHeight:
                            //             40), // Ensure the same height as the first button
                            //     decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(100),
                            //       border: Border.all(color: Colors.white),
                            //     ),
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 15), // Removed vertical padding
                            //     child: const Center(
                            //       child: Text(
                            //         'View Pro Features',
                            //         style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 13,
                            //             fontWeight: FontWeight.w700),
                            //       ),
                            //     ),
                            //   ),
                            // ),
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
    );
  }
}
