import 'package:business_bosses_v2/bbpro/common/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/infocard.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/inventorycard.dart';
import 'package:business_bosses_v2/bbpro/presentation/viewproduct.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  String? _selectedItem; // Define the _selectedItem state variable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text(
          'Inventory',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 15),
            child: CircleAvatar(
              backgroundColor: prosemibackColor,
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(
                  'assets/svgs/notificationicon.svg',
                  height: 20,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(children: [
                    const Text(
                      "Product List",
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    const Text(
                      "(10)",
                      style: TextStyle(color: Colors.black),
                    ),
                  ]),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svgs/inventoryfilter.svg'),
                        Container(
                          height: 30,
                          width: 200,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedItem,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedItem = newValue;
                                });
                              },
                              items: ['rrtr', 'ekllee'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              isExpanded: true,
                              icon: Icon(
                                Icons.expand_more,
                                color: proprimaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            StaggeredGridView.countBuilder(
              physics: NeverScrollableScrollPhysics(),
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              // controller: _controller,
              shrinkWrap: true,
              itemCount: 40,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(ExpandedProduct());
                  },
                  child: InventoryCard(
                    cardName: 'Product name',
                    value: '\$20k',
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
