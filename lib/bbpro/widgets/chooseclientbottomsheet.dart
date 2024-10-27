import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseClientBottomSheet extends StatefulWidget {
  final List<Map<String, dynamic>> online;
  final List<Map<String, dynamic>> inperson;
  final List<Map<String, dynamic>> bbuser;
  final String selectedItem;

  const ChooseClientBottomSheet({
    Key? key,
    required this.selectedItem,
    required this.online,
    required this.inperson,
    required this.bbuser,
  }) : super(key: key);

  @override
  State<ChooseClientBottomSheet> createState() =>
      _ChooseClientBottomSheetState();
}

class _ChooseClientBottomSheetState extends State<ChooseClientBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController currencyController = TextEditingController();
  final ShopController shopController = Get.find();

  String _onlineSearchQuery = '';
  String _inpersonSearchQuery = '';
  String _bbuserSearchQuery = '';
  String? selectedItem; // Local variable to track selected item

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
    selectedItem =
        widget.selectedItem; // Initialize with widget's selected item
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
                'Select Client',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Wrap(children: <Widget>[
                ProIconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Get.to(const Addclient());
                  },
                  text: 'New Client',
                  radius: 10.0,
                ),
              ])
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
                    'Online',
                    style: TextStyle(fontSize: 14),
                  )),
              1: Text(
                'In-person',
                style: TextStyle(fontSize: 14),
              ),
              2: Text(
                'BB-User',
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
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildClientList(widget.online, _onlineSearchQuery,
                    (String query) {
                  setState(() {
                    _onlineSearchQuery = query;
                  });
                }),
                _buildClientList(widget.inperson, _inpersonSearchQuery,
                    (String query) {
                  setState(() {
                    _inpersonSearchQuery = query;
                  });
                }),
                _buildClientList(widget.bbuser, _bbuserSearchQuery,
                    (String query) {
                  setState(() {
                    _bbuserSearchQuery = query;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientList(List<Map<String, dynamic>> clients,
      String searchQuery, Function(String) onSearchChange) {
    final List<Map<String, dynamic>> filteredClients = clients
        .where((Map<String, dynamic> client) =>
            client['name'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: <Widget>[
        ProSearchbar(
          hasSearchIcon: true,
          contentPadding: 10,
          backgroundColor: backgroundColor,
          hintText: 'Search Clients',
          onChange: onSearchChange,
          onSubmit: (String query) {},
        ),
        const SizedBox(height: 10),
        Expanded(
          child: filteredClients.isNotEmpty
              ? ListView(
                  children: filteredClients.map((Map<String, dynamic> client) {
                    return Column(
                      children: <Widget>[
                        CheckboxListTile(
                          title: Text(client['name']),
                          value: selectedItem == client['name'],
                          onChanged: (bool? selected) {
                            _onItemSelect(selected, client);
                          },
                          checkColor: Colors.white,
                          activeColor: proprimaryColor,
                        ),
                        if (selectedItem == client['name'])
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: ProIconButton(
                              onPressed: () {
                                Navigator.pop(context,
                                    selectedItem); // Return selected item
                              },
                              text: 'Done',
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                )
              : const Text(
                  'No search results',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
        ),
      ],
    );
  }

  void _onItemSelect(bool? selected, Map<String, dynamic> item) {
    setState(() {
      if (selected == true) {
        selectedItem = item['name'];
      } else {
        selectedItem = null;
      }
    });
  }
}
