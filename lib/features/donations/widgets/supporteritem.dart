import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../common/widgets/safety_model.dart';
import '../../../../utils/theme/theme.dart';

class SupporterItem extends StatefulWidget {
  final DonationModel donation;
  const SupporterItem({
    Key? key,
    required this.donation,
  }) : super(key: key);

  @override
  _SupporterItemState createState() => _SupporterItemState();
}

class _SupporterItemState extends State<SupporterItem> {
  final DonationsController donationsController = Get.find();
  @override
  void initState() {
    super.initState();
    donationsController.fetchDonationTransactions(widget.donation);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Material(
              color: Colors.grey.withOpacity(0.1),
              child: TabBar(
                indicatorColor: Colors.transparent,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      'Supporters (${widget.donation.transactions?.length.toString()})',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Obx(
                        () => donationsController.tLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : widget.donation.transactions!.isEmpty
                                ? SafetyModel(
                                    isLoading: false,
                                    icon: SvgPicture.asset(
                                      'assets/svgs/supporter.svg',
                                      height: 80.0,
                                      color: hintColor,
                                    ),
                                    title: 'There is no supporter for now',
                                    subTitle: 'Be the first one to support!',
                                  )
                                : ListView.builder(
                                    itemBuilder: (BuildContext context, int i) {
                                      UserModel user =
                                          donationsController.users[i];
                                      final DateTime time = DateTime.parse(
                                          donationsController.times[i]);
                                      final dynamic amount =
                                          donationsController.amounts[i];

                                      String formattedTime =
                                          DateFormat('d\'th\' MMMM y - HH:mm')
                                              .format(time);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 50.0,
                                                        width: 50.0,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      1000),
                                                          child:
                                                              NetworkImageWithPlaceHolder(
                                                            imageUrl:
                                                                user.photoUrl ??
                                                                    '',
                                                            radius: radius,
                                                            placeHolder:
                                                                Icons.person,
                                                            iconSize: 35.0,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            user.name ??
                                                                user.username,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            formattedTime,
                                                            style: const TextStyle(
                                                                color:
                                                                    subtextColor),
                                                          ),
                                                        ],
                                                      ),
                                                    ]),
                                                Text(
                                                  '+$amount',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              color: backgroundColor,
                                              height: 1,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: donationsController.users.length,
                                  ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
