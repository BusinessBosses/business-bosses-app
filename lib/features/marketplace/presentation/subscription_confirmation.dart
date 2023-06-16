import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/buttons/my_button.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';

class SubscriptionConfirmation extends StatelessWidget {
  const SubscriptionConfirmation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFFFFF),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const TextWidget(
              text: 'Payment Confirmation', color: Color(0xFF333333), size: 20),
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 32.5,
                  top: 40,
                ),
                child: SvgPicture.asset(
                  'assets/svgs/dottedline.svg',
                  height: 370,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFF01C29),
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            alignment: Alignment.center,
                            width: 223,
                            height: 131,
                            decoration: BoxDecoration(
                                color: backgroundcolorinterface,
                                borderRadius: BorderRadius.circular(9.3)),
                            child: const TextWidget(
                              text:
                                  'Congratulations on choosing to upgrade to premium! It\'s always great to reach with a wider audience. 🎉',
                              size: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              centralize: true,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      child: TextWidget(
                        text: 'Well Done!',
                        fontWeight: FontWeight.w800,
                        size: 20,
                        color: Color(0xff333333),
                        centralize: true,
                      ),
                    ),
                    const SizedBox(
                      height: 91,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0xFFF01C29),
                          child: CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  TextWidget(
                                    text: 'Payment pending approval',
                                    size: 18,
                                    fontWeight: FontWeight.w700,
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextWidget(
                                text:
                                    'Your subscription has been sent for review. Most subscription are reviewed in 24 hours, although in some cases it will take longer.',
                                size: 13,
                                fontWeight: FontWeight.w400,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 150,
                    ),
                    MyButton(
                      labelStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      label: 'Ok',
                      onPressed: () {
                        Get.to(() => const BottomNavScreen(3, true));
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
