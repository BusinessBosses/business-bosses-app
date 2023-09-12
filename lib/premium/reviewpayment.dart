import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../common/widgets/buttons/my_button.dart';
import '../common/widgets/text_widget.dart';
import '../navigation/routes.dart';
import '../utils/theme/theme.dart';

// ignore: public_member_api_docs
class ReviewPayment extends StatelessWidget {
  // ignore: public_member_api_docs
  const ReviewPayment({super.key});

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
          text: 'Review Payment',
          size: 20,
        ),
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
                            height: 200,
                            decoration: BoxDecoration(
                                color: backgroundcolorinterface,
                                borderRadius: BorderRadius.circular(9.3)),
                            child: Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Selected Plan'),
                                    Spacer(),
                                    Text('Monthly')
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Text('Total to pay:'),
                                    Spacer(),
                                    Text('\$4.99')
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/planpicture.png',
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    Text('55%'),
                                    Spacer(),
                                    Text('Switch Plan')
                                  ],
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 30,
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
                                  text: 'Select a Payment Option',
                                  size: 18,
                                  fontWeight: FontWeight.w700,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
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
                      Get.offAndToNamed(Routes.home);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
