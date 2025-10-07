import 'package:business_bosses_v2/features/search/widgets/filter_modal.dart';
import 'package:business_bosses_v2/features/search/widgets/people_tab.dart';
import 'package:business_bosses_v2/features/search/widgets/posts_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:business_bosses_v2/features/home/widgets/howtousetile.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';

import '../../../action/action.dart';

class CompleteSearchingScreen extends StatefulWidget {
  static const String routeName = '/completesearchingScreen';

  const CompleteSearchingScreen({super.key});

  @override
  State<CompleteSearchingScreen> createState() =>
      _CompleteSearchingScreenState();
}

class _CompleteSearchingScreenState extends State<CompleteSearchingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _filterTitle = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
      builder: (CompleteSearchController controller) {
        return Scaffold(
          backgroundColor: backgroundcolorinterface,
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
              onChange: (String value) {
                controller.query.value = value;
                if (value.isEmpty) {
                  controller.clearUserSearch();
                } else {
                  controller.search(currentIndex: _tabController.index);
                }
              },
              onSubmit: (String value) {
                controller.query.value = value;
                controller.search(currentIndex: _tabController.index);
              },
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight + 50),
              child: Column(
                children: <Widget>[
                  const HowtouseTile(),
                  TabBar(
                    controller: _tabController,
                    tabs: const <Widget>[
                      Tab(
                        child: TextWidget(
                          text: 'People',
                          size: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Tab(
                        child: TextWidget(
                          text: 'Posts',
                          size: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              if (_tabController.index == 0)
                IconButton(
                  onPressed: () {
                    showFilterModal(context, controller, (String val) {
                      setState(() => _filterTitle = val);
                    });
                  },
                  icon: SvgPicture.asset('assets/svgs/filternoback.svg'),
                ),
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                PeopleTab(
                  controller: controller,
                  filterTitle: _filterTitle,
                ),
                PostsTab(controller: controller),
              ],
            ),
          ),
        );
      },
    );
  }
}
