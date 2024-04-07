// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/presentation/purchases.dart';
import 'package:business_bosses_v2/features/courses/presentation/sales.dart';
import 'package:business_bosses_v2/features/donations/widgets/alltransactions.dart';
import 'package:business_bosses_v2/features/donations/widgets/outgonedonations.dart';
import 'package:business_bosses_v2/features/donations/widgets/receiveddonations.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/time_format.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
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
          'Donations History',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: const Text(
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
                  SizedBox(width: 5),
                  Text(
                    '4000',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    '(\$2000)',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
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
                      0: Text('All'),
                      1: Text('Incoming'),
                      2: Text('Outgoing'),
                    },
                    onValueChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _currentIndex = value;
                          _pageController.animateToPage(
                            _currentIndex,
                            duration: Duration(milliseconds: 300),
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
                  AllTransactions(),
                  ReceivedDonations(),
                  OutgoneDonations(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
