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
          Stack(children: <Widget>[
            Lottie.asset(
              'assets/anim/waiting.json',
              height: 100,
            ),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(200),
                  border: Border.all(width: 10, color: backgroundColor)),
            )
          ]),
          const SafetyModel(
            isLoading: false,
            title: 'Donation Created!',
            subTitle: 'Your Donation is awaiting approval from the admin!',
          ),
        ],
      ),
    );
  }
}
