import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/common/widgets/gallery_screen.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/aipromote/ai_promote_sheet.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/live_event/presentation/create_event.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/buyer_requests_form.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_poll_screen.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart'
    as custom_preview;
import 'package:business_bosses_v2/features/posts/widgets/text_input.dart';
import 'package:business_bosses_v2/features/posts/widgets/user_details_widget.dart';
import 'package:business_bosses_v2/features/premium/unlockedfeatures.dart';
import 'package:business_bosses_v2/functions/unfocus_keyboard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';

/// CREATE POST SCREEN
class CreatePostScreen extends StatefulWidget {
  final String? postId;
  final String? post;
  final List<String?>? images;
  final PostModel? postDetail;
  final bool? isGrow;

  /// SCREEN CONSTRUCTOR
  const CreatePostScreen(
      {super.key,
      this.postId,
      this.post,
      this.images,
      this.postDetail,
      this.isGrow});
  static const String routeName = '/create-post';

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  dynamic _overlayEntry;
  final DetectableTextEditingController _titleCtrl =
      DetectableTextEditingController(
    regExp: detectionRegExp(hashtag: false)!,
  );
  // final TextEditingController _ytCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _ytUrl;
  final ProfileController _profileController = Get.find();
  final CreatePostController _createPostController =
      Get.put(CreatePostController());
  final Map<String, dynamic>? arguments = Get.arguments;
  String? sharemessage;
  String? title;
  String? livedata;
  DonationModel? donationModel;
  ForumModel? forumModel;
  MarketModel? marketModel;

  void onDetectionFinished() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    // if (widget.pos != null) {
    // _createPostController.imageFileList
    //     .addAll(widget.images!.map((String? image) => XFile(image!)));

    sharemessage = arguments?['sharemessage'];
    title = arguments?['title'];
    livedata = arguments?['livedata'];

    if (arguments?['donationdata'] != null) {
      final dynamic donationData = arguments?['donationdata'];

      donationModel = donationData;
    }
    if (arguments?['forumdata'] != null) {
      final dynamic forumData = arguments?['forumdata'];

      forumModel = forumData;
    }
    if (arguments?['marketdata'] != null) {
      final dynamic marketData = arguments?['marketdata'];

      marketModel = marketData;
    }

    if (widget.isGrow == true) {
      _createPostController.shouldPromote.value = true;
    }

