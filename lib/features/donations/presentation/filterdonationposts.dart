import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/widgets/donation_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';
import '../../home/controller/home_controller.dart';

class FilterDonationPosts extends StatelessWidget {
  final List<DonationModel> filterItems;
  final bool isLoading;
  final bool isSearch;

  /// CONSTRUCTOR
  const FilterDonationPosts({
    Key? key,
    this.filterItems = const <DonationModel>[],
    this.isLoading = false,
    this.isSearch = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    final DonationsController controller = Get.find();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: filterItems.isEmpty
          ? SafetyModel(
              icon: const Icon(
                Icons.edit,
                size: 80.0,
                color: hintColor,
              ),
              title: 'No projects found',
              subTitle: 'Your searched projects will be displayed here!',
              isLoading: isLoading,
            )
          : NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification) {
                FocusScope.of(context).unfocus();
                return false;
              },
              child: ListView.separated(
                key: key,
                separatorBuilder: (_, __) => const SizedBox(height: 0.0),
                padding: const EdgeInsets.all(16.0),
                itemCount: filterItems.length,
                itemBuilder: (BuildContext context, int i) {
                  return DonationItem(
                    isLastItem: false,
                    donation: filterItems[i],
                  );
                },
              ),
            ),
    );
  }
}
