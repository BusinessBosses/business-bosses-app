// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PromoteSection extends StatelessWidget {
  const PromoteSection({Key? key, required this.controller}) : super(key: key);
  final CreatePostController controller;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        SizedBox(
          height: 55,
          child: Align(
            alignment: Alignment.center,
            child: SwitchListTile(
              value: controller.shouldPromote.value,
              onChanged: (bool value) {
                controller.togglePromote();
              },
              title: Row(
                children: <Widget>[
                  SvgPicture.asset('assets/svgs/rocket.svg'),
                  const SizedBox(
                    width: 30,
                  ),
                  const Text(
                    'Boost Post',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (controller.shouldPromote.value)
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/boost_banner.png',
                    width: size.width,
                    height: size.width / 2,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TextWidget(
                        text: 'Reach\na Wider Audience',
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w800,
                        size: 20,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: const <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'More likes on posts',
                            color: Colors.white,
                          ),
                        ],
                      ),
                      Row(
                        children: const <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'More connections',
                            color: Colors.white,
                          )
                        ],
                      ),
                      Row(
                        children: const <Widget>[
                          Icon(
                            Icons.check_box,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'More referrals',
                            color: Colors.white,
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
      ],
    );
  }
}
