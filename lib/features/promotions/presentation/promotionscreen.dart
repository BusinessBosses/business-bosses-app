import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/promotions/widgets/buycoinslist_item.dart';
import 'package:business_bosses_v2/features/withdrawal/depositscreen.dart';
import 'package:business_bosses_v2/features/withdrawal/withdrawalscreen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../../../action/action.dart';
import '../../../navigation/routes.dart';

class PromotionScreen extends StatefulWidget {
  static const String routeName = '/promotion-screen';

  const PromotionScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PromotionScreenState createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  late String _referralId;
  final ProfileController _profileController = Get.find();
  List<String> coinAmounts = ['100', '200', '500', '1000', '10000'];
  List<String> coinPrices = ['0.99', '1.99', '4.99', '9.99', '99.99'];
  List<String> coinIDs = [
    '100_bb_coins',
    '200_bb_coins',
    '500_bb_coins',
    '1000_bb_coins',
    '10000_bb_coins'
  ];
  final ScrollController scrollController = ScrollController();
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _referralId = _profileController.myProfile.inviteId!;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.find();
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: SvgPicture.asset(
                  'assets/svgs/info.svg',
                  height: 22,
                ),
              )
            ],
            centerTitle: true,
            title: Container(
                decoration: BoxDecoration(
                    color: backgroundcolorinterface,
                    borderRadius: BorderRadius.circular(50)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        'My Coin Balance',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      SvgPicture.asset('assets/svgs/coin.svg'),
                      const SizedBox(
                        width: 3,
                      ),
                      Text(
                        '${_profileController.myProfile.coinscount ?? 0}',
                        style: const TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]))),
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CupertinoSlidingSegmentedControl<int>(
                    backgroundColor: Colors.grey[200]!,
                    padding: const EdgeInsets.all(5),
                    children: {
                      0: Text('Earn',
                          style: _currentIndex == 0
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                      1: Text('Withdraw',
                          style: _currentIndex == 1
                              ? const TextStyle(fontWeight: FontWeight.bold)
                              : const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                    },
                    onValueChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _currentIndex = value;
                          _pageController.animateToPage(
                            _currentIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        });
                      }
                    },
                    groupValue: _currentIndex,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                _currentIndex == 0 ? 'Earn Coins' : 'Withdraw Coins',
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
              ),
            ),
            Expanded(
              child: Container(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: const [
                    DepositsScreen(),
                    WithdrawalScreen(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  // @override
  // Widget build(BuildContext context) {
  //   ProfileController profileController = Get.find();
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //         leading: IconButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
  //         ),
  //         centerTitle: true,
  //         title: Container(
  //             decoration: BoxDecoration(
  //                 color: backgroundcolorinterface,
  //                 borderRadius: BorderRadius.circular(50)),
  //             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //             child: Wrap(
  //                 crossAxisAlignment: WrapCrossAlignment.center,
  //                 children: [
  //                   const Text(
  //                     'My Coin Balance',
  //                     style:
  //                         TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
  //                   ),
  //                   const SizedBox(
  //                     width: 5,
  //                   ),
  //                   SvgPicture.asset('assets/svgs/coin.svg'),
  //                   const SizedBox(
  //                     width: 3,
  //                   ),
  //                   Text(
  //                     '${_profileController.myProfile.coinscount ?? 0}',
  //                     style: const TextStyle(
  //                       color: textColor,
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ]))),
  //     body: SingleChildScrollView(
  //       padding: const EdgeInsets.all(0.0),
  //       child: Column(
  //         children: <Widget>[
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           const Padding(
  //             padding: EdgeInsets.only(left: 30, right: 30),
  //             child: Text(
  //               'Give Coins to your favorite Bosses and receive them from other Bosses who love your work!',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                   fontSize: 15,
  //                   color: textColor,
  //                   fontWeight: FontWeight.w700),
  //             ),
  //           ),
  //           Container(
  //               width: MediaQuery.of(context).size.width,
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 120, vertical: 30),
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //               ),
  //               child: Column(
  //                 children: <Widget>[
  //                   Image.asset('assets/images/invitepicture.png')
  //                 ],
  //               )),
  //           GestureDetector(
  //             onTap: () {
  //               Get.toNamed(Routes.premiumscreen);
  //             },
  //             child: Column(
  //               children: <Widget>[
  //                 Container(
  //                     decoration: BoxDecoration(
  //                       boxShadow: <BoxShadow>[
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(0.09),
  //                           blurRadius: 500.0,
  //                           spreadRadius: 0.0,
  //                         ),
  //                       ],
  //                     ),
  //                     child: !profileController.myProfile.isSubscribed
  //                         ? Container(
  //                             decoration: BoxDecoration(
  //                               color: backgroundColor,
  //                               borderRadius: BorderRadius.circular(100.0),
  //                             ),
  //                             child: IntrinsicWidth(
  //                               child: Padding(
  //                                 padding: const EdgeInsets.symmetric(
  //                                     vertical: 8, horizontal: 15),
  //                                 child: Row(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: <Widget>[
  //                                     const Text(
  //                                       'Subscribe to Premium',
  //                                       style: TextStyle(
  //                                         fontWeight: FontWeight.w700,
  //                                         fontSize: 15,
  //                                         color: textColor,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(
  //                                       width: 15,
  //                                     ),
  //                                     SvgPicture.asset(
  //                                       'assets/svgs/nextbutton.svg',
  //                                       color: primaryColorLT,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                           )
  //                         : Container()),
  //                 const SizedBox(
  //                   height: 20,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 15),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   flex: 3,
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       showModalBottomSheet(
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(20)),
  //                           backgroundColor: Colors.white,
  //                           context: context,
  //                           builder: (BuildContext context) {
  //                             return Column(
  //                               mainAxisAlignment: MainAxisAlignment.start,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       vertical: 40.0, horizontal: 20),
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       const Text(
  //                                         'Buy more BB Coins',
  //                                         style: TextStyle(
  //                                             fontWeight: FontWeight.bold,
  //                                             fontSize: 18),
  //                                       ),
  //                                       Text('Promotional Text')
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   child: Expanded(
  //                                     child: Column(
  //                                       children: [
  //                                         Padding(
  //                                           padding: const EdgeInsets.symmetric(
  //                                               horizontal: 10.0),
  //                                           child: Container(
  //                                             color: backgroundcolorinterface,
  //                                             height: 1,
  //                                           ),
  //                                         ),
  //                                         Container(
  //                                           child: Expanded(
  //                                             child: ListView.builder(
  //                                               itemCount: coinAmounts.length,
  //                                               itemBuilder:
  //                                                   (BuildContext context,
  //                                                       int index) {
  //                                                 return GestureDetector(
  //                                                   onTap: () async {
  //                                                     try {
  //                                                       await Purchases
  //                                                           .purchaseProduct(
  //                                                               coinIDs[index]);
  //                                                       print('coin increase');

  //                                                       /// update coin here
  //                                                     } catch (e) {
  //                                                       showSnackbar(
  //                                                         title: 'OOPS!',
  //                                                         message:
  //                                                             'An error occurred while making payment, please try again!',
  //                                                         error: true,
  //                                                       );
  //                                                     }
  //                                                   },
  //                                                   child: BuyCoinsListItem(
  //                                                     coinamount:
  //                                                         coinAmounts[index],
  //                                                     coinprice:
  //                                                         coinPrices[index],
  //                                                   ),
  //                                                 );
  //                                               },
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             );
  //                           });
  //                     },
  //                     child: Container(
  //                       height: 120,
  //                       decoration: BoxDecoration(
  //                           color: const Color.fromRGBO(122, 122, 121, 10),
  //                           borderRadius: BorderRadius.circular(15)),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           const Text(
  //                             'Add BB Coins',
  //                             style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.w700,
  //                                 fontSize: 16),
  //                           ),
  //                           const SizedBox(
  //                             width: 5,
  //                           ),
  //                           SvgPicture.asset('assets/svgs/startatopic.svg')
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   width: 10,
  //                 ),
  //                 Expanded(
  //                   flex: 2,
  //                   child: GestureDetector(
  //                     onTap: () {
  //                       Get.toNamed(Routes.CoinHistoryScreen);
  //                     },
  //                     child: Container(
  //                       height: 120,
  //                       decoration: BoxDecoration(
  //                           border: Border.all(
  //                               color: const Color.fromRGBO(122, 122, 121, 200),
  //                               width: 2),
  //                           borderRadius: BorderRadius.circular(15)),
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Column(
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               const Text(
  //                                 'Withdraw',
  //                                 style: TextStyle(
  //                                     color: textColor,
  //                                     fontWeight: FontWeight.w700),
  //                               ),
  //                               Text(
  //                                 '${_profileController.myProfile.coinscount} Coins = \$2.32',
  //                                 style: TextStyle(
  //                                     color: textColor.withAlpha(80),
  //                                     fontWeight: FontWeight.w400,
  //                                     fontSize: 12),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 15.0),
  //             child: Container(
  //               decoration: BoxDecoration(
  //                   border: Border.all(
  //                       color: const Color.fromRGBO(122, 122, 121, 200),
  //                       width: 2),
  //                   borderRadius: BorderRadius.circular(15)),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: const EdgeInsets.all(15.0),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text(
  //                           'Earn Coins!',
  //                           style: TextStyle(
  //                               fontWeight: FontWeight.w700, fontSize: 18),
  //                         ),
  //                         Row(
  //                           children: [
  //                             const Text(
  //                               'Invite friends to join Business Bosses and get 20',
  //                               style: TextStyle(
  //                                 fontSize: 13,
  //                                 color: textColor,
  //                                 fontWeight: FontWeight.w700,
  //                               ),
  //                             ),
  //                             const SizedBox(width: 5),
  //                             SvgPicture.asset(
  //                               'assets/svgs/coin.svg',
  //                               height: 20,
  //                               width: 20,
  //                             ),
  //                           ],
  //                         ),
  //                         InkWell(
  //                           onTap: () {
  //                             Clipboard.setData(
  //                                     ClipboardData(text: _referralId))
  //                                 .then((value) {
  //                               showSnackBar(context,
  //                                   message:
  //                                       'Your reference id is copied to clipboard.');
  //                             });
  //                           },
  //                           child: Ink(
  //                             padding:
  //                                 const EdgeInsets.symmetric(vertical: 15.0),
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: <Widget>[
  //                                 Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: <Widget>[
  //                                     Text(
  //                                       'Invite Id:',
  //                                       textAlign: TextAlign.center,
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .bodyLarge
  //                                           ?.copyWith(
  //                                             fontWeight: FontWeight.normal,
  //                                             fontSize: 12,
  //                                           ),
  //                                     ),
  //                                     Text(
  //                                       '$_referralId ',
  //                                       textAlign: TextAlign.center,
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .bodyLarge
  //                                           ?.copyWith(
  //                                               fontWeight: FontWeight.normal,
  //                                               fontSize: 12),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 const SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 // ignore: unnecessary_null_comparison
  //                                 _referralId == null
  //                                     ? const Icon(
  //                                         Icons.content_copy,
  //                                         size: 20.0,
  //                                         color: Colors.white,
  //                                       )
  //                                     : const Icon(
  //                                         Icons.content_copy,
  //                                         size: 20.0,
  //                                       ),
  //                                 const SizedBox(
  //                                   width: 20,
  //                                 ),
  //                                 const SizedBox(width: 8.0),
  //                                 ElevatedButton(
  //                                   style: ElevatedButton.styleFrom(
  //                                       backgroundColor:
  //                                           backgroundcolorinterface,
  //                                       minimumSize: const Size(120,
  //                                           45) // put the width and height you want
  //                                       ),
  //                                   onPressed: () {
  //                                     _shareWithFriends();
  //                                   },
  //                                   child: Row(
  //                                     mainAxisSize: MainAxisSize.min,
  //                                     children: <Widget>[
  //                                       // ignore: unnecessary_null_comparison
  //                                       _referralId == null
  //                                           ? const Text(
  //                                               'Create InviteId',
  //                                               style: TextStyle(
  //                                                   color: Colors.white,
  //                                                   fontWeight: FontWeight.w600,
  //                                                   fontSize: 15),
  //                                             )
  //                                           : const Text(
  //                                               'Invite',
  //                                               style: TextStyle(
  //                                                   fontSize: 15,
  //                                                   color: textColor,
  //                                                   fontWeight:
  //                                                       FontWeight.w500),
  //                                             ),
  //                                       const SizedBox(
  //                                         width: 5,
  //                                       ),
  //                                       SvgPicture.asset(
  //                                         'assets/svgs/invite.svg',
  //                                         color: textColor,
  //                                       )
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         GestureDetector(
  //                           onTap: () {},
  //                           child: Container(
  //                             padding:
  //                                 const EdgeInsets.symmetric(vertical: 10.0),
  //                             decoration: const BoxDecoration(
  //                               color: Colors.white,
  //                             ),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: <Widget>[
  //                                 Text(
  //                                   'Accepted Invitation:',
  //                                   textAlign: TextAlign.center,
  //                                   style: Theme.of(context)
  //                                       .textTheme
  //                                       .bodyLarge
  //                                       ?.copyWith(
  //                                         fontWeight: FontWeight.normal,
  //                                         fontSize: 15,
  //                                       ),
  //                                 ),
  //                                 Text(
  //                                   '${_profileController.myProfile.invitations ?? 0}',
  //                                   textAlign: TextAlign.center,
  //                                   style: Theme.of(context)
  //                                       .textTheme
  //                                       .bodyLarge
  //                                       ?.copyWith(
  //                                         fontWeight: FontWeight.normal,
  //                                       ),
  //                                 ),
  //                                 Text(
  //                                   ' (+220 Coins)',
  //                                   textAlign: TextAlign.center,
  //                                   style: Theme.of(context)
  //                                       .textTheme
  //                                       .bodyLarge
  //                                       ?.copyWith(
  //                                         fontWeight: FontWeight.normal,
  //                                       ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _shareWithFriends() {
  //   // ignore: unnecessary_null_comparison
  //   if (_referralId == null) return;
  //   String message = 'Check out Business Bosses.\n'
  //       'An app to meet entrepreneurs and grow your business. Join now for FREE promotion\n'
  //       'https://businessbosses.onelink.me/xLWk/36a2ff16\n'
  //       'Invite id: $_referralId';
  //   logEvent(_profileController.myProfile.inviteId, 'invite');
  //   socialShare(message);
  // }
}
