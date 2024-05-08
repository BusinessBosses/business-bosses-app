// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/widgets/alltransactions.dart';
import 'package:business_bosses_v2/features/donations/widgets/outgonedonations.dart';
import 'package:business_bosses_v2/features/donations/widgets/receiveddonations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class DonationsHistory extends StatefulWidget {
  const DonationsHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DonationsHistoryState createState() => _DonationsHistoryState();
}

class _DonationsHistoryState extends State<DonationsHistory> {
  final DonationsController donationsController = Get.find();
  int _currentIndex = 0;
  late PageController _pageController;
  double totalAmount = 0; // Total amount variable

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    donationsController.initHistory().then((_) {
      calculateTotalAmount();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
          title: const Text(
            'My Donations History',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Obx(
          () => donationsController.hLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          'Total',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/coin.svg',
                              height: 35,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              totalAmount.toInt().toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '(\$${(totalAmount / 100).toString()})',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: Colors.black38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: CupertinoSlidingSegmentedControl<int>(
                              backgroundColor: Colors.grey[200]!,
                              padding: const EdgeInsets.all(5),
                              children: const {
                                0: Text('All'),
                                1: Text('Received'),
                                2: Text('Outgone'),
                              },
                              onValueChanged: (int? value) {
                                if (value != null) {
                                  setState(() {
                                    _currentIndex = value;
                                    _pageController.animateToPage(
                                      _currentIndex,
                                      duration:
                                          const Duration(milliseconds: 300),
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
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (int index) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          children: [
                            AllTransactions(
                                history: donationsController.myHistory),
                            ReceivedDonations(
                                history: donationsController.myHistoryReceived),
                            OutgoneDonations(
                                history: donationsController.myHistoryOut),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }

  // Calculate total amount function
  void calculateTotalAmount() {
    double total = 0;
    for (var item in donationsController.myHistory) {
      total += double.parse(item['amount'].toString());
    }
    setState(() {
      totalAmount = total;
    });
  }
}
