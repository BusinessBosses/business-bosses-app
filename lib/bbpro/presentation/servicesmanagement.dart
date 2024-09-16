import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  final ShopController shopController = Get.find();
  String? _selectedItem;

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
          'Manage Services',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                final RenderBox button =
                    context.findRenderObject() as RenderBox;
                final RenderBox overlay =
                    Overlay.of(context).context.findRenderObject() as RenderBox;
                final RelativeRect position = RelativeRect.fromRect(
                  Rect.fromPoints(
                    button.localToGlobal(
                        button.size.topRight(const Offset(0, 110)),
                        ancestor: overlay),
                    button.localToGlobal(
                        button.size.bottomRight(const Offset(0, 20)),
                        ancestor: overlay),
                  ),
                  Offset.zero & overlay.size,
                );

                showMenu(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  context: context,
                  shadowColor: Colors.black,
                  position: position,
                  items: <String>[
                    'All Services',
                    'Most Popular',
                    'Newest First',
                  ].map((String option) {
                    return PopupMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ).then((String? selected) {
                  if (selected != null) {
                    setState(() {
                      _selectedItem = selected;
                    });
                    // Implement filter logic here
                  }
                });
              },
              child: CircleAvatar(
                backgroundColor: backgroundColor,
                child: SvgPicture.asset('assets/svgs/filterprosections.svg'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Wrap(children: <Widget>[
                  Text(
                    'Services List',
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    '(10)',
                    style: TextStyle(color: Colors.black),
                  ),
                ]),
                ProCustomButton(
                  text: 'Add Service',
                  onPressed: () {
                    Get.to(() => const CreateServiceListing());
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Expanded(
            child: StaggeredGridView.countBuilder(
              physics: const AlwaysScrollableScrollPhysics(),
              staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
              ),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              itemCount: shopController.services.length,
              itemBuilder: (BuildContext context, int index) {
                final Service service = shopController.services[index];
                return GestureDetector(
                  // onTap: () {
                  //   Get.to(() => ExpandedService(
                  //         service: service,
                  //       ));
                  // },
                  child: const Text('service.name'),
                  // ServiceCard(
                  //   service: service,
                  // ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
