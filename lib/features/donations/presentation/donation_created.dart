import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DonationCreated extends StatefulWidget {
  const DonationCreated({super.key});

  @override
  State<DonationCreated> createState() => _DonationCreatedState();
}

class _DonationCreatedState extends State<DonationCreated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: const Center(
        child: SafetyModel(
          isLoading: false,
          icon: Icon(
            Icons.watch_later_outlined,
            size: 50,
          ),
          title: 'Donation Created!',
          subTitle: 'Your donation is awaiting approval from the admin!',
        ),
      ),
    );
  }
}
