import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/marketplace_item.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';
import '../../home/controller/home_controller.dart';

class FilterMarketplacePosts extends StatelessWidget {
  final List<MarketModel> filterItems;
  final bool isLoading;
  final bool isSearch;
  final bool isPostssearch;
  final String? selectedLocation;
  final String? selectedCategory;
  final Function(String?)? selectedCategoryChanged;
  final Function(String?, String?)? selectedLocationChanged;
  final String? filterCode;

  /// CONSTRUCTOR
  FilterMarketplacePosts({
    Key? key,
    this.filterItems = const <MarketModel>[],
    this.isLoading = false,
    this.isSearch = false,
    this.isPostssearch = false,
    this.selectedLocation,
    this.selectedCategory,
    this.selectedCategoryChanged,
    this.selectedLocationChanged,
    this.filterCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final MarketController controller = Get.find();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: ListView.separated(
            key: key,
            separatorBuilder: (_, __) => const SizedBox(height: 0.0),
            padding: const EdgeInsets.all(0.0),
            itemCount: isPostssearch == true
                ? filterItems.length + 2
                : filterItems.length + 1,
            itemBuilder: (BuildContext context, int i) {
              if (isPostssearch == true && i == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Filter results',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      selectedLocationChanged!(null, null);
                                      selectedCategoryChanged!(null);
                                    },
                                    child: const Text(
                                      'Clear Filter',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        selectedLocationChanged!(null, null);
                                        selectedCategoryChanged!(null);
                                      },
                                      icon: Icon(Icons.cancel))
                                ]),
                          ],
                        )),
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
                                  value: selectedCategory,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  onChanged: (String? newValue) {
                                    selectedCategoryChanged!(newValue);
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
                                              overflow: TextOverflow
                                                  .ellipsis, // Prevent text overflow
                                              maxLines: 1, // Ensure single line
                                            )
                                          : Text(
                                              'Select Category',
                                              overflow: TextOverflow
                                                  .ellipsis, // Prevent text overflow
                                              maxLines: 1, // Ensure single line
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                                          borderRadius: BorderRadius.circular(
                                              radiusValue),
                                        ),
                                        child: DropdownMenuItem<String>(
                                          value: selectedLocation,
                                          child: selectedLocation != null
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15.0),
                                                  child: Text(
                                                    selectedLocation!,
                                                    style: bodyText2.copyWith(
                                                        color: textColor,
                                                        fontSize: 16),
                                                    overflow: TextOverflow
                                                        .ellipsis, // Prevent text overflow
                                                    maxLines:
                                                        1, // Ensure single line
                                                  ),
                                                )
                                              : Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 15),
                                                  child: Text(
                                                    'Select Location',
                                                    overflow: TextOverflow
                                                        .ellipsis, // Prevent text overflow
                                                    maxLines:
                                                        1, // Ensure single line
                                                    style: bodyText2.copyWith(
                                                      color: hintColor,
                                                    ),
                                                  ),
                                                ),
                                        ));
                                  },
                                  onChanged: (CountryCode? code) {
                                    selectedLocationChanged!(
                                        code?.name, code?.code);
                                  },
                                  useSafeArea: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }

              if ((isPostssearch == true && i == 1) ||
                  (isPostssearch == false && i == 0)) {
                return Visibility(
                  visible: filterItems.isEmpty,
                  child: SafetyModel(
                    icon: const Icon(
                      Icons.search,
                      size: 80.0,
                      color: hintColor,
                    ),
                    title: 'No results found',
                    subTitle: 'Your results will be displayed here!',
                    isLoading: isLoading,
                  ),
                );
              } else if (i > 0 && i - 1 < filterItems.length) {
                return MarketTile(
                  post: filterItems[i - 1],
                  controller: controller,
                );
              } else {
                return SizedBox.shrink();
              }
            }),
      ),
    );
  }
}
