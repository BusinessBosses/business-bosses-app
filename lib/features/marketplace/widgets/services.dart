import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/market_members.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_services.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/joinedbutton.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/service_item.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        return ListView.builder(
          itemCount: _marketController.services.length,
          itemBuilder: (BuildContext context, int index) {
            if (index <=
                (_marketController.isfiltered.value
                    ? _marketController.searchResult.length
                    : _marketController.services.length)) {
              final MarketModel market = _marketController.isfiltered.value
                  ? _marketController.searchResult[index]
                  : _marketController.services[index];
              return ServiceTile(
                post: market,
                controller: _marketController,
                key: ValueKey(market.marketId),
              );
            } else {
              // Display a loading indicator at the end of the list
              if (_marketController.loadingMore.value) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          },
        );
      }),
    );
  }
}
