// ignore_for_file: must_be_immutable

import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/widgets/likecommentandcointile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_polls/flutter_polls.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';
import '../../../common/generic_slider.dart';
import '../../../common/models/my_response.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../functions/my_native_functions.dart';
import '../../../utils/theme/theme.dart';
import '../../../analytics/presentation/analysescreen.dart';
import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';
import '../widgets/all_images_item.dart';
import '../widgets/create_post_user_tile.dart';
import 'boost_post_screen.dart';

// ignore: public_member_api_docs
class PostDetailsScreen extends StatefulWidget {
  // final PostModel post;
  const PostDetailsScreen({Key? key}) : super(key: key);

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  PostModel post = Get.arguments;

  @override
  void initState() {
    super.initState();
  }

  // ignore: public_member_api_docs
  @override
  Widget build(BuildContext context) {
    // if (Get.arguments == null) {
    //   Get.back();
    // }

    // PostModel? post;
    // String? postId;
    // int? postIndex;
    ProfileController profileController = Get.find();
    // ignore: unused_local_variable
    HomeController controller = Get.find();
    Map<String, int> voteCounts = countVotes(post);
    bool hasVoted = userHasVoted(post, profileController);
    String? selectedVote = userSelectedOption(post, profileController);
// Create PollOption list based on the vote counts
    List<PollOption> pollOptions = List.generate(
      post.options != null ? post.options!.length : 0,
      (int index) {
        String option = post.options![index];
        int votes = voteCounts[option] ?? 0;

        return PollOption(
          id: option,
          title: Text(option),
          votes: votes,
        );
      },
    );
    Future<void> repost() async {
      controller.postRepost(profileController.myProfile.uid, post.postId,
          'post', post.timestamp, post.user!.uid, post.oldtimestamp);
    }

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
          title: const Text('View Post'),
        ),
        // ignore: unnecessary_null_comparison
        body: post == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: ColoredBox(color: backgroundcolorinterface),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (post.reposts?.length != null &&
                        post.reposts?.length != 0) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/repost.svg',
                              height: 13,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            post.reposts?.contains(
                                        profileController.myProfile.uid) ==
                                    true
                                ? Row(
                                    children: [
                                      const Text(
                                        'You Reposted',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 3.0,
                                        height: 3.0,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  )
                                : Container(),
                            GestureDetector(
                              onTap: () {},
                              child: Text(
                                '${post.reposts?.length.toString()} Reposts',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: CreatePostUserTile(
                        user: post.user,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 1,
                      child: ColoredBox(color: backgroundcolorinterface),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: post.promote != null && post.promote == true
                          ? Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 5),
                              decoration: const BoxDecoration(
                                color: backgroundcolorinterface,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: TextWidget(
                                text: post.approved!
                                    ? 'Ongoing Ad'
                                    : 'Pending Ad',
                                fontWeight: FontWeight.w700,
                                size: 17,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: post.title.isNotEmpty
                          ? Linkify(
                              text: post.title,
                              style: bodyText1.copyWith(
                                  fontWeight: FontWeight.normal),
                              onOpen: (LinkableElement linkableElement) =>
                                  _onUrlClick(context, linkableElement),
                              options: const LinkifyOptions(humanize: false),
                              linkStyle: bodyText1.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal),
                            )
                          : null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (post.isPolled!)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: FlutterPolls(
                          pollId: post.postId,
                          onVoted:
                              (PollOption pollOption, int newTotalVotes) async {
                            controller.pollVote(post, pollOption.id!);
                            setState(() {
                              hasVoted = true;
                              selectedVote = pollOption.id;
                            });
                            return true;
                          },
                          pollTitle: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '',
                              style: TextStyle(
                                fontSize: 0,
                              ),
                            ),
                          ),
                          hasVoted: hasVoted,
                          userVotedOptionId: selectedVote,
                          pollOptionsSplashColor: Colors.white,
                          votedProgressColor: Colors.grey.withOpacity(0.3),
                          votedBackgroundColor: Colors.grey.withOpacity(0.2),
                          pollOptions: pollOptions,
                          votedCheckmark: const Icon(
                            Icons.check_circle,
                            color: Colors.black,
                            weight: 18,
                            size: 18,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: post.videoUrl != null && post.videoUrl!.isNotEmpty
                          ? AllImagesItem(
                              post.images!,
                              post: post,
                              text: post.title,
                              isVideo: true,
                              // i: postIndex!,
                            )
                          : post.images != null && post.images!.isNotEmpty
                              ? Container(
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: GenericSlider(
                                    images: post.images!,
                                  ),
                                )
                              : null,
                    ),
                    PostInteractionsWidget(
                      post: post,
                      profileController: profileController,
                      sharePost: _sharePost,
                      repost: repost,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 1,
                      child: ColoredBox(color: backgroundcolorinterface),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: post.user!.uid ==
                                    profileController.myProfile.uid
                                ? post.promote != null && post.promote == true
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: GestureDetector(
                                          onTap: () {
                                            navigateTo(context,
                                                routeName:
                                                    AnalyserScreen.routeName);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: primaryColorLT,
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                TextWidget(
                                                  text: 'View Analytics',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 10.0,
                                                ),
                                                Icon(
                                                  Icons
                                                      .stacked_line_chart_rounded,
                                                  color: Colors.white,
                                                  size: 23,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(150,
                                                50) // put the width and height you want
                                            ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            // ignore: always_specify_types
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  BoostPost(
                                                      postId: post.postId),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          // ignore: always_specify_types
                                          children: [
                                            const Text(
                                              '  Boost Post   ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            SvgPicture.asset(
                                              'assets/svgs/rocket.svg',
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ))
                                : Container()),
                      ),
                    )
                  ])));
  }

