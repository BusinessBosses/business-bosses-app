import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../action/action.dart';
import '../../common/widgets/tiles/outlinebuttonheader.dart';
import '../../functions/my_native_functions.dart';
import '../../navigation/routes.dart';
import 'my_profile_header.dart';

bool isExpanded = false;

class MyProfileScreen extends StatefulWidget {
  static const String routeName = '/my-profile-screen';

  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  List<String> achievements = <String>[];
  final List<int> msgCount = <int>[2, 0, 10, 6, 52, 4, 0, 2];

  TextEditingController nameController = TextEditingController();

  void addItemToList() {
    setState(() {
      achievements.insert(0, nameController.text);
      msgCount.insert(0, 0);
    });
  }

  bool _isInit = false;
  bool _isLoading = false;
  int activeIndex = 0;

  late UserModel _user;

  double headHeight = 440.0;
  dynamic myDataStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _onUrlLaunch(context, String url) async {
    try {
      await MyNativeFunctions.onUrlLaunch(url);
    } catch (e) {
      showSnackBar(context, message: e.toString());
      debugPrint('_MyProfileScreenState.onUrlLaunch catch: e: $e');
    }
  }

  Widget _buildChoiceChips(String data) {
    return SizedBox(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data == null ? 0 : data.split("+").length,
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              Chip(
                backgroundColor: backgroundcolorinterface,
                avatar: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 5,
                ),
                label: Text(
                  data.split('+')[index],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('@username'),
        actions: [
          IconButton(
              icon: SvgPicture.asset(
                'assets/svgs/settings.svg',
                height: 24.0,
              ),
              onPressed: () {
                Get.toNamed(Routes.settings);
              })
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverStickyHeader(
              sticky: false,
              header: const MyProfileHeader(),
            ),
          ];
        },
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              OutlineButtonHeader(),
              const SizedBox(height: 8.0),

              TabBar(
                labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                labelColor: Colors.black,
                indicatorColor: primaryColorLT,
                tabs: [
                  Tab(
                    icon: SvgPicture.asset(
                      'assets/svgs/portfolio.svg',
                      height: 20.0,
                    ),
                  ),
                  Tab(
                    icon: SvgPicture.asset(
                      'assets/svgs/posts.svg',
                      height: 20.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: double.infinity,
                height: 1.5,
                child: ColoredBox(color: backgroundcolorinterface),
              ),
              // Container(

              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const []),
                    ),
                    SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
