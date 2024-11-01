import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/shopscreen.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GotoshopWidget extends StatefulWidget {
  const GotoshopWidget({super.key});

  @override
  State<GotoshopWidget> createState() => _GotoshopWidgetState();
}

class _GotoshopWidgetState extends State<GotoshopWidget> {
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, right: 15),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const ShopScreen());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 40.0,
                        width: 40.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: NetworkImageWithPlaceHolder(
                            imageUrl: shopController.shop?.image ?? '',
                            radius: 8,
                            placeHolder: Icons.person,
                            iconSize: 22.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              shopController.shop!.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700),
                            ),
                            Text(
                                'Shop Visits: ${shopController.shopStats != null ? shopController.shopStats!.views : 0}',
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ]),
              ),
              const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.to(() => const AvailabilityScreen());
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 10, vertical: 8),
                    //     decoration: BoxDecoration(
                    //         color: backgroundColor,
                    //         borderRadius: BorderRadius.circular(50)),
                    //     child: const Wrap(children: <Widget>[
                    //       Icon(
                    //         Icons.calendar_month,
                    //         size: 15,
                    //       ),
                    //       SizedBox(
                    //         width: 5,
                    //       ),
                    //       Text(
                    //         'Availability',
                    //         style: TextStyle(
                    //             fontSize: 13, fontWeight: FontWeight.w700),
                    //       )
                    //     ]),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // PopupMenuButton<String>(
                    //   onSelected: (String item) {
                    //     switch (item) {
                    //       case 'Item 1':
                    //         Get.to(() => const CreateProductListing());
                    //         break;
                    //       case 'Item 2':
                    //         Get.to(() => const CreateServiceListing());
                    //         break;
                    //       case 'Item 3':
                    //         Get.to(() => const Addproject());
                    //         break;
                    //       case 'Item 4':
                    //         Get.to(() => const CreateOrder());
                    //         break;
                    //       case 'Item 5':
                    //         Get.to(() => const Addclient());
                    //         break;
                    //       case 'Item 6':
                    //         Get.to(() => const AddSupplier());
                    //         break;
                    //     }
                    //   },
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //   ),
                    //   itemBuilder: (BuildContext context) {
                    //     return <PopupMenuEntry<String>>[
                    //       const PopupMenuItem<String>(
                    //         value: 'Item 1',
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(Icons.add),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               'Add Products',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'Item 2',
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(Icons.add),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               'Add Services',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'Item 3',
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(Icons.add),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               'Add Tasks',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'Item 4',
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(Icons.add),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               'Add Orders',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'Item 5',
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(Icons.add),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               'Add Clients',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       const PopupMenuItem<String>(
                    //         value: 'Item 6',
                    //         child: Row(
                    //           children: <Widget>[
                    //             Icon(Icons.add),
                    //             SizedBox(width: 8),
                    //             Text(
                    //               'Add Suppliers',
                    //               style: TextStyle(
                    //                 fontSize: 13,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ];
                    //   },
                    //   offset: const Offset(0, 40),
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 4, vertical: 4),
                    //     decoration: BoxDecoration(
                    //       color: proprimaryColor,
                    //       borderRadius: BorderRadius.circular(20),
                    //     ),
                    //     child: const Icon(
                    //       Icons.add,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}
