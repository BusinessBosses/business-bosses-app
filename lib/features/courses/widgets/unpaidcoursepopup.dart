import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/promotions/widgets/buycoinslist_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../common/dialogs/snackbar.dart';
import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../features/courses/models/course_model.dart';
import '../../../features/profile/controller/profile_controller.dart';
import '../../../utils/size_config.dart';
import '../../../utils/theme/theme.dart';

class UnpaidCoursePopUp extends StatefulWidget {
  final CourseModel course;

  const UnpaidCoursePopUp({super.key, required this.course});

  @override
  State<UnpaidCoursePopUp> createState() => _UnpaidCoursePopUpState();
}

class _UnpaidCoursePopUpState extends State<UnpaidCoursePopUp> {
  List<String> coinAmounts = <String>['100', '200', '500', '1000', '10000'];
  List<String> coinPrices = <String>['0.99', '1.99', '4.99', '9.99', '99.99'];
  List<String> coinIDs = <String>[
    '100_bb_coins',
    '200_bb_coins',
    '500_bb_coins',
    '1000_bb_coins',
    '10000_bb_coins'
  ];
  bool insufficientBalance = false;
  ProfileController profileController = Get.find();
  CourseController courseController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Dialog(
                backgroundColor: backgroundColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                insetPadding: const EdgeInsets.all(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.course.title!,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.course.description!,
                        style: bodyText2,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          NetworkImageWithPlaceHolder(
                            imageUrl: widget.course.user!.photoUrl ?? '',
                            radius: 200,
                            width: 25,
                            height: 25,
                            placeHolder: Icons.person,
                            iconSize: 20.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              widget.course.user!.name!,
                              style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.visible,
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockHorizontal * 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Access Denied',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Text(
                textAlign: TextAlign.center,
                'Sorry this is a paid course and you currently do not have permissions to view the content.',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (num.parse(widget.course.price!) >
                    num.parse(
                        profileController.myProfile.coinscount.toString())) {
                  showSnackbar(
                    title: 'OOPS!',
                    message: 'Insufficient Coin balance, please top up!',
                    error: true,
                  );

                  setState(() {
                    insufficientBalance = true;
                  });
                } else {
                  courseController.payforcourse(
                      widget.course.id, num.parse(widget.course.price!));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    const Text('Buy Course for '),
                    SvgPicture.asset('assets/svgs/coin.svg'),
                    Text('${widget.course.price}'),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 10,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 40.0, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Buy more BB Coins',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text('Promotional Text'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: coinAmounts.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () async {
                                  try {
                                    // Fetch the StoreProduct for the selected product ID
                                    final List<StoreProduct> products =
                                        await Purchases.getProducts(
                                            <String>[coinIDs[index]]);

                                    if (products.isEmpty) {
                                      showSnackbar(
                                        title: 'OOPS!',
                                        message:
                                            'Product not available, please try again later!',
                                        error: true,
                                      );
                                      return;
                                    }

                                    // Purchase the product using the new API
                                    await Purchases.purchase(
                                        PurchaseParams.storeProduct(
                                            products.first));

                                    if (kDebugMode) {
                                      print('coin increase');
                                    }

                                    /// update coin here
                                  } catch (e) {
                                    showSnackbar(
                                      title: 'OOPS!',
                                      message:
                                          'An error occurred while making payment, please try again!',
                                      error: true,
                                    );
                                  }
                                },
                                child: BuyCoinsListItem(
                                  coinamount: coinAmounts[index],
                                  coinprice: coinPrices[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Visibility(
                visible: insufficientBalance,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Top up now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
