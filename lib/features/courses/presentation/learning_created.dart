import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LearningCreated extends StatefulWidget {
  const LearningCreated({super.key});

  @override
  State<LearningCreated> createState() => _LearningCreatedState();
}

class _LearningCreatedState extends State<LearningCreated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => const MarketplaceScreen());
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text('Course Submitted'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 100,
            child: SvgPicture.asset('assets/svgs/waiting.svg'),
          ),
          const SafetyModel(
            isLoading: false,
            title: 'Course Submitted Successfully!',
            subTitle:
                'Your Course/Learning post is awaiting approval from the admin!',
          ),
          Container(
            decoration: BoxDecoration(
              color: backgroundcolorinterface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => const MarketplaceScreen());
                    },
                    child: const Text(
                      'Go Back',
                      style: TextStyle(
                        color: primaryColorLT,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset('assets/svgs/nexticon.svg'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
