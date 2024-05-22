import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DonationCreated extends StatefulWidget {
  const DonationCreated({super.key});

  @override
  State<DonationCreated> createState() => _DonationCreatedState();
}

class _DonationCreatedState extends State<DonationCreated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const AllCommunitiesScreen(
                  initialTabIndex: 2,
                ));
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text('Donation Created Succesfully'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            child: SvgPicture.asset('assets/svgs/waiting.svg'),
          ),
          const SafetyModel(
            isLoading: false,
            title: 'Donation Created!',
            subTitle: 'Your Donation is awaiting approval from the admin!',
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
                      Get.back();
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
