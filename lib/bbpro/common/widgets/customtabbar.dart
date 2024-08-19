import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final ScrollController? tabController;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: tabs,
      isScrollable: true,
      indicator: BoxDecoration(
        color: proprimaryColor, // Change to the desired color
        borderRadius: BorderRadius.circular(20), // Adjust as needed
      ),
      labelColor: Colors.white,
      unselectedLabelColor: proprimaryColor,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
