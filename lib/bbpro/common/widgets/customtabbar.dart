import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTabBarWidget<T> extends StatelessWidget {
  final TabController _tabController;
  final Function(int) _scrollToSection;
  final Color proprimaryColor;
  final Color backgroundColor;
  final List<T> listofitems;
  final String Function(T) itemToString; // Function to convert enum to string
  final int Function(T) itemCount; // Function to get item count if needed

  CustomTabBarWidget({
    required TabController tabController,
    required Function(int) scrollToSection,
    required this.proprimaryColor,
    required this.backgroundColor,
    required this.listofitems,
    required this.itemToString, // Function to convert enum to string
    required this.itemCount, // Function to get item count if needed
  })  : _tabController = tabController,
        _scrollToSection = scrollToSection;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: _tabController,
              onTap: _scrollToSection,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              indicatorColor: Colors.white,
              isScrollable: true,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              labelPadding: const EdgeInsets.only(right: 8.0),
              unselectedLabelColor: Colors.grey,
              labelColor: Colors.white,
              tabs: listofitems.asMap().entries.map((entry) {
                int index = entry.key;
                T status = entry.value;
                return Tab(
                  child: Padding(
                    padding: EdgeInsets.only(right: index == 3 ? 40.0 : 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _tabController.index == index
                            ? proprimaryColor
                            : backgroundColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: Text(
                            '${itemToString(status)} (${itemCount(status)})'),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 10,
          child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: [
                    BoxShadow(
                      color: backgroundColor
                          .withOpacity(0.6), // Adjust opacity as needed
                      offset: Offset(-5,
                          0), // Horizontal offset to show shadow on the left side
                      blurRadius: 10, // Adjust blur radius for shadow softness
                      spreadRadius: 2, // Adjust spread radius for shadow size
                    ),
                  ],
                ),
                child: SvgPicture.asset('assets/svgs/filterprosections.svg'),
              )),
        ),
      ],
    );
  }
}
