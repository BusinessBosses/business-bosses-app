import 'package:business_bosses_v2/bbpro/common/widgets/infocard.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/orderscard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          OrdersWidget(),
          Expanded(
            child: StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
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
                  cardName: 'Expenses',
                  value: '\$20k',
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
