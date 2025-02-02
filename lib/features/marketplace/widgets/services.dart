import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/proshopdeals.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final MarketController _marketController = Get.find();
  final HomeController hmeController = Get.find();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}M';
      } else {
        return '${countInK.toStringAsFixed(1)}K';
      }
    } else {
      return count.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    _marketController.proServices.sort((Service a, Service b) {
      final DateTime aDate = a.createdAt;
      final DateTime bDate = b.createdAt;

      final String aLocation = a.location;
      final String bLocation = b.location;

      final String? myLocation =
          profileController.myProfile.location?.toLowerCase();

      // Ensure case-insensitive comparison
      final String aLoc = aLocation.toLowerCase();
      final String bLoc = bLocation.toLowerCase();

      // Step 1: Prioritize myLocation (Nigeria) at the top
      final bool aIsMyLocation = aLoc == myLocation;
      final bool bIsMyLocation = bLoc == myLocation;

      if (aIsMyLocation && !bIsMyLocation) return -1; // a (Nigeria) goes up
      if (!aIsMyLocation && bIsMyLocation) return 1; // b (Nigeria) goes up

      // Step 2: If both are Nigeria (or both are not Nigeria), sort by date (newest first)
      final DateTime safeADate = aDate;
      final DateTime safeBDate = bDate;

      return safeBDate.compareTo(safeADate);
    });
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0, top: 10),
                child: ProshopdealsWidget(
                  title: 'NEW',
                  services: _marketController.proServices
                      .where((Service item) =>
                          item.images != null &&
                          item.images!.isNotEmpty &&
                          item.images![0].isNotEmpty &&
                          item.user!.isSubscribed)
                      .take(10)
                      .toList(),
                  initialIndex: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  itemCount: _marketController.proServices.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final Service service =
                        _marketController.proServices[index];
                    return GestureDetector(
                      onTap: () {
                        if (service.user!.uid ==
                            profileController.myProfile.uid) {
                          // Navigate to edit listing
                        } else {
                          Get.to(() => BookServiceScreen(
                                service: service,
                                shop: service.shop!,
                              ));
                        }
                      },
                      child: ServiceCard(
                        marketplace: true,
                        shop: service.shop!,
                        service: service,
                        myShop: service.user!.uid ==
                            profileController.myProfile.uid,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