    if (widget.postId != null) {
      _titleCtrl.text = widget.post!;
    } else {
      title != null
          ? _titleCtrl.text = '$sharemessage\n\nTitle: $title'
          : _titleCtrl.text == '';
    }
    _createPostController.initializePostEditImage(widget.postDetail?.images);
    // }
  }

  // Function to show the bottom sheet with options
  void _showAddContentBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Create Poll Option
              _buildBottomSheetItem(
                icon: LucideIcons.barChart3,
                title: 'Create a Poll',
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => CreatePollScreen());
                },
              ),

              // Create Event Option
              _buildBottomSheetItem(
                icon: LucideIcons.calendar,
                title: 'Create an Event',
                onTap: () {
                  Navigator.pop(context);

                  Get.to(() => CreateEvent());
                },
              ),

              // Free Promotion Option
              _buildBottomSheetItem(
                icon: LucideIcons.coins,
                title: 'Create Buyer Request',
                onTap: () {
                  Navigator.pop(context);

                  Get.to(() => AddBuyerRequests());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showPromoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => AIPromoteSheet(),
    );
  }

  // Helper method to build bottom sheet items
  Widget _buildBottomSheetItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: primaryColorLT),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(
      builder: (CreatePostController controller) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop) return;
          if (_overlayEntry != null) {
            _overlayEntry?.remove();
            _overlayEntry = null;
            setState(() {});
          } else {
            Get.back();
            setState(() {});
          }
        },
        child: Form(
          key: _formKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: widget.isGrow == true
                ? null
                : AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
                    centerTitle: true,
                    title: widget.postId == null
                        ? const Text('Post content, discussion, etc')
                        : const Text('Update Discussion'),
                  ),
            body: GestureDetector(
              onTap: () => unFocusKeyboard(context),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    if (widget.isGrow == true)
                      const SizedBox(
                        height: 10,
                      ),
                    if (widget.isGrow == true)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: FeatureTile(
                          feature: FeatureItem(
                            iconPath: 'assets/svgs/rocketblack.svg',
                            caption: 'Boost Your Post',
                            subtext:
                                'Reach a wider audience and get more views',
                            color: Colors.grey
                                .withValues(alpha: 0.2), // Changed color
                          ),
                        ),
                      ),
                    if (widget.isGrow != true)
                      const SizedBox(
                        width: double.infinity,
                        height: 20,
                        child: ColoredBox(color: backgroundcolorinterface),
                      ),
                    if (widget.isGrow == true)
                      const SizedBox(
                        height: 10,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          if (widget.isGrow != true) const UserDetailsWidget(),
                          TextInput(
                            onDetectionTyped: (String text) {},
                            titleController: _titleCtrl,
                            onDetectionFinished: onDetectionFinished,
                          ),

                          // Plus sign button below text area
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    title != null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              if (controller
                                                      .imageFileList.length <
                                                  5) {
                                                controller.onPickImage(
                                                    GalleryType.images,
                                                    isUpdating: false);
                                              } else {
                                                showSnackbar(
                                                    message:
                                                        'You can only upload up to 5 images.');
                                              }
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                const TextWidget(
                                                  text: 'Add image',
                                                  fontWeight: FontWeight.w700,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/svgs/addimagepost.svg',
                                                  height: 11,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text('or'),
                                    ),
                                    Container(
                                        decoration: BoxDecoration(
                                            color: backgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                isVisible = !isVisible;
                                              });
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                const TextWidget(
                                                  text: 'Add Youtube link',
                                                  fontWeight: FontWeight.w700,
                                                  size: 15,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                SvgPicture.asset(
                                                  'assets/svgs/yt.svg',
                                                  height: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: _showAddContentBottomSheet,
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                          color: primaryColorLT,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          LucideIcons.plus,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: Visibility(
                                    visible: isVisible,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: TextFormField(
                                        onChanged: (String val) {
                                          _ytUrl = val;
                                          setState(() {});
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Paste a Youtube Video link here',
                                          border: InputBorder.none,
                                          hintStyle: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: textColor.withValues(
                                                    alpha: 0.2),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                    if (widget.isGrow != true)
                      const SizedBox(
                        height: 10,
                      ),

                    // if (controller.imageFileList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 10),
                      child: custom_preview.Preview(
                        controller: controller,
                        isUpdating: widget.postDetail != null,
                      ),
                    ),

                    if (widget.isGrow == true)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, top: 0, bottom: 10),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: ProCustomButton(
                            color: primaryColorLT,
                            text: 'Post',
                            onPressed: () async {
                              _formKey.currentState!.save();
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              if (controller.imageFileList.length > 5) {
                                /// If the user has selected more than five images, show an error message
                                Get.snackbar('Error',
                                    'You can select up to five images.');
                              } else {
                                /// Show bottom sheet for boost option
                                _showBoostBottomSheet(controller);
                              }
                            },
                            loading: controller.loading.value,
                          ),
                        ),
                      ),

                    if (widget.isGrow != true)
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: CustomButton(
                          buttonType: ButtonType.elevated,
                          label: widget.postId == null ? 'Post' : 'Update Post',
                          onPressed: () async {
                            _formKey.currentState!.save();
                            if (!_formKey.currentState!.validate()) return;

                            if (controller.imageFileList.length > 5) {
                              /// If the user has selected more than five images, show an error message
                              Get.snackbar(
                                  'Error', 'You can select up to five images.');
                            } else {
                              /// Show bottom sheet for boost option
                              _showBoostBottomSheet(controller);
                            }
                          },
                          isProcessing: controller.loading.value,
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/report.svg',
                            colorFilter: const ColorFilter.mode(
                                primaryColorLT, BlendMode.srcIn),
                            height: 18,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const MarketplaceScreen());
                            },
                            child: const Row(
                              children: <Widget>[
                                Text(
                                  'To sell your products and services, list on',
                                  style:
                                      TextStyle(color: textColor, fontSize: 12),
                                ),
                                Text(
                                  ' Marketplace',
                                  style: TextStyle(
                                      color: primaryColorLT,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: primaryColorLT,
                                  size: 15,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBoostBottomSheet(CreatePostController controller) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/svgs/rocket.svg',
                        colorFilter:
                            const ColorFilter.mode(textColor, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Boost Post',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Reach a wider audience and get more views',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Do you want to boost this post/listing?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      _createPostController.shouldPromote.value = true;
                      if (widget.postId == null) {
                        await controller.createPost(<String, dynamic>{
                          'livedata': livedata,
                          'donationId': donationModel?.id,
                          'donation': donationModel?.toMap(),
                          'forumId': forumModel?.forumId,
                          'forum': forumModel?.toMap(),
                          'marketId': marketModel?.marketId,
                          'market': marketModel?.toMap(),
                          'title': _titleCtrl.text.trim(),
                          'ytUrl': _ytUrl,
                          'images': _ytUrl != null && _ytUrl != ''
                              ? 'https://api.businessbosses.co.uk/appfiles/1698854755_13_download_(1).png'
                              : null, // Set images to null if _ytUrl is null or empty
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                        }, _profileController);
                      } else {
                        await controller.onEditPost(
                            widget.postDetail, _titleCtrl.text.trim());
                      }
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      _createPostController.shouldPromote.value = false;
                      if (widget.postId == null) {
                        await controller.createPost(<String, dynamic>{
                          'livedata': livedata,
                          'donationId': donationModel?.id,
                          'donation': donationModel?.toMap(),
                          'forumId': forumModel?.forumId,
                          'forum': forumModel?.toMap(),
                          'marketId': marketModel?.marketId,
                          'market': marketModel?.toMap(),
                          'title': _titleCtrl.text.trim(),
                          'ytUrl': _ytUrl,
                          'images': _ytUrl != null && _ytUrl != ''
                              ? 'https://api.businessbosses.co.uk/appfiles/1698854755_13_download_(1).png'
                              : null, // Set images to null if _ytUrl is null or empty
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                        }, _profileController);
                      } else {
                        await controller.onEditPost(
                            widget.postDetail, _titleCtrl.text.trim());
                      }
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
