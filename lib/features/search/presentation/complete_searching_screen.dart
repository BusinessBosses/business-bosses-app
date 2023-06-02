import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:business_bosses_v2/features/search/widgets/filterusers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';

class CompleteSearchingScreen extends StatefulWidget {
  static const String routeName = '/completesearchingScreen';

  const CompleteSearchingScreen({Key? key}) : super(key: key);

  @override
  _CompleteSearchingScreenState createState() =>
      _CompleteSearchingScreenState();
}

class _CompleteSearchingScreenState extends State<CompleteSearchingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final bool _hasFilter = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(vsync: this, length: 1);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
      builder: (CompleteSearchController controller) {
        return DefaultTabController(
          length: 1,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              titleSpacing: 0.0,
              automaticallyImplyLeading: false,
              leadingWidth: 48.0,
              leading: IconButton(
                alignment: Alignment.centerRight,
                onPressed: () => navigateTo(context),
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              title: Searchbar(
                hintText: 'Search',
                onSubmit: (_) {},
              ),
              actions: [
                if (_hasFilter)
                  IconButton(
                    icon: SvgPicture.asset('assets/svgs/filter.svg'),
                    onPressed: () {},
                  ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      FilterUsers(
                        filterItems: controller.recommendedConnections,
                        isLoading: controller.loading.value,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
