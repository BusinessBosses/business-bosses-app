import 'package:business_bosses_v2/bbpro/widgets/gotoshopwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/infocard.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderscard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../widgets/salescard.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> titles = <String>[
    'Clients',
    'Expenses',
    'To-do tasks',
    'Shop Visits'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: CircleAvatar(
              radius: 25,
              backgroundColor: prosemibackColor,
              child: SvgPicture.asset(
                'assets/svgs/homeu.svg',
                height: 18,
              )),
        ),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const <Widget>[NotificationButton()],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GotoshopWidget(),
            const OrdersWidget(),
            const SalesWidget(),
            StaggeredGridView.countBuilder(
              physics: const NeverScrollableScrollPhysics(),
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: 15.0,
              mainAxisSpacing: 15.0,
              // controller: _controller,
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (BuildContext context, int index) {
                return InfoCard(
                  cardName: titles[index],
                  value: '\$20k',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
