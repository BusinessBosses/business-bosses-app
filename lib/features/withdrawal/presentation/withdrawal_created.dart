import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/profile/presentation/myprofilescreen.dart';
import 'package:business_bosses_v2/features/promotions/presentation/promotionscreen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WithdrawalCreated extends StatefulWidget {
  const WithdrawalCreated({super.key});

  @override
  State<WithdrawalCreated> createState() => _WithdrawalCreatedState();
}

class _WithdrawalCreatedState extends State<WithdrawalCreated> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Get.to(() => const PromotionScreen());
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text('Request Sent'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(children: [
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
            title: 'Withdrawal Created!',
            subTitle: 'Your Withdrawal is awaiting approval from the admin!',
          ),
        ],
      ),
    );
  }
}
