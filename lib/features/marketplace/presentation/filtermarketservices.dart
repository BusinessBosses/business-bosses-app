import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';

import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class FilterMarketServices extends StatelessWidget {
  /// CONSTRUCTOR
  const FilterMarketServices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.find();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification) {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: GetBuilder<MarketController>(
          builder: (MarketController marketController) =>
              marketController.filteredServices.isEmpty
                  ? marketController.searchQuery.isEmpty &&
                          (marketController.selectedCategory == null ||
                              (marketController.selectedCategory != null &&
                                  marketController.selectedCategory!.isEmpty))
                      ? const SafetyModel(
                          isLoading: false,
                          icon: Icon(
                            Icons.search,
                            size: 50,
                          ),
                          title: 'Search For Services',
                        )
                      : const SafetyModel(
                          isLoading: false,
                          icon: Icon(Icons.warning),
                          title: 'No Service Found!',
                        )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 2,
                          staggeredTileBuilder: (int index) =>
                              const StaggeredTile.fit(1),
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          itemCount: marketController.filteredServices.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            final Service service =
                                marketController.filteredServices[index];
                            return GestureDetector(
                              onTap: () {
                                if (service.user!.uid ==
                                    profileController.myProfile.uid) {
                                  // Get.to(() => CreateServiceListing(service: service));
                                } else {
                                  Get.to(() => BookServiceScreen(
                                        service: service,
                                        shop: service.shop!,
                                      ));
                                }
                              },
                              child: ServiceCard(
                                shop: service.shop!,
                                marketplace: true,
                                service: service,
                                myShop: service.user!.uid ==
                                        profileController.myProfile.uid
                                    ? true
                                    : false,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
