import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';

class SuppliersPage extends StatefulWidget {
  final List<UserModel> filterItems;
  final List<UserModel> members;
  final bool isLoading;
  final bool isSearch;
  final Function(UserModel)? onConnectionChange;

  // ignore: public_member_api_docs
  const SuppliersPage(
      {Key? key,
      this.filterItems = const <UserModel>[],
      this.isLoading = false,
      this.isSearch = false,
      this.onConnectionChange,
      this.members = const <UserModel>[]})
      : super(key: key);

  @override
  State<SuppliersPage> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<SuppliersPage> {
  final SupplierController supplierController = Get.put(SupplierController());
  final ProfileController profileController = Get.find();
  final bool loadingNext = false;
  String? _selectedCategory;
  String? _selectedLocation;
  String? filterCode;

  @override
  void initState() {
    supplierController.initSuppliers();
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<SupplierController>();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Suppliers & Manufacturers',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Obx(
        () => supplierController.loading.value
            ? const Center(child: SafetyModel())
            : widget.filterItems.isEmpty
                ? Column(
                    children: <Widget>[
                      Visibility(
                        visible: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
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
                                                  overflow: TextOverflow
                                                      .ellipsis, // Prevent text overflow
                                                  maxLines:
                                                      1, // Ensure single line
                                                )
                                              : Text(
                                                  'Select Category',
                                                  overflow: TextOverflow
                                                      .ellipsis, // Prevent text overflow
                                                  maxLines:
                                                      1, // Ensure single line
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
                                            borderRadius: BorderRadius.circular(
                                                radiusValue),
                                          ),
                                          child: DropdownMenuItem<String>(
                                            value: _selectedLocation,
                                            child: _selectedLocation != null
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15.0),
                                                    child: Text(
                                                      _selectedLocation!,
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
                      ),
                      Expanded(
                        child: StaggeredGridView.countBuilder(
                            staggeredTileBuilder: (int index) =>
                                const StaggeredTile.fit(1),
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            itemCount: supplierController.suppliers.length,
                            itemBuilder: (BuildContext context, int index) {
                              return SuppliersGridTile(
                                supplier: supplierController.suppliers[index],
                              );
                            }),
                      ),
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      NotificationListener<ScrollNotification>(
                        onNotification:
                            (ScrollNotification scrollNotification) {
                          FocusScope.of(context).unfocus();
                          return false;
                        },
                        child: Expanded(
                          child: StaggeredGridView.countBuilder(
                              staggeredTileBuilder: (int index) =>
                                  const StaggeredTile.fit(1),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              itemCount: supplierController.suppliers.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SuppliersGridTile(
                                  supplier: supplierController.suppliers[index],
                                );
                              }),
                        ),
                      ),
                      if (loadingNext)
                        const Positioned(
                          bottom: 10.0,
                          right: 0.0,
                          left: 0.0,
                          child: SafetyModel(isLoading: true),
                        ),
                    ],
                  ),
      ),
    );
  }
}
