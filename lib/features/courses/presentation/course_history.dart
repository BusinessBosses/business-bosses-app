// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/presentation/alltransactions.dart';
import 'package:business_bosses_v2/features/courses/presentation/expanded_course_screen.dart';
import 'package:business_bosses_v2/features/courses/presentation/purchases.dart';
import 'package:business_bosses_v2/features/courses/presentation/sales.dart';
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


class CourseHistory extends StatefulWidget {
  const CourseHistory({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CourseHistoryState createState() => _CourseHistoryState();
}

class _CourseHistoryState extends State<CourseHistory> {
  late TabController _tabController;
  int _currentIndex = 0;
  String paymentMethodId = '';
  final Map<int, Widget> _segments = <int, Widget>{
    0: const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'All Transactions',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    1: const Padding(
      padding: EdgeInsets.all(8),
      child: Text('Sales', style: TextStyle(fontWeight: FontWeight.bold)),
    ),
    2: const Padding(
      padding: EdgeInsets.all(8),
      child: Text('Purchases', style: TextStyle(fontWeight: FontWeight.bold)),
    )
  };
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
          'Course History',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
        color: backgroundcolorinterface,
        child: Column(
          children: [
            const Text('Total'),
            Row(
              children: [
                SvgPicture.asset('assets/svgs/coin.svg'),
                Text('4000'),
                Text('(\$2000)'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: CupertinoSlidingSegmentedControl<int>(
                  padding: const EdgeInsets.all(5),
                  children: _segments,
                  onValueChanged: (int? value) {
                    setState(() {
                      _currentIndex = value!;
                    });
                  },
                  groupValue: _currentIndex,
                ),
              ),
            ),
            Container(
              height: 400,
              child: DefaultTabController(
                length: 3, // Replace with the number of tabs
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        AllTransactions(),
                        Sales(),
                        Purchases(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
