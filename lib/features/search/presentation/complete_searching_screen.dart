import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/search/widgets/search_bar.dart';
import 'package:business_bosses_v2/features/search/widgets/tabs_pages_filter_item.dart';
import 'package:business_bosses_v2/features/search/widgets/filterforum.dart';
import 'package:business_bosses_v2/features/search/widgets/filterposts.dart';
import 'package:business_bosses_v2/features/search/widgets/filterusers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../action/action.dart';
import '../../../common/params.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/models/forum_model.dart';
import '../../forum/presentation/specific_user_list_screen.dart';
import '../../posts/models/post_model.dart';
import '../../profile/presentation/publicprofilescreen.dart';
import '../widgets/my_search_tab.dart';

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

  bool _isInit = false;

  List<MySearchTab> _tabs = [];
  List<MySearchTab>? _selectedTabs = [];

  List<UserModel> _allUsers = [];
  List<UserModel> _searchUsers = [];

  List<PostModel> _searchPosts = [];
  List<ForumModel> _searchForum = [];

  bool _hasFilter = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      _fetchAllUsers();
      _initList();

      final data =
          ModalRoute.of(context)!.settings.arguments as List<MySearchTab>;
      if (data != null) {
        _hasFilter = false;
        _selectedTabs = data;
      } else {
        _hasFilter = true;

        _selectedTabs!.addAll([..._tabs]);
      }

      _tabController =
          TabController(vsync: this, length: _selectedTabs!.length);
    }
  }

  void _initList() {
    _tabs = [
      MySearchTab(
        label: 'Users',
        widget: const FilterUsers(),
      ),
      // MySearchTab(
      //   label: 'Posts',
      //   widget: FilterPosts(),
      // ),
      // MySearchTab(
      //   label: 'Communities',
      //   widget: FilterForum(),
      // ),
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _selectedTabs!.length,
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
            onSubmit: _onSubmit,
          ),
          actions: [
            if (_hasFilter)
              IconButton(
                icon: SvgPicture.asset('assets/svgs/filter.svg'),
                onPressed: _filterPage,
              ),
          ],
          bottom: _selectedTabs!.length <= 1
              ? null
              : TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  tabs: _selectedTabs!
                      .map(
                        (MySearchTab e) => Tab(text: e.label),
                      )
                      .toList(),
                ),
        ),
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: _selectedTabs!
                    .map(
                      (MySearchTab e) => e.widget!,
                    )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  int _pageIndex(String label) {
    return _selectedTabs!
        .indexWhere((MySearchTab element) => element.label == label);
  }

  void _filterPage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0.0),
          content: ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.9,
              child: TabsPagesFilterItem(
                allTab: MySearchTab.cloneList(_tabs),
                selectedTabs: MySearchTab.cloneList(_selectedTabs!),
                onFilterChange: _onFilterChange,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onFilterChange(List<MySearchTab> newTabs) {
    _selectedTabs = newTabs;
    _tabController = TabController(vsync: this, length: _selectedTabs!.length);
    setState(() {});
  }

  Future<void> _fetchAllUsers() async {}

  bool _isLoadingUser = false, _isLoadingPost = false, _isLoadingForum = false;

  Future<void> _onSubmit(String val) async {}
}
