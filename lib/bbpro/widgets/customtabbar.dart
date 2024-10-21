import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTabBarWidget<T> extends StatefulWidget {
  final TabController _tabController;
  final Function(int) _scrollToSection;
  final Color proprimaryColor;
  final Color backgroundColor;
  final List<T> listofitems;
  final String Function(T) itemToString;
  // final int itemCount;
  final List<String>? filterOptions; // List of filter options
  final VoidCallback? filterontap;

  const CustomTabBarWidget({
    super.key,
    required TabController tabController,
    required Function(int) scrollToSection,
    required this.proprimaryColor,
    required this.backgroundColor,
    required this.listofitems,
    required this.itemToString,
    // required this.itemCount,
    this.filterOptions, // Add filter options
    this.filterontap,
  })  : _tabController = tabController,
        _scrollToSection = scrollToSection;

  @override
  _CustomTabBarWidgetState<T> createState() => _CustomTabBarWidgetState<T>();
}

class _CustomTabBarWidgetState<T> extends State<CustomTabBarWidget<T>> {
  String? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
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
              controller: widget._tabController,
              onTap: widget._scrollToSection,
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
              tabs: widget.listofitems
                  .asMap()
                  .entries
                  .map((MapEntry<int, T> entry) {
                int index = entry.key;
                T status = entry.value;
                return Tab(
                  child: Padding(
                    padding: EdgeInsets.only(right: index == 3 ? 40.0 : 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget._tabController.index == index
                            ? widget.proprimaryColor
                            : widget.backgroundColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: index == 0
                            ? const Icon(
                                Icons.dashboard,
                                size: 11,
                              )
                            : Text(
                                widget.itemToString(status),
                                style: TextStyle(
                                    fontSize: 11,
                                    color: widget._tabController.index == index
                                        ? Colors.white
                                        : textColor),
                              ),
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
            child: GestureDetector(
              onTap: () {
                showMenu(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  context: context,
                  shadowColor: Colors.black,
                  position:
                      const RelativeRect.fromLTRB(double.infinity, 220, 15, 0),
                  items: widget.filterOptions!.map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ).then((String? selected) {
                  if (selected != null) {
                    setState(() {
                      selectedFilter = selected;
                    });
                    if (widget.filterontap != null) {
                      widget.filterontap!();
                    }
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: widget.backgroundColor.withOpacity(0.6),
                      offset: const Offset(-5, 0),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: SvgPicture.asset('assets/svgs/filterprosections.svg'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
