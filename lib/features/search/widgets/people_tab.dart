import 'package:flutter/material.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/search/widgets/filterusers.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:get/get.dart';

class PeopleTab extends StatelessWidget {
  final CompleteSearchController controller;
  final String filterTitle;

  const PeopleTab({
    super.key,
    required this.controller,
    required this.filterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return GetX<CompleteSearchController>(
      init: controller,
      builder: (CompleteSearchController controller) {
        final List<UserModel> sortedUsers = controller.isUserSearch.value
            ? List<UserModel>.from(controller.searchedUsers)
            : List<UserModel>.from(controller.recommendedConnections);

        // Sort users with photos first
        sortedUsers.sort((UserModel a, UserModel b) {
          if (a.photoUrl?.isNotEmpty == true && (b.photoUrl?.isEmpty ?? true)) {
            return -1;
          }
          if (b.photoUrl?.isNotEmpty == true && (a.photoUrl?.isEmpty ?? true)) {
            return 1;
          }
          return 0;
        });

        return FilterUsers(
          filterItems: sortedUsers,
          isLoading: controller.loading.value || controller.loadingSearch.value,
          onConnectionChange: controller.connectToUser,
          isSearch: controller.isUserSearch.value,
        );
      },
    );
  }
}
