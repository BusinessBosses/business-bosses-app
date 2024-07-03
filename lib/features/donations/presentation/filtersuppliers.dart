import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';

class FilterSuppliers extends StatefulWidget {
  final List<SuppliersModel> filterItems;
  final List<SuppliersModel> members;
  final bool isLoading;
  final bool isSearch;

  // ignore: public_member_api_docs
  const FilterSuppliers(
      {Key? key,
      this.filterItems = const <SuppliersModel>[],
      this.isLoading = false,
      this.isSearch = false,
      this.members = const <SuppliersModel>[]})
      : super(key: key);

  @override
  State<FilterSuppliers> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<FilterSuppliers> {
  final ScrollController _controller = ScrollController();
  final ProfileController _profileController = Get.find();
  final bool loadingNext = false;
  @override
  Widget build(
    BuildContext context,
  ) {
    final ProfileController profileController = Get.find();
    return widget.filterItems.isEmpty
        ? SafetyModel(
            isLoading: widget.isLoading,
            icon: const Icon(
              Icons.person,
              size: 80.0,
              color: hintColor,
            ),
            title: 'There is no user',
            // subTitle: 'Be the first one to like!',
          )
        : Stack(
            children: <Widget>[
              NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  FocusScope.of(context).unfocus();
                  return false;
                },
                child: StaggeredGridView.countBuilder(
                  staggeredTileBuilder: (int index) =>
                      const StaggeredTile.fit(1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                  ),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  controller: _controller,
                  shrinkWrap: true,
                  itemCount: widget.filterItems.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SuppliersGridTile(
                      supplier: widget.filterItems[index],
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
            ],
          );
  }
}
