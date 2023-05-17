import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';

class PromotionScreen extends StatefulWidget {
  static const routeName = '/promotion-screen';

  const PromotionScreen({Key? key}) : super(key: key);

  @override
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  late String _referralId;
  final ProfileController _profileController = Get.find();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _referralId = _profileController.myProfile.inviteId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                decoration: BoxDecoration(
                  color: backgroundcolorinterface,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'My Coin Balance',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    SvgPicture.asset(
                      'assets/svgs/coin.svg',
                      height: 30,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    const Text(
                      '200',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              width: 30,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Give Coins to your favorite Bosses and receive them from other Bosses who love your work!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15,
                    color: textColor,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 50),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [Image.asset('assets/images/invitepicture.png')],
                )),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Text(
                      'Earn Coins!',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    const Text(
                      'Invite Friends',
                      style: TextStyle(
                          fontSize: 25,
                          color: primaryColorLT,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            'to join Business Bosses and get 20',
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 5),
                          SvgPicture.asset(
                            'assets/svgs/coin.svg',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            'for each friend.',
                            style: TextStyle(
                              fontSize: 15,
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                )),
            const SizedBox(
              width: double.infinity,
              height: 1.5,
              child: ColoredBox(color: backgroundcolorinterface),
            ),
            InkWell(
              onTap: () {
                if (_referralId != null) {
                  Clipboard.setData(ClipboardData(text: _referralId))
                      .then((value) {
                    showSnackBar(context,
                        message: 'Your reference id is copied to clipboard.');
                  });
                }
              },
              child: Ink(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Invite Id:',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                  ),
                        ),
                        Text(
                          '$_referralId ',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    _referralId == null
                        ? const Icon(
                            Icons.content_copy,
                            size: 20.0,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.content_copy,
                            size: 20.0,
                          ),
                    const SizedBox(
                      width: 20,
                    ),
                    const SizedBox(width: 8.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(
                              150, 45) // put the width and height you want
                          ),
                      onPressed: () {
                        _shareWithFriends();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _referralId == null
                              ? const Text(
                                  'Create InviteId',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15),
                                )
                              : const Text(
                                  'Invite',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                          const SizedBox(
                            width: 5,
                          ),
                          SvgPicture.asset('assets/svgs/invite.svg')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1.5,
              child: ColoredBox(color: backgroundcolorinterface),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 23.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Accepted Invitation:',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                    ),
                    Text(
                      '200',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: double.infinity,
              height: 1.5,
              child: ColoredBox(color: backgroundcolorinterface),
            ),
            const SizedBox(height: 74.0),
          ],
        ),
      ),
    );
  }

  void _shareWithFriends() {
    if (_referralId == null) return;
    String message = 'Check out Business Bosses.\n'
        'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
        'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
        'Invite id: $_referralId';

    socialShare(message);
  }
}
