// ignore_for_file: always_specify_types, unused_field, public_member_api_docs, constant_identifier_names, unused_element

import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/models/user_model.dart';
import '../../features/promotions/referrals.dart';
import '../../utils/theme/theme.dart';
import '../models/ranking.dart';

class MyRankingScreen extends StatefulWidget {
  static const String routeName = '/my-ranking-screen';

  const MyRankingScreen({Key? key}) : super(key: key);

  @override
  State<MyRankingScreen> createState() => _MyRankingScreenState();
}

class _MyRankingScreenState extends State<MyRankingScreen> {
  bool _isInit = false;
  final List<Ranking> _weeklyRanking = [];
  final List<Ranking> _monthlyRanking = [];
  final List<Ranking> _top10WeeklyRanking = [];

  // List<Ranking> _top10MonthlyRanking = [];
  // List<Ranking> _top25WeeklyRanking = [];
  final List<Ranking> _top25MonthlyRanking = [];
  static const int TOP_10 = 10;
  static const int TOP_25 = 25;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      _loadRankingProfile();
    }
  }

  final Ranking _myWeeklyRanking = Ranking();
  final Ranking _myMonthlyRanking = Ranking();

  Future<void> _loadRankingProfile() async {
    // String weeklyRankingPath =
    //     '${Constants.RANKED_USERS}/${Constants.TOP_10_WEEKLY}';
    // MyResponse res1 =
    //     await _firebase.fetchANode(id: _firebase.uid, path: weeklyRankingPath);
    // if (res1.success && res1.data != null) {
    //   _myWeeklyRanking = Ranking.fromSnapshot(res1.data);
    //   bool isWithInTime =
    //       DateTime.now().millisecondsSinceEpoch - _myWeeklyRanking.timestamp <=
    //           TimeFormat.ONE_WEEK;
    //   if (!isWithInTime) {
    //     await _fetchAndRankData();
    //     _rankWeekly();
    //   }
    // } else {}
    // String monthlyRankingPath =
    //     '${Constants.RANKED_USERS}/${Constants.TOP_25_MONTHLY}';
    // MyResponse res2 =
    //     await _firebase.fetchANode(id: _firebase.uid, path: monthlyRankingPath);
    // if (res2.success && res2.data != null) {
    //   _myMonthlyRanking = Ranking.fromSnapshot(res2.data);
    //   bool isWithInTime =
    //       DateTime.now().millisecondsSinceEpoch - _myMonthlyRanking.timestamp <=
    //           TimeFormat.ONE_MONTH;
    //   if (!isWithInTime) {
    //     await _fetchAndRankData();
    //     _rankMonthly();
    //   }
    // } else {}
    // await _fetchAndRankData();
    // _rankWeekly();
    // await _fetchAndRankData();
    // _rankMonthly();
    // setState(() {});
  }

  void _rankWeekly() {
    // // _top25WeeklyRanking = _toRankUsers(TOP_25, _weeklyRanking);
    // Map<String, dynamic> map = {};
    // map['${Constants.RANKED_USERS}/${Constants.TOP_10_WEEKLY}'] =
    //     toRankingMap(_top10WeeklyRanking);
    // map['${Constants.EXTRAS}/${Constants.WEEKLY_RANKING}'] =
    //     DateTime.now().millisecondsSinceEpoch;
    // _updateRanking(map);
  }

  void _rankMonthly() {
    // Map<String, dynamic> map = {};
    // map['${Constants.RANKED_USERS}/${Constants.TOP_25_MONTHLY}'] =
    //     toRankingMap(_top25MonthlyRanking);
    // map['${Constants.EXTRAS}/${Constants.MONTHLY_RANKING}'] =
    //     DateTime.now().millisecondsSinceEpoch;
    // _updateRanking(map);
  }

  Future<void> _updateRanking(Map map) async {
    // MyResponse res = await _firebase.updateWithBatch(map);
    // if (res.success) {
    // } else {
    //   showSnackBar(context, message: res.message);
    // }
  }

  Future<void> _fetchAndRankData() async {
    // await _fetchAllUsers();
    // await _fetchAllPosts();
    // await _fetchAllReferrals();
    // _weeklyRanking = _calculateRanking(TimeFormat.ONE_WEEK * 5);
    // _top10WeeklyRanking = _toRankUsers(TOP_10, _weeklyRanking);
    // _myWeeklyRanking = _top10WeeklyRanking.firstWhere(
    //     (element) => element.uid == _firebase.uid,
    //     orElse: () => Ranking());
    // _monthlyRanking = _calculateRanking(TimeFormat.ONE_MONTH * 5);
    // _top25MonthlyRanking = _toRankUsers(TOP_25, _monthlyRanking);
    // _myMonthlyRanking = _top10WeeklyRanking.firstWhere(
    //     (element) => element.uid == _firebase.uid,
    //     orElse: () => Ranking());
    // // _rankWeekly();
    // // _rankMonthly();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Ranking',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              height: 20,
              child: ColoredBox(color: backgroundcolorinterface),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        height: 150,
                        decoration: BoxDecoration(
                          color: backgroundcolorinterface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Weekly Ranking',
                                  style: bodyText1.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Top',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Stack(
                                  children: [
                                    const SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: CircularProgressIndicator(
                                        value: 1,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                        strokeWidth: 10.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: CircularProgressIndicator(
                                        value: 0.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                textColor),
                                        strokeWidth: 5.0,
                                      ),
                                    ),
                                    Positioned.fill(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _myWeeklyRanking.isNotEmpty
                                            ? '10%'
                                            : '50%',
                                        style: bodyText1.copyWith(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: backgroundcolorinterface,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: // if (_myMonthlyRanking.isNotEmpty)
                            Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Monthly Ranking',
                                  style: bodyText1.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Top',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Stack(
                                  children: [
                                    const SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: CircularProgressIndicator(
                                        value: 1,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                backgroundcolorinterface),
                                        strokeWidth: 10.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 55,
                                      height: 55,
                                      child: CircularProgressIndicator(
                                        value: 0.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                textColor),
                                        strokeWidth: 5.0,
                                      ),
                                    ),
                                    Positioned.fill(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        _myWeeklyRanking.isNotEmpty
                                            ? '10%'
                                            : '50%',
                                        style: bodyText1.copyWith(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    )),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  // if (_myWeeklyRanking.isNotEmpty || _myMonthlyRanking.isNotEmpty)

                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50.0),
                      Text(
                        _text,
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        'Inviting friends to join Business Bosses.',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/one.png'),
                      Text(
                        'Networking and making new connections.',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/two.png'),
                      Text(
                        'Commenting and liking users post/content.',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/three.png'),
                      Text(
                        'Creating post/content in your profile and community.',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Image.asset('assets/images/four.png'),
                      Text(
                        'Refer users to your connection.',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/five.png'),
                    ],
                  ),

                  const SizedBox(height: 24.0),
                  RichText(
                    text: TextSpan(
                      style: bodyText1,
                      children: [
                        TextSpan(
                          text: 'Tips:',
                          style: bodyText1.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' The higher your ranking, the easier to be discovered by other users.',
                          style: bodyText1.copyWith(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50.0),
                ],
              ),
            )
          ],
        ),
      ),
    );

    // return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Profile Analytics'),
    //       actions: [
    //         IconButton(
    //           onPressed: () =>
    //               navigateTo(context, routeName: RankingInfoScreen.routeName),
    //           icon: Icon(Icons.info_outline),
    //         ),
    //       ],
    //     ),
    //     body: _isLoading
    //         ? CircularProgressIndicator.adaptive()
    //         : Text('W10: ${_top10WeeklyRanking.length},'
    //             ' M25: ${_top25MonthlyRanking.length}, ')
    //     /*ListView.builder(
    //     itemCount: _weeklyRanking.length,
    //     itemBuilder: (context, i) {
    //       return ListTile(
    //         title: Text(
    //             'points: ${_weeklyRanking[i].point} \npercentage: ${_weeklyRanking[i].totalPercentage.toStringAsFixed(2)}% \nTotal point: $allPoints'),
    //         subtitle: Column(
    //           children: [
    //             Text(
    //                 'Time: ${TimeFormat.formatString(_weeklyRanking[i].timestamp)}'),
    //           ],
    //         ),
    //       );
    //     },
    //   ),*/
    //     );
  }

  final String _text = 'Your ranking is based on:\n';

  final List<UserModel> _allUsers = [];
  final List<PostModel> _allPosts = [];
  final List<Referrals> _allReferrals = [];

  Future<void> _fetchAllUsers() async {
    // MyResponse res = await _firebase.fetchAllNodes(path: Constants.USERS);
    // if (res.success) {
    //   List<MyUser> users = _firebase.toUserList(snapshot: res.data);
    //   _allUsers = users;
    //   debugPrint('Users fetch');
    // } else {
    //   showSnackBar(context, message: res.message);
    // }
  }

  Future<void> _fetchAllReferrals() async {
    // MyResponse res = await _firebase.fetchAllNodes(path: Constants.INVITES);
    // if (res.success) {
    //   List<Referrals> items = _firebase.toReferralList(snapshot: res.data);
    //   _allReferrals = items;
    //   debugPrint('Invites fetch');
    // } else {
    //   showSnackBar(context, message: res.message);
    // }
  }

  Future<void> _fetchAllPosts() async {
    // MyResponse res = await _firebase.fetchAllNodes(path: Constants.POSTS);
    // if (res.success) {
    //   List<MyPost> items = _firebase.toJustSortPostList(snapshot: res.data);
    //   _allPosts = items;
    //   debugPrint('Post fetch');
    // } else {
    //   showSnackBar(context, message: res.message);
    // }
  }

  int allPoints = 0;

  // List<Ranking> _calculateRanking(num timestamp) {
  //   List<Ranking> rankingList = [];
  //   for (UserModel user in _allUsers) {
  //
  //     // List<MyConnect> _uConnects = user.connects.where((element) {
  //     //   bool isWithInTime =
  //     //       DateTime.now().millisecondsSinceEpoch - (element?.timestamp ?? 0) <=
  //     //           timestamp;
  //     //   return isWithInTime;
  //     // }).toList();
  //     List<PostModel> _uPost = _allPosts.where((element) {
  //       bool isWithInTime =
  //           DateTime.now().millisecondsSinceEpoch - element.timestamp <=
  //               timestamp;
  //       return isWithInTime && element.postId == user.uid;
  //     }).toList();
  //     List<Comment> comments = [];
  //     for (PostModel p in _allPosts) {
  //       comments.addAll(
  //           p.comments.where((element) => element.uid == user.uid).toList());
  //     }

  //     debugPrint(
  //         '_MyRankingScreenState._calculateRanking: _uPost ${_uPost.length}');

  //     Referrals uReferrals = _allReferrals.firstWhere(
  //         (element) => element.uid == user.uid,
  //         orElse: () => Referrals());
  //     List<Invite> uInvites = uReferrals.usedBy?.where((element) {
  //       bool isWithInTime =
  //           DateTime.now().millisecondsSinceEpoch - element.timestamp <=
  //               timestamp;
  //       return isWithInTime;
  //     })?.toList();
  //     debugPrint(
  //         '_MyRankingScreenState._calculateRanking: uInvites ${uInvites.length}');
  //     num point = /*(_uConnects?.length ?? 0) +*/
  //         (_uPost?.length ?? 0) +
  //             (uInvites?.length ?? 0) +
  //             (comments?.length ?? 0);
  //     allPoints += point;

  //     rankingList.add(Ranking(
  //       uid: user.uid,
  //       point: point,
  //       timestamp: DateTime.now().millisecondsSinceEpoch,
  //     ));
  //     debugPrint('Calculating...');
  //   }
  //   for (int i = 0; i < rankingList.length; i++) {
  //     rankingList[i].percentage = rankingList[i].point * 100 / allPoints;
  //   }
  //   rankingList.sort((b, a) => a.point?.compareTo(b?.point) ?? 0);
  //   return rankingList;
  // }

  // List<Ranking> _toRankUsers(num val, List<Ranking> allRankingUsers) {
  //   List<Ranking> _validRankingUsers =
  //       allRankingUsers.where((element) => element.point > 0).toList();
  //   int rankedLength = _validRankingUsers.length * val ~/ 100;
  //   return _validRankingUsers.take(rankedLength).toList();
  // }

  // Map<String, dynamic> toRankingMap(List<Ranking> rankingUsers) {
  //   Map<String, dynamic> map = {};
  //   // MyResponse res = _firebase
  //   // for (Ranking r in rankingUsers) {
  //   //   map[r.uid] = r.toMap();
  //   // }
  //   // return map;
  // }
}
