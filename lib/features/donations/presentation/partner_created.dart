import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PartnerCreated extends StatefulWidget {
  const PartnerCreated({super.key});

  @override
  State<PartnerCreated> createState() => _PartnerCreatedState();
}

class _PartnerCreatedState extends State<PartnerCreated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => HomeScreen());
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text('Deal Submitted'),
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
            title: 'Partner Deal Submitted Succesfully!',
            subTitle:
                'Your Partner Deal application is awaiting approval from the admin!',
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
                      Get.offAll(() => HomeScreen());
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
