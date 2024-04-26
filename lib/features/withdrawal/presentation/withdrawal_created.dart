import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WithdrawalCreated extends StatefulWidget {
  const WithdrawalCreated({super.key});

  @override
  State<WithdrawalCreated> createState() => _WithdrawalCreatedState();
}

class _WithdrawalCreatedState extends State<WithdrawalCreated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const AllCommunitiesScreen());
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text('Withdrawal Request Made Succesfully'),
      ),
      body: const Center(
        child: SafetyModel(
          isLoading: false,
          icon: Icon(
            Icons.watch_later_outlined,
            size: 50,
          ),
          title: 'Withdrawal Created!',
          subTitle: 'Your Withdrawal is awaiting approval from the admin!',
        ),
      ),
    );
  }
}
