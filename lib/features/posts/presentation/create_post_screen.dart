import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/widgets/add_image_widget.dart';
import 'package:business_bosses_v2/features/posts/widgets/overlay_users_item.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
import 'package:business_bosses_v2/features/posts/widgets/promote_section.dart';
import 'package:business_bosses_v2/features/posts/widgets/text_input.dart';
import 'package:business_bosses_v2/features/posts/widgets/user_details_widget.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_text_input.dart';
import 'package:business_bosses_v2/functions/unfocus_keyboard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/utils/validators/validator.dart';
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

  void onDetectionFinished() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // if (widget.pos != null) {
    // _createPostController.imageFileList
    //     .addAll(widget.images!.map((String? image) => XFile(image!)));

    _createPostController.initializePostEditImage(widget.postDetail?.images);
    // }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments = Get.arguments;
    final String sharemessage = arguments['sharemessage'] ?? "";
    final String title = arguments['title'];
    final String livedata = arguments['livedata'] ?? "";

    if (widget.postId != null) {
      _titleCtrl.text = widget.post!;
    } else {
      title.isNotEmpty
          ? _titleCtrl.text = sharemessage + '\n\nTitle: $title '
          : _titleCtrl.text == '';
    }
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
                            onDetectionTyped: (String text) {
                              // List<UserModel> filterUser =
                              //     controller.filterUsers(text);

                              // setState(() {});

                              // if (_overlayEntry != null) {
                              //   _overlayEntry?.remove();
                              // }
                              // _overlayEntry = OverlayEntry(
                              //   builder: (BuildContext context) {
                              //     return OverlayUsersItems(
                              //       initialText: text,
                              //       users: filterUser,
                              //       onClose: () {
                              //         _titleCtrl.text = '${_titleCtrl.text} ';
                              //         _titleCtrl.selection =
                              //             TextSelection.fromPosition(
                              //           TextPosition(
                              //               offset: _titleCtrl.text.length),
                              //         );
                              //         _overlayEntry = null;
                              //         setState(() {});
                              //       },
                              //       onTap: (UserModel u) {
                              //         String te = _titleCtrl.text.trim();
                              //         List<String> allWords = <String>[];
                              //         allWords = te.split(' ');
                              //         allWords.removeAt(allWords.length - 1);
                              //         allWords.add('@${u.username}');
                              //         te = '';
                              //         for (int i = 0;
                              //             i < allWords.length;
                              //             i++) {
                              //           te = '$te${allWords[i]} ';
                              //         }

                              //         _titleCtrl.clear();

                              //         _titleCtrl.text = te;
                              //         _titleCtrl.selection =
                              //             TextSelection.fromPosition(
                              //           TextPosition(
                              //               offset: _titleCtrl.text.length),
                              //         );
                              //         setState(() {});
                              //       },
                              //     );
                              //   },
                              // );
                              // Overlay.of(context).insert(_overlayEntry);
                              // setState(() {});
                            },
                            titleController: _titleCtrl,
                            onDetectionFinished: onDetectionFinished,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                TextWidget(
                                  text: 'Embed a Youtube Video',
                                  size: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                children: [
                                  Expanded(
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
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        hintText:
                                            'Paste a Youtube Video link here',
                                        border: InputBorder.none,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: textColor.withOpacity(0.2),
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )

                          // Container(
                          //   height: 50,
                          //   decoration: const BoxDecoration(
                          //     color: backgroundColor,
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(15),
                          //     ),
                          //   ),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(15.0),
                          //     child: Column(
                          //       children: <Widget>[
                          //         Expanded(
                          //           child: TextFormField(
                          //             onChanged: (String val) {
                          //               _ytUrl = val;
                          //               setState(() {});
                          //             },
                          //             validator: (value) {
                          //               if (value == null || value.isEmpty) {
                          //                 return null; // No error message when the field is empty
                          //               } else if (!Validator.isYouTubeLink(
                          //                   value)) {
                          //                 return 'Please enter a valid YouTube link';
                          //               }
                          //               return null;
                          //             },
                          //             textInputAction: TextInputAction.done,
                          //             keyboardType:
                          //                 TextInputType.visiblePassword,
                          //             decoration: InputDecoration(
                          //               hintText:
                          //                   'Paste a Youtube Video link here',
                          //               border: InputBorder.none,
                          //               hintStyle: Theme.of(context)
                          //                   .textTheme
                          //                   .bodyMedium!
                          //                   .copyWith(
                          //                     color: textColor.withOpacity(0.2),
                          //                   ),
                          //             ),
                          //           ),
                          //         ),
                          //         if (_ytUrl != null &&
                          //             _ytUrl!.isNotEmpty &&
                          //             !Validator.isYouTubeLink(_ytUrl!))
                          //           Container(
                          //             margin: const EdgeInsets.only(top: 4.0),
                          //             child: Text(
                          //               'Please enter a valid YouTube link',
                          //               style: TextStyle(
                          //                 color: Colors.red,
                          //               ),
                          //             ),
                          //           ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AddImageWidget(
                      controller: controller,
                      isUpdating: widget.postDetail != null,
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
                                'livedata': title.isNotEmpty ? livedata : "",
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
