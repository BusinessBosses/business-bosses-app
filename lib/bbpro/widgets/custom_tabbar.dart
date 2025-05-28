import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomTabBarWidget<T> extends StatefulWidget {
  final TabController _tabController;
  final Function(int) _scrollToSection;
  final Color proprimaryColor;
  final List<Color> backgroundColor;
  final List<T> listofitems;
  final String Function(T) itemToString;
  final String? selectedFilter;
  final List<String>? filterOptions;
  final int? initialposition;
  final VoidCallback? filterontap;
  final ValueChanged<String?>?
      onFilterSelected; // New callback for selected filter

  const CustomTabBarWidget({
    super.key,
    required TabController tabController,
    required Function(int) scrollToSection,
    required this.proprimaryColor,
    required this.backgroundColor,
    required this.listofitems,
    required this.itemToString,
    this.filterOptions,
    this.filterontap,
    this.selectedFilter,
    this.onFilterSelected,
    this.initialposition, // Initialize the new callback
  })  : _tabController = tabController,
        _scrollToSection = scrollToSection;

  @override
  _CustomTabBarWidgetState<T> createState() => _CustomTabBarWidgetState<T>();
}

class _CustomTabBarWidgetState<T> extends State<CustomTabBarWidget<T>> {
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = widget.selectedFilter;
    if (widget.initialposition != null) {
      widget._tabController.animateTo(widget.initialposition!);
    }
  }

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
              tabAlignment: TabAlignment.start,
              controller: widget._tabController,
              onTap: widget._scrollToSection,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
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
                            ? index == 0
                                ? Colors.black54
                                : widget.backgroundColor[index]
                                    .withValues(alpha: 1)
                            : widget.backgroundColor[index],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: index == 0
                            ? Text('All',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: widget._tabController.index == index
                                        ? Colors.white
                                        : textColor))
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
      ],
    );
  }
}
