import 'package:business_bosses_v2/features/marketplace/controllers/supplier_controller.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  const SuppliersPage({
    Key? key,
    this.filterItems = const <UserModel>[],
    this.isLoading = false,
    this.isSearch = false,
    this.onConnectionChange,
    this.members = const <UserModel>[],
  }) : super(key: key);

  @override
  State<SuppliersPage> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<SuppliersPage> {
  final SupplierController supplierController = Get.put(SupplierController());
  final ProfileController profileController = Get.find();
  final bool loadingNext = false;
  String? filterCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Obx(
              () => supplierController.loading.value
                  ? const Center(child: SafetyModel())
                  : Column(
                      children: <Widget>[
                        // Container(
                        //   color: backgroundColor,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(
                        //       left: 15,
                        //       top: 10,
                        //       bottom: 10,
                        //     ),
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         showDialog(
                        //           context: context,
                        //           builder: (BuildContext context) =>
                        //               suppliersGuide(context),
                        //         );
                        //       },
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Wrap(
                        //             crossAxisAlignment:
                        //                 WrapCrossAlignment.center,
                        //             children: <Widget>[
                        //               const Text(
                        //                 'Guidelines ',
                        //                 style: TextStyle(
                        //                   fontSize: 12,
                        //                   fontWeight: FontWeight.w700,
                        //                 ),
                        //               ),
                        //               SvgPicture.asset(
                        //                 'assets/svgs/info.svg',
                        //                 height: 20,
                        //               ),
                        //             ],
                        //           ),
                        //           Align(
                        //             alignment: Alignment.centerRight,
                        //             child: Padding(
                        //               padding: const EdgeInsets.only(
                        //                 right: 15,
                        //               ),
                        //               child: ElevatedButton(
                        //                 style: ElevatedButton.styleFrom(
                        //                   minimumSize: const Size(
                        //                     150,
                        //                     45,
                        //                   ),
                        //                 ),
                        //                 onPressed: () {
                        //                   Get.to(
                        //                       () => const AddSupplierScreen());
                        //                 },
                        //                 child: Row(
                        //                   mainAxisSize: MainAxisSize.min,
                        //                   children: <Widget>[
                        //                     const Text(
                        //                       'Add a Supplier',
                        //                       style: TextStyle(
                        //                         fontSize: 15,
                        //                         color: Colors.white,
                        //                         fontWeight: FontWeight.w500,
                        //                       ),
                        //                     ),
                        //                     const SizedBox(
                        //                       width: 5,
                        //                     ),
                        //                     SvgPicture.asset(
                        //                       'assets/svgs/startatopic.svg',
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        NotificationListener<ScrollNotification>(
                          onNotification:
                              (ScrollNotification scrollNotification) {
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
                            itemCount: supplierController.suppliers.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              return SuppliersGridTile(
                                supplier: supplierController.suppliers[index],
                              );
                            },
                          ),
                        ),
                        if (loadingNext)
                          const Positioned(
                            bottom: 10.0,
                            right: 0.0,
                            left: 0.0,
                            child: SafetyModel(isLoading: true),
                          ),
                        Container(
                          height: 90,
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
