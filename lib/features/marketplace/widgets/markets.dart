import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/market_members.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_services.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/products.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/joinedbutton.dart';

class MarketsPage extends StatefulWidget {
  const MarketsPage({super.key});

  @override
  State<MarketsPage> createState() => _MarketsPageState();
}

class _MarketsPageState extends State<MarketsPage> {
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();

  @override
  Widget build(BuildContext context) {
    int userCount = _marketController.users.length;
    String formattedUserCount = formatCount(userCount);
    return Scaffold(
      body: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _marketController.isfiltered.value
              ? _marketController.searchResult.length + 1
              : _marketController.markets.length + 1 + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                width: double.infinity,
                color: backgroundcolorinterface,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 25),
                      child: GestureDetector(
                        onTap: (() {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                sellingGuide(context),
                          );
                        }),
                        child: Row(
                          children: <Widget>[
                            const Text(
                              'Guidelines ',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700),
                            ),
                            SvgPicture.asset(
                              'assets/svgs/info.svg',
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(150,
                                    45) // put the width and height you want
                                ),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25.0),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              // Set a specific height
                                              child: ListView.separated(
                                                itemCount: 2,
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        const Divider(),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      index == 0
                                                          ? Get.toNamed(
                                                              Routes.sellscreen)
                                                          : Get.to(() =>
                                                              const CreateServiceScreen(
                                                                  isUpd:
                                                                      false));
                                                    },
                                                    minVerticalPadding: 0,
                                                    contentPadding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                    ),
                                                    leading: SvgPicture.asset(
                                                      index == 0
                                                          ? 'assets/svgs/sellicon.svg'
                                                          : 'assets/svgs/sellicon.svg',
                                                      height: 25,
                                                      color: textColor
                                                          .withOpacity(1),
                                                    ),
                                                    title: Text(
                                                      index == 0
                                                          ? 'Sell your product'
                                                          : 'Sell your service',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Sell',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                SvgPicture.asset('assets/svgs/startatopic.svg')
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withOpacity(0.09),
                              blurRadius: 100.0, // soften the shadow
                              spreadRadius: 5, //extend the shadow
                            )
                          ],
                        ),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10, top: 10, right: 15, left: 15),
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: const ColoredBox(color: Colors.white),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 25, right: 15, left: 30),
                                      height: 86,
                                      width: 142,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: FittedBox(
                                          child: CachedNetworkImage(
                                            memCacheWidth: 256,
                                            imageUrl:
                                                'https://businessbosses.com.ng/learningImages/marketplace.jpg',
                                            placeholder: (BuildContext context,
                                                    String photo) =>
                                                const CircularProgressIndicator(),
                                            errorWidget: (BuildContext context,
                                                    String photo,
                                                    dynamic error) =>
                                                const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 30),
                                        child: Text(
                                          _marketController.marketDescription,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          softWrap: true,
                                          maxLines: 5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 27,
                                    top: 0,
                                    right: 15,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 2, top: 5),
                                            child: SvgPicture.asset(
                                              'assets/svgs/members.svg',
                                              height: 15,
                                              color: primaryColorLT,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.to(() => MarketMembersScreen(
                                                    users:
                                                        _marketController.users,
                                                  ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child: RichText(
                                                text: TextSpan(
                                                  children: <InlineSpan>[
                                                    TextSpan(
                                                        text:
                                                            'Members ($formattedUserCount)',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: primaryColorLT,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, top: 5, right: 3),
                                            child: SvgPicture.asset(
                                              'assets/svgs/marketplace.svg',
                                              color: textColor,
                                              height: 15,
                                            ),
                                          ),
                                          Obx(
                                            () {
                                              int postCount = _marketController
                                                  .markets.length;
                                              String formattedpostCount =
                                                  formatCount(postCount);
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0),
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: <InlineSpan>[
                                                      TextSpan(
                                                        text:
                                                            'Listings ($formattedpostCount)',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: textColor,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              JoinedButton(),
                                            ],
                                          ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              );
            } else if (index <
                (_marketController.isfiltered.value
                    ? _marketController.searchResult.length
                    : _marketController.markets.length)) {
              final MarketModel market = _marketController.isfiltered.value
                  ? _marketController.searchResult[index - 1]
                  : _marketController.markets[index - 1];
              return VisibilityDetector(
                key: Key(index.toString()),
                onVisibilityChanged: (VisibilityInfo info) {
                  final bool hasIncrementedView = hmeController
                      .itemsWithIncrementedViews
                      .contains(_marketController.markets[index - 1].marketId);
                  if (info.visibleFraction == 1.0 && !hasIncrementedView) {
                    _marketController.updatemarketViews(
                        _marketController.markets[index - 1]);
                    setState(() {
                      hmeController.itemsWithIncrementedViews.add(_marketController
                          .markets[index]
                          .marketId); // Set the flag to prevent further increments
                    });
                  }
                },
                child: _marketController.markets[index - 1].isProduct
                    ? MarketTile(
                        post: market,
                        controller: _marketController,
                        key:
                            ValueKey(_marketController.markets[index].marketId),
                      )
                    : ServiceTile(
                        post: market,
                        controller: _marketController,
                        key: ValueKey(
                            _marketController.markets[index - 1].marketId),
                      ),
              );
            } else {
              // Display a loading indicator at the end of the list
              if (_marketController.loadingMore.value) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        );
      }),
    );
  }
}
