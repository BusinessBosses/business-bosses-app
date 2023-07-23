import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

class PromoteSection extends StatelessWidget {
  const PromoteSection({Key? key, required this.controller}) : super(key: key);
  final CreatePostController controller;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        const SizedBox(
          width: double.infinity,
          height: 1,
          child: ColoredBox(color: backgroundcolorinterface),
        ),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () => {controller.togglePromote()},
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/svgs/rocket.svg'),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Boost Post',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Reach a wider audience and get more views',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                              color: Color(0xFF777777),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'No',
                          style: TextStyle(
                              fontSize: 8, fontWeight: FontWeight.w700),
                        ),
                        Switch(
                          value: controller.shouldPromote.value,
                          onChanged: (bool value) {
                            controller.togglePromote();
                          },
                        ),
                        const Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 8, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: double.infinity,
          height: 1,
          child: ColoredBox(color: backgroundcolorinterface),
        ),
      ],
    );
  }
}
