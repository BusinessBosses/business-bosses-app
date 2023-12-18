import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/common/widgets/gallery_screen.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
import 'package:business_bosses_v2/features/posts/widgets/promote_section.dart';
import 'package:business_bosses_v2/features/posts/widgets/text_input.dart';
import 'package:business_bosses_v2/features/posts/widgets/user_details_widget.dart';
import 'package:business_bosses_v2/functions/unfocus_keyboard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';

/// CREATE POST SCREEN
class CreatePostScreen extends StatefulWidget {
  final String? postId;
  final String? post;
  final List<String?>? images;
  final PostModel? postDetail;

  /// SCREEN CONSTRUCTOR
  const CreatePostScreen(
      {Key? key, this.postId, this.post, this.images, this.postDetail})
      : super(key: key);
  static const String routeName = '/create-post';

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  dynamic _overlayEntry;
  final TextEditingController _titleCtrl = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreatePostController>(
      builder: (CreatePostController controller) => WillPopScope(
        onWillPop: () async {
          if (_overlayEntry != null) {
            _overlayEntry?.remove();
            _overlayEntry = null;
            setState(() {});
            return false;
          } else {
            Get.back();
            setState(() {});
            return false;
          }
        },
        child: Form(
          key: _formKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              centerTitle: true,
              title: widget.postId == null
                  ? const Text('Create Post')
                  : const Text('Update Post'),
            ),
            body: GestureDetector(
              onTap: () => unFocusKeyboard(context),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      width: double.infinity,
                      height: 20,
                      child: ColoredBox(color: backgroundcolorinterface),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: <Widget>[
                          const UserDetailsWidget(),
                          TextInput(
                            onDetectionTyped: (String text) {},
                            titleController: _titleCtrl,
                            onDetectionFinished: onDetectionFinished,
                          ),
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
                              children: [
                                Row(
                                  children: [
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

                                                // const Text(
                                                //   'Max file size for images is 10Mb',
                                                //   style: TextStyle(fontSize: 11, color: Colors.red),
                                                // )
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

                                                // const Text(
                                                //   'Max file size for images is 10Mb',
                                                //   style: TextStyle(fontSize: 11, color: Colors.red),
                                                // )
                                              ],
                                            ),
                                          ),
                                        )),
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
                                        // validator: (value) {
                                        //   if (value == null || value.isEmpty) {
                                        //     return '';
                                        //   }
                                        //   return null;
                                        // },
                                        // textInputAction: TextInputAction.done,
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
                                                color:
                                                    textColor.withOpacity(0.2),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),

                    // if (controller.imageFileList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Preview(
                        controller: controller,
                        isUpdating: widget.postDetail != null,
                      ),
                    ),
                    widget.postId == null
                        ? PromoteSection(controller: controller)
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
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
                            /// Otherwise, create the post
                            if (widget.postId == null) {
                              // await controller.createPost(<String, dynamic>{
                              //   'title': _titleCtrl.text.trim(),
                              //   'ytUrl': _ytUrl,
                              //   'timestamp':
                              //       DateTime.now().millisecondsSinceEpoch,
                              // }, _profileController);
                              await controller.createPost(<String, dynamic>{
                                'livedata': livedata,
                                'title': _titleCtrl.text.trim(),
                                'ytUrl': _ytUrl,
                                'images': _ytUrl != null && _ytUrl != ''
                                    ? 'https://api.businessbosses.co.uk/appfiles/1698854755_13_download_(1).png'
                                    : null, // Set images to null if _ytUrl is null or empty
                                'timestamp':
                                    DateTime.now().millisecondsSinceEpoch,
                              }, _profileController);
                            } else {
                              await controller.onEditPost(
                                  widget.postDetail, _titleCtrl.text.trim());
                            }
                          }
                        },
                        isProcessing: controller.loading.value,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
