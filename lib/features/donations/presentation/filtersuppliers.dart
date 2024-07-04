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
          .where((item) => item.category == _selectedCategory)
          .toList();
    }

    if (_selectedLocation != null) {
      filteredItems = filteredItems
          .where((item) => item.location == _selectedLocation)
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
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 250,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                ),
                                iconSize: 24,
                                elevation: 16,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue!;
                                  });
                                },
                                items: <String?>[
                                  null,
                                  'Home, Garden & Outdoors',
                                  'Fashion & Beauty',
                                  'Sports & Entertainment',
                                  'Books & Education',
                                  'Jewellery & Timepieces',
                                  'Security, Safety & Equipment',
                                  'Video Games & Electronics',
                                  'Agriculture, Food, Beverage',
                                  'Construction & Real Estate',
                                  'Vehicle & Transportation',
                                  'Business Services & Events',
                                  'Other',
                                ].map<DropdownMenuItem<String>>(
                                    (String? value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: value != null
                                        ? Text(
                                            value,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )
                                        : Text(
                                            'Select Category',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: bodyText2.copyWith(
                                              color: hintColor,
                                            ),
                                          ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: CountryListPick(
                              appBar: AppBar(
                                leading: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/svgs/backbutton.svg'),
                                ),
                                centerTitle: true,
                                // ignore: prefer_const_constructors
                                title: Text(
                                  'Select Location',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                              initialSelection: filterCode ?? 'GB',
                              pickerBuilder: (BuildContext context,
                                  CountryCode? countryCode) {
                                return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(radiusValue),
                                    ),
                                    child: DropdownMenuItem<String>(
                                      value: _selectedLocation,
                                      child: _selectedLocation != null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Text(
                                                _selectedLocation!,
                                                style: bodyText2.copyWith(
                                                    color: textColor,
                                                    fontSize: 16),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Text(
                                                'Select Location',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: bodyText2.copyWith(
                                                  color: hintColor,
                                                ),
                                              ),
                                            ),
                                    ));
                              },
                              onChanged: (CountryCode? code) {
                                setState(
                                  () {
                                    _selectedLocation = code?.name;
                                    filterCode = code?.code;
                                  },
                                );
                              },
                              useSafeArea: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      FocusScope.of(context).unfocus();
                      return false;
                    },
                    child: StaggeredGridView.countBuilder(
                      staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
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
