import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChooseOrderBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> services;
  final List<Map<String, dynamic>> selectedItems;
  final ValueChanged<bool> onCanAddChange;
  const ChooseOrderBottomSheet({
    Key? key,
    required this.products,
    required this.services,
    required this.selectedItems,
    required this.onCanAddChange,
  }) : super(key: key);

  @override
  State<ChooseOrderBottomSheet> createState() => _ChooseOrderBottomSheetState();
}

class _ChooseOrderBottomSheetState extends State<ChooseOrderBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final ShopController shopController = Get.find();

  List<Map<String, dynamic>>? selectedItems;

  final List<Map<String, dynamic>> _tempSelectedItems =
      <Map<String, dynamic>>[];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    currencyController.text = shopController.shop!.currency;
    selectedItems = widget.selectedItems;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Select Order',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _selectedIndex == 0
                  ? ProIconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        Get.to(const CreateProductListing());
                      },
                      text: 'New Product',
                      radius: 10.0,
                    )
                  : _selectedIndex == 1
                      ? ProIconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Get.to(const CreateServiceListing());
                          },
                          text: 'New Service',
                          radius: 10.0,
                        )
                      : GestureDetector(
                          child: IconButton(
                              onPressed: Get.back,
                              icon: const Icon(Icons.close)),
                        ),
            ],
          ),
          const SizedBox(height: 10),
          CupertinoSlidingSegmentedControl<int>(
            backgroundColor: probackgroundColor,
            groupValue: _selectedIndex,
            children: const <int, Widget>{
              0: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  child: Text(
                    'Products',
                    style: TextStyle(fontSize: 14),
                  )),
              1: Text(
                'Services',
                style: TextStyle(fontSize: 14),
              ),
              2: Text(
                'Custom',
                style: TextStyle(fontSize: 14),
              ),
            },
            onValueChanged: (int? value) {
              setState(() {
                _selectedIndex = value!;
                _tabController.animateTo(value);
              });
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            // Use Expanded to make TabBarView fill the space
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                // Products Tab content
                Column(
                  children: widget.products.map((Map<String, dynamic> product) {
                    bool isLastSelected = _tempSelectedItems.isNotEmpty &&
                        _tempSelectedItems.last == product;
                    return Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text(product['name']),
                          value: _tempSelectedItems.contains(product),
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _tempSelectedItems.add(product);
                              } else {
                                _tempSelectedItems.remove(product);
                              }
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: proprimaryColor,
                        ),
                        if (isLastSelected)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ProIconButton(
                              onPressed: () {
                                setState(() {
                                  widget.selectedItems
                                      .addAll(_tempSelectedItems);
                                  _tempSelectedItems.clear();
                                });
                                Navigator.pop(context, widget.selectedItems);
                              },
                              text: 'Done',
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                ),

                // Services Tab content
                Column(
                  children: <Widget>[
                    ProSearchbar(
                      hasSearchIcon: true,
                      contentPadding: 10,
                      backgroundColor: backgroundColor,
                      hintText: 'Search Services',
                      onChange: (String query) {
                        setState(() {});
                      },
                      onSubmit: (String query) {},
                    ),
                    Column(
                      children:
                          widget.services.map((Map<String, dynamic> service) {
                        bool isLastSelected = widget.selectedItems.isNotEmpty &&
                            widget.selectedItems.last == service;
                        return Column(
                          children: <Widget>[
                            CheckboxListTile(
                              title: Text(service['name']),
                              value: widget.selectedItems.contains(service),
                              onChanged: (bool? selected) {
                                _onItemSelect(selected, service);
                              },
                              checkColor: Colors.white,
                              activeColor: proprimaryColor,
                            ),
                            if (isLastSelected)
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ProIconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.selectedItems
                                          .addAll(_tempSelectedItems);
                                      _tempSelectedItems.clear();
                                    });
                                    Navigator.pop(
                                        context, widget.selectedItems);
                                  },
                                  text: 'Done',
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),

                // Custom Tab content
                _buildCustomTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemSelect(bool? selected, Map<String, dynamic> item) {
    setState(() {
      if (selected == true) {
        _tempSelectedItems.add(item);
      } else {
        _tempSelectedItems.remove(item);
      }
    });
  }

  void _saveCustomOrder() {
    widget.selectedItems.add(<String, dynamic>{
      'name': nameController.text,
      'price': priceController.text,
      'description': descriptionController.text,
      'type': 'custom'
    });
    setState(() {
      widget.onCanAddChange(false);
    });

    Navigator.pop(context);
  }

  Widget _buildCustomTab() {
    return Column(
      children: <Widget>[
        CustomEditText(
          padding: 0,
          backgroundcolor: backgroundColor,
          caption: 'Order name',
          hintText: 'Enter product/service name here',
          controller: nameController,
        ),
        const SizedBox(
          height: 15,
        ),
        CustomEditText(
          iscurrencyfield: true,
          currencycontroller: currencyController,
          padding: 0,
          backgroundcolor: backgroundColor,
          caption: 'Price',
          hintText: '0.00',
          controller: priceController,
        ),
        const SizedBox(
          height: 15,
        ),
        CustomEditText(
          padding: 0,
          backgroundcolor: backgroundColor,
          caption: 'Description',
          hintText: 'Add order notes here',
          controller: descriptionController,
          maxLength: 300,
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          width: double.infinity,
          child: ProCustomButton(
            text: 'Save',
            onPressed: _saveCustomOrder,
          ),
        )
      ],
    );
  }

  // Widget _buildProductItem(String title, String price, String imagePath) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Row(
  //       children: <Widget>[
  //         Image.asset(
  //           imagePath,
  //           width: 100,
  //           height: 80,
  //           fit: BoxFit.cover,
  //         ),
  //         const SizedBox(width: 20),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               Text(
  //                 title,
  //                 style: const TextStyle(
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Text(price),
  //             ],
  //           ),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {},
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue,
  //           ),
  //           child: const Text('Select'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
