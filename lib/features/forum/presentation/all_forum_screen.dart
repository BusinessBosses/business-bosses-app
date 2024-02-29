import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/presentation/courses.dart';
import 'package:business_bosses_v2/features/forum/presentation/topics.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';
import '../models/industry.dart';
import '../../../utils/theme/theme.dart';

// ignore: public_member_api_docs
class AllForumScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = 'all-forum-screen';

  // ignore: public_member_api_docs
  const AllForumScreen({super.key});

  @override
  State<AllForumScreen> createState() => _AllForumScreenState();
}

class _AllForumScreenState extends State<AllForumScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  late Industry industry;
  final ProfileController _myProfile = Get.find();
  final HomeController hmeController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.arguments == null) {
      Get.back();
    } else {
      industry = Get.arguments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForumController>(
      builder: (ForumController controller) {
        return Scaffold(
          backgroundColor: backgroundcolorinterface,
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
            ),
            centerTitle: true,
            title: Text(
              industry.industry ?? 'Topic',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          body: DefaultTabController(
            length: 1,
            child: Column(
              children: <Widget>[
                // Container(
                //   color: Colors.white,
                //   constraints: const BoxConstraints.expand(height: 50),
                //   child: const TabBar(
                //     tabs: <Widget>[
                //       Tab(
                //         text: 'Topics',
                //       ),
                //       Tab(text: 'Courses'),
                //     ],
                //   ),
                // ),
                Expanded(
        child: TabBarView(
          children: <Widget>[
            // View for 'Topics' tab
            Container(
              child: const TopicsPage()
            ),
            // View for 'Courses' tab
            // Container(
            //   child: const CoursesPage(),
            // ),
          ],
        ),
      ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatCount(int count) {
    if (count >= 1000) {
      double countInK = count / 1000;
      if (countInK >= 1000) {
        return '${(countInK / 1000).toStringAsFixed(1)}m';
      } else {
        return '${countInK.toStringAsFixed(1)}k';
      }
    } else {
      return count.toString();
    }
  }

  void toggleJoinAndLeaveIndustry(ForumController controller) {
    final String myUid = _myProfile.myProfile.uid;
    // print(myUid);
    if (industry.joinedUsers?.contains(myUid) ?? false) {
      industry.joinedUsers!.removeWhere((String element) => element == myUid);
    } else {
      if (industry.joinedUsers == null) {
        industry.joinedUsers = <String>[myUid];
      } else {
        industry.joinedUsers!.add(myUid);
      }
    }
    setState(() {});
    controller.joinAndLeaveIndustry(myUid, industry.industryId!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    Get.delete<ForumController>();
    super.dispose();
  }
}
