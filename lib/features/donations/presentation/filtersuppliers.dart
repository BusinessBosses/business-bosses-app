import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';

class FilterSuppliers extends StatefulWidget {
  final List<SuppliersModel> filterItems;
  final List<SuppliersModel> members;
  final bool isLoading;
  final bool isSearch;

  // ignore: public_member_api_docs
  const FilterSuppliers(
      {Key? key,
      this.filterItems = const <SuppliersModel>[],
      this.isLoading = false,
      this.isSearch = false,
      this.members = const <SuppliersModel>[]})
      : super(key: key);

  @override
  State<FilterSuppliers> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<FilterSuppliers> {
  final ScrollController _controller = ScrollController();
  final bool loadingNext = false;
  String? _selectedCategory;
  String? _selectedLocation;
  String? filterCode;

  @override
  Widget build(BuildContext context) {
    List<SuppliersModel> filteredItems = widget.filterItems;

    if (_selectedCategory != null) {
      filteredItems = filteredItems
          .where((SuppliersModel item) => item.category == _selectedCategory)
          .toList();
    }

    if (_selectedLocation != null) {
      filteredItems = filteredItems
          .where((SuppliersModel item) => item.location == _selectedLocation)
          .toList();
    }

    return filteredItems.isEmpty
        ? SafetyModel(
            isLoading: widget.isLoading,
            icon: const Icon(
              Icons.person,
              size: 80.0,
              color: hintColor,
            ),
            title: 'There is no supplier',
            // subTitle: 'Be the first one to like!',
          )
        : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollNotification) {
                      FocusScope.of(context).unfocus();
                      return false;
                    },
                    child: StaggeredGridView.countBuilder(
                      staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(1),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      controller: _controller,
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SuppliersGridTile(
                          supplier: filteredItems[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
