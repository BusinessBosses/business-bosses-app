// ignore_for_file: must_be_immutable

import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/posts/widgets/PostIntereactions.dart';
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
  final PostModel post;
  const PostDetailsScreen({super.key, required this.post});

  @override
  State<PostDetailsScreen> createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  // PostModel post = Get.arguments;

  // late PostModel post;
  late ProfileController profileController;
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    // post = Get.arguments;
    profileController = Get.find();
    controller = Get.find();
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
    Map<String, int> voteCounts = countVotes(widget.post);
    bool hasVoted = userHasVoted(widget.post, profileController);
    String? selectedVote = userSelectedOption(widget.post, profileController);
// Create PollOption list based on the vote counts
    List<PollOption> pollOptions = List.generate(
      widget.post.options != null ? widget.post.options!.length : 0,
      (int index) {
        String option = widget.post.options![index];
        int votes = voteCounts[option] ?? 0;

        return PollOption(
          id: option,
          title: Text(option),
          votes: votes,
        );
      },
    );
    Future<void> repost() async {
      controller.postRepost(
          profileController.myProfile.uid,
          widget.post.postId,
          'post',
          widget.post.timestamp,
          widget.post.user!.uid,
          widget.post.oldtimestamp);
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
        body: widget.post == null
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
                    if (widget.post.reposts?.length != null &&
                        widget.post.reposts!.isNotEmpty) ...<Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/repost.svg',
                              height: 13,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            widget.post.reposts?.contains(
                                        profileController.myProfile.uid) ==
                                    true
                                ? Row(
                                    children: <Widget>[
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
                                '${widget.post.reposts?.length.toString()} Reposts',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: CreatePostUserTile(
                        user: widget.post.user,
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
                      child: widget.post.promote != null &&
                              widget.post.promote == true
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
                                text: widget.post.approved!
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
                      child: widget.post.title.isNotEmpty
                          ? Linkify(
                              text: widget.post.title,
                              style: bodyText2.copyWith(
                                  fontWeight: FontWeight.normal),
                              onOpen: (LinkableElement linkableElement) =>
                                  _onUrlClick(context, linkableElement),
                              options: const LinkifyOptions(humanize: false),
                              linkStyle: bodyText2.copyWith(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.normal),
                            )
                          : null,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.post.isPolled!)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: FlutterPolls(
                          pollId: widget.post.postId,
                          onVoted:
                              (PollOption pollOption, int newTotalVotes) async {
                            controller.pollVote(widget.post, pollOption.id!);
                            setState(() {
                              hasVoted = true;
                              selectedVote = pollOption.id;
                            });
                            print(controller.votes);
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
                      child: widget.post.videoUrl != null &&
                              widget.post.videoUrl!.isNotEmpty
                          ? AllImagesItem(
                              widget.post.images!,
                              post: widget.post,
                              text: widget.post.title,
                              isVideo: true,
                              // i: postIndex!,
                            )
                          : widget.post.images != null &&
                                  widget.post.images!.isNotEmpty
                              ? Container(
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: GenericSlider(
                                    images: widget.post.images!,
                                  ),
                                )
                              : null,
                    ),
                    // PostInteractionsWidget(
                    //   post: post,
                    //   profileController: profileController,
                    //   sharePost: _sharePost,
                    //   repost: repost,
                    // ),
                    PostInteractions(
                      post: widget.post,
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
                            child: widget.post.user!.uid ==
                                    profileController.myProfile.uid
                                ? widget.post.promote != null &&
                                        widget.post.promote == true
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
                                                      postId:
                                                          widget.post.postId),
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
        'Have a look at ${widget.post.user!.username}\'s post on Business Bosses\n'
        'https://vm.businessbosses.co.uk/share/post';
    logEvent(widget.post.postId, 'post');
    socialShare(message);
  }

  bool userHasVoted(PostModel post, ProfileController profileController) {
    String userId = profileController.myProfile.uid;
    String? selectedVote = controller.getSelectedVote(post.postId);
    if (selectedVote != null) {
      return true;
    }
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
