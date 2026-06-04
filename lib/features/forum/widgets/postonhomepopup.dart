import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_forum_screen.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/request_details_sheet.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../utils/theme/theme.dart';

/// Boss Up Challenge Pop Up
class PostonhomePopUp extends StatefulWidget {
  final ForumModel forum;
  final bool isBossUp;

  /// Boss Up Challenge Pop Up
  const PostonhomePopUp(
      {super.key, required this.forum, required this.isBossUp});

  @override
  State<PostonhomePopUp> createState() => _PostonhomePopUpState();
}

class _PostonhomePopUpState extends State<PostonhomePopUp> {
  late final MatchController matchController;
  late final BuyerRequestController buyerRequestController;
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Safely initialize controllers
    matchController = Get.isRegistered<MatchController>()
        ? Get.find<MatchController>()
        : Get.put(MatchController());
    buyerRequestController = Get.isRegistered<BuyerRequestController>()
        ? Get.find<BuyerRequestController>()
        : Get.put(BuyerRequestController());

    // Fetch fresh matches when success screen is shown
    matchController.fetchMatches();
    buyerRequestController.initBuyerRequests();
  }

  void _sharePost() {
    String message =
        'Vote for ${widget.forum.user?.username ?? 'Business Bosses'}\'s post on Business Bosses\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(widget.forum.forumId, 'forum');
    socialShare(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (widget.isBossUp) {
                      Get.to(() => const AllCommunitiesScreen(
                            initialTabIndex: 0,
                          ));
                    } else {
                      Get.off(() => const AllForumScreen());
                    }
                  },
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.close)),
                )
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE8F5E9),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Success!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your post is now live. Here are matched opportunities for you',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4B5563),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Obx(() {
              if (matchController.isLoading.value ||
                  buyerRequestController.loading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final String? userIndustry = profileController.myProfile.industry;

              // Combine results
              List<dynamic> combinedResults = <dynamic>[];

              // 1. Add People Matches
              List<UserModel> people = matchController.matchList.toList();
              combinedResults.addAll(people.take(2));

              // 2. Add Buyer Requests
              List<BuyerRequestModel> requests =
                  buyerRequestController.buyerRequests.where((BuyerRequestModel r) {
                if (userIndustry == null || userIndustry.isEmpty) return true;
                return r.category.toLowerCase().trim() ==
                    userIndustry.toLowerCase().trim();
              }).toList();

              if (requests.isEmpty) {
                requests = buyerRequestController.buyerRequests.take(2).toList();
              }

              combinedResults.addAll(requests.take(2));

              final List<dynamic> finalDisplay = combinedResults.take(3).toList();

              if (finalDisplay.isEmpty) {
                return Center(
                  child: Text(
                    'No matching opportunities found yet.',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${finalDisplay.length} Matches found',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...finalDisplay.map((dynamic item) {
                    if (item is UserModel) {
                      return _buildUserMatchCard(item);
                    } else if (item is BuyerRequestModel) {
                      return _buildRequestMatchCard(item);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              );
            }),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _sharePost,
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Share to get more votes',
                        style: TextStyle(
                          color: Color(0xFF1F2937),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/svgs/nexticon.svg',
                        colorFilter: const ColorFilter.mode(
                            Color(0xFF1F2937), BlendMode.srcIn),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.marketPlace);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColorLT,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Go Home',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMatchCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: () {
          Get.toNamed(Routes.publicProfile, arguments: user);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: const Icon(LucideIcons.user, color: Colors.blue, size: 20),
        ),
        title: Text(
          user.name ?? user.username,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          user.bio ?? user.industry ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: const Icon(LucideIcons.chevronRight, size: 16),
      ),
    );
  }

  Widget _buildRequestMatchCard(BuyerRequestModel request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: () {
          RequestDetailsSheet.show(context, request);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withOpacity(0.1),
          child: const Icon(LucideIcons.shoppingCart,
              color: Colors.orange, size: 20),
        ),
        title: Text(
          request.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          request.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: const Icon(LucideIcons.chevronRight, size: 16),
      ),
    );
  }
}
