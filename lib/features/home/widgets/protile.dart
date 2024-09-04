import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class ProTile extends StatelessWidget {
  const ProTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Subscribe to Pro',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage(
                    'assets/images/probackgroundpic.png'), // Replace with your image path
                fit: BoxFit
                    .cover, // Adjust the image to cover the entire container
              ),
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
                          'Upgrade now',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(children: [
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
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
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
                                        'Upgrade',
                                        style: TextStyle(
                                            color: proprimaryColor,
                                            fontSize: 13),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.arrow_right_alt,
                                        color: proprimaryColor,
                                      )
                                    ]),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.white)),
                              child: Text(
                                'View Pro Features',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
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
