import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/requests_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/request_details_sheet.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class SuccessScreen extends StatefulWidget {
  final VoidCallback onCreateAnother;
  final String? postType;

  const SuccessScreen(
      {super.key, required this.onCreateAnother, this.postType});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final MatchController matchController = Get.find<MatchController>();
  final BuyerRequestController buyerRequestController =
      Get.find<BuyerRequestController>();
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    // Fetch fresh matches when success screen is shown
    matchController.fetchMatches();
    buyerRequestController.initBuyerRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
            Icons.check_circle, // Solid check circle
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Your post is now live. Here are matched opportunities for you',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4B5563),
            ),
            textAlign: TextAlign.center,
          ),
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

          final String postType = widget.postType ?? 'Promote My Business';

          // The match source + items shown depend on the type of post.
          final String matchSourceLabel = _matchSourceLabel(postType);
          final List<dynamic> finalDisplay = _matchesForPostType(postType);

          if (finalDisplay.isEmpty) {
            return Center(
              child: Text(
                'No matches found yet.',
                style: TextStyle(color: Colors.grey[600]),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                matchSourceLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${finalDisplay.length} matches found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
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
        const SizedBox(height: 24),
      ],
    );
  }

  /// The label describing where the matches come from, based on the post type.
  String _matchSourceLabel(String postType) {
    switch (postType) {
      case 'Need a Product or Service':
        return 'Matches from Sellers listing';
      case 'Find a Partner':
        return 'Matches from Sellers/partner with me';
      case 'Promote My Business':
      case 'Sell a Product or Service':
      default:
        return 'Matches from buyer request';
    }
  }

  /// Returns the relevant matches for the given post type:
  /// - Promote / Sell  -> people who posted buyer requests
  /// - Need            -> sellers (suppliers) listings
  /// - Find a Partner  -> partners willing to partner up
  List<dynamic> _matchesForPostType(String postType) {
    switch (postType) {
      case 'Find a Partner':
        return matchController.partners.take(3).toList();
      case 'Need a Product or Service':
        return matchController.suppliers.take(3).toList();
      case 'Promote My Business':
      case 'Sell a Product or Service':
      default:
        final String? userIndustry = profileController.myProfile.industry;
        // Prefer buyer requests in the user's own industry, fall back to all.
        List<BuyerRequestModel> requests =
            buyerRequestController.buyerRequests.where((BuyerRequestModel r) {
          if (userIndustry == null || userIndustry.isEmpty) return true;
          return r.category.toLowerCase().trim() ==
              userIndustry.toLowerCase().trim();
        }).toList();

        if (requests.isEmpty) {
          requests = buyerRequestController.buyerRequests.toList();
        }
        return requests.take(3).toList();
    }
  }

  Widget _buildUserMatchCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: () {
          Get.toNamed(Routes.publicProfile, arguments: user);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withValues(alpha: 0.1),
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
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: () {
          RequestDetailsSheet.show(context, request);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.orange.withValues(alpha: 0.1),
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