  Future<void> _onUrlClick(
      BuildContext context, LinkableElement linkableElement) async {
    MyResponse res = await MyNativeFunctions.onUrlLaunch(linkableElement.url);
    if (!res.success) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
  }

  void _sharePost() {
    String message =
        'Have a look at ${post.user!.username}\'s post on Business Bosses\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(post.postId, 'post');
    socialShare(message);
  }

  bool userHasVoted(PostModel post, ProfileController profileController) {
    String userId = profileController.myProfile.uid;
    return post.isPolled! &&
        post.pollvotes != null &&
        post.pollvotes!
            .any((Map<String, dynamic> vote) => vote['userId'] == userId);
  }

// Get the selected option if the user has voted
  String? userSelectedOption(
      PostModel post, ProfileController profileController) {
    HomeController controller = Get.find();
    String userId = profileController.myProfile.uid;
    String? selectedVote = controller.getSelectedVote(post.postId);

    if (selectedVote != null) {
      return selectedVote;
    }
    // Check if the post is a poll and if pollvotes exist and is not empty
    if (post.isPolled == true &&
        post.pollvotes != null &&
        post.pollvotes!.isNotEmpty) {
      // Find the vote corresponding to the user ID
      Map<String, dynamic>? userVote = post.pollvotes!.firstWhereOrNull(
        (Map<String, dynamic> vote) => vote['userId'] == userId,
      );

      // Check if userVote is not null and contains the 'selectedOption' key
      if (userVote != null && userVote.containsKey('selectedOption')) {
        return userVote['selectedOption'] as String?;
      }
    }

    return null; // Return null if the user's selected option is not found or if it's not a poll
  }

  Map<String, int> countVotes(PostModel post) {
    Map<String, int> voteCounts = <String, int>{};

    if (post.isPolled! && post.pollvotes != null) {
      for (Map<String, dynamic> vote in post.pollvotes!) {
        String selectedOption = vote['selectedOption'];
        voteCounts[selectedOption] = (voteCounts[selectedOption] ?? 0) + 1;
      }
    }

    return voteCounts;
  }
}
