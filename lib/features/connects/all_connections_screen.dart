import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../action/action.dart';
import '../../common/models/my_connect.dart';
import '../../common/models/user_model.dart';
import '../../common/params.dart';
import '../../common/widgets/safety_model.dart';
import '../../utils/theme/theme.dart';
import '../search/search_app_bar.dart';

class AllConnectionsScreen extends StatefulWidget {
  static const routeName = '/all-connections-screen';

  const AllConnectionsScreen({Key? key}) : super(key: key);

  @override
  _AllConnectionsScreenState createState() => _AllConnectionsScreenState();
}

class _AllConnectionsScreenState extends State<AllConnectionsScreen> {
  List<UserModel> _allUsers = [];
  final List<UserModel> _suggestedUsers = [];
  List<UserModel> _searchedUsers = [];
  List<MyConnect> _myConnections = [];
  List<MyConnect> _myConnected = [];

  bool _isInit = false;
  bool _isLoading = true;
  bool _isSearching = false;
  UserModel? _specificUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      // final Params params =
      //     ModalRoute.of(context)?.settings.arguments as Params;
      // if (params.arg1 == null) {
      //   navigateTo(context);
      //   return;
      // }
      // _initialIndex = params?.arg2 ?? 0;

      // _specificUser = params.arg1;

      _loadUsers();

      _isInit = true;
    }
  }

  Future<void> _loadUsers() async {}

  void _loadConnections() async {}

  void _loadConnecteds() async {}

  int _initialIndex = 0;

  void _onChangeSearching() {
    setState(() {
      _isSearching = !_isSearching;
      _searchedUsers = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
            });
            return false;
          }
          navigateTo(context);
          return false;
        },
        child: DefaultTabController(
            length: 3,
            initialIndex: _initialIndex,
            child: Scaffold(
                appBar: _isSearching
                    ? SearchAppBar(
                        hintText: 'Search with name',
                        onClose: _onChangeSearching,
                        onChange: _onChange,
                      )
                    : AppBar(
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                        ),
                        centerTitle: true,
                        title: const Text(
                          'Connections',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        actions: [
                          IconButton(
                            onPressed: _onChangeSearching,
                            icon: SvgPicture.asset('assets/svgs/search.svg'),
                          )
                        ],
                      ),
                body: Stack(children: [
                  !_isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : Column(
                          children: [
                            Material(
                              color: Colors.white,
                              child: TabBar(
                                indicatorColor: primaryColorLT,
                                tabs: [
                                  Tab(
                                    child: FittedBox(
                                      child: Text(
                                        'Connections',
                                        // 'Connections',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: FittedBox(
                                      child: Text(
                                        'Connected',
                                        // 'Connected',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: FittedBox(
                                      child: Text(
                                        'Suggested',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: TabBarView(
                              children: [
                                if (!_isSearching)
                                  Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: SafetyModel(
                                        isLoading: false,
                                        icon: SvgPicture.asset(
                                          'assets/svgs/search.svg',
                                          color: hintColor,
                                          height: 80.0,
                                        ),
                                        title: 'Search users',
                                        subTitle:
                                            'Matched users will be displayed here!',
                                      ))
                              ],
                            )),
                          ],
                        )
                ]))));
  }

  void _onChange(String val) {}

  void _suggestionList() {}

  Widget getSafetyModel(String title) {
    return SafetyModel(
      isLoading: false,
      icon: SvgPicture.asset(
        'assets/svgs/group.svg',
        color: hintColor,
        height: 80.0,
      ),
      title: title,
      subTitle: '',
    );
  }

  void _sendNotification(UserModel user) {}
}
