import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:business_bosses_v2/features/posts/presentation/boost_post_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/post_details_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

/// Pick one of your own posts to boost. Reached from "Boost Visibility" on
/// the For you tab.
class BoostPostPickerScreen extends StatefulWidget {
  const BoostPostPickerScreen({super.key});

  @override
  State<BoostPostPickerScreen> createState() => _BoostPostPickerScreenState();
}

class _BoostPostPickerScreenState extends State<BoostPostPickerScreen> {
  final ProfileController _profileController = Get.find<ProfileController>();

  @override
  void initState() {
    super.initState();
    if (_profileController.posts.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _profileController.fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Boost a Post',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: GetBuilder<ProfileController>(
        builder: (ProfileController controller) {
          final List<PostModel> posts = controller.posts;

          if (controller.isLoading.value && posts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (posts.isEmpty) {
            return _buildEmptyState();
          }

          return Column(
            children: <Widget>[
              _buildCreateNewButton(),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 14, 15, 4),
                child: Text(
                  'OR',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Text(
                  'Choose an existing post below to reach more people',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => controller.fetchData(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) =>
                        _buildPostRow(posts[index]),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Primary action: write a brand new post and boost that.
  Widget _buildCreateNewButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColorLT,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => Get.to(() => const CreatePostScreen(fromBoost: true)),
          child: const Text(
            'Create a new boost post',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildPostRow(PostModel post) {
    final bool isBoosted = post.promote == true;
    final String? image =
        (post.images != null && post.images!.isNotEmpty) ? post.images![0] : null;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: image != null
                ? NetworkImageWithPlaceHolder(
                    imageUrl: image,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 56,
                    height: 56,
                    color: backgroundcolorinterface,
                    child: const Icon(Icons.article_outlined,
                        color: Colors.black38),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  post.title.trim().isEmpty ? 'Untitled post' : post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // Read the post before committing to boosting it.
                GestureDetector(
                  onTap: () => Get.to(
                    () => PostDetailsScreen(post: post),
                  ),
                  child: const Text(
                    'Tap to View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isBoosted)
            const Text(
              'Boosted',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.green,
              ),
            )
          else
            GestureDetector(
              onTap: () => Get.to(
                () => BoostPost(postId: post.postId, postTitle: post.title),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const <Widget>[
                  Text(
                    'Boost',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: primaryColorLT,
                    ),
                  ),
                  Icon(Icons.chevron_right,
                      color: primaryColorLT, size: 18),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.campaign_outlined, size: 60, color: Colors.grey),
            const SizedBox(height: 15),
            const Text(
              'You have no posts to boost yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Create a post first, then boost it to reach more people.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColorLT,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () =>
                  Get.to(() => const CreatePostScreen(fromBoost: true)),
              child: const Text(
                'Create a post',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
