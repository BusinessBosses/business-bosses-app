import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/add_image_widget.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/overlay_users_item.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/preview.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/promote_section.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/text_input.dart';
import 'package:business_bosses_v2/features/posts/presentation/widgets/user_details_widget.dart';
import 'package:business_bosses_v2/functions/unfocus_keyboard.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/dialogs/snackbar.dart';
import '../../profile/controller/profile_controller.dart';

/// CREATE POST SCREEN
class CreatePostScreen extends StatefulWidget {
  final String? postId;
  final String? post;
  final List<String?>? images;

  /// SCREEN CONSTRUCTOR
  const CreatePostScreen({
    Key? key,
    this.postId,
    this.post,
    this.images,
  }) : super(key: key);
  static const String routeName = '/create-post';

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  dynamic _overlayEntry;
  final TextEditingController _titleCtrl = TextEditingController();

  void onDetectionFinished() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Get.put(CreatePostController());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.postId != null) {
      _titleCtrl.text = widget.post!;
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
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
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
                      children: [
                        const UserDetailsWidget(),
                        TextInput(
                          onDetectionTyped: (String text) {
                            List<UserModel> filterUser =
                                controller.filterUsers(text);

                            setState(() {});

                            if (_overlayEntry != null) {
                              _overlayEntry?.remove();
                            }
                            _overlayEntry = OverlayEntry(
                              builder: (BuildContext context) {
                                return OverlayUsersItems(
                                  initialText: text,
                                  users: filterUser,
                                  onClose: () {
                                    _titleCtrl.text = '${_titleCtrl.text} ';
                                    _titleCtrl.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: _titleCtrl.text.length),
                                    );
                                    _overlayEntry = null;
                                    setState(() {});
                                  },
                                  onTap: (UserModel u) {
                                    String te = _titleCtrl.text.trim();
                                    List<String> allWords = <String>[];
                                    allWords = te.split(' ');
                                    allWords.removeAt(allWords.length - 1);
                                    allWords.add('@${u.username}');
                                    te = '';
                                    for (int i = 0; i < allWords.length; i++) {
                                      te = '$te${allWords[i]} ';
                                    }

                                    _titleCtrl.clear();

                                    _titleCtrl.text = te;
                                    _titleCtrl.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: _titleCtrl.text.length),
                                    );
                                    setState(() {});
                                  },
                                );
                              },
                            );
                            Overlay.of(context).insert(_overlayEntry);
                            setState(() {});
                          },
                          titleController: _titleCtrl,
                          onDetectionFinished: onDetectionFinished,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AddImageWidget(controller: controller),
                  const SizedBox(
                    height: 10,
                  ),
                  if (controller.imageFileList.isNotEmpty)
                    Preview(controller: controller),
                  const SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: ColoredBox(color: backgroundcolorinterface),
                  ),
                  widget.postId == null
                      ? PromoteSection(controller: controller)
                      : const SizedBox(),
                  const SizedBox(
                    width: double.infinity,
                    height: 1,
                    child: ColoredBox(color: backgroundcolorinterface),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: CustomButton(
                      buttonType: ButtonType.elevated,
                      label: widget.postId == null ? 'Post' : 'Edit',
                      onPressed: () async {
                        if (controller.imageFileList.length > 5) {
                          /// If the user has selected more than five images, show an error message
                          showSnackbar(
                              message: 'You can select up to five images.');
                        } else {
                          /// Otherwise, create the post
                          if (widget.postId == null) {
                            await controller.createPost(<String, dynamic>{
                              'title': _titleCtrl.text.trim(),
                              'timestamp':
                                  DateTime.now().millisecondsSinceEpoch,
                            });
                          } else {
                            ApiService.put(
                              path: 'post/update-post/${widget.postId}',
                              body: {
                                'title': _titleCtrl.text.trim(),
                              },
                            );
                            Get.back();
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
    );
  }
}
