import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart' hide Preview;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/features/forum/controller/create_forum_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart'
    as custom_preview;
import 'package:business_bosses_v2/utils/constants/constants.dart';

import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

class CreateForumScreen extends StatefulWidget {
  static const String routeName = '/create-forum-screen';

  const CreateForumScreen({super.key});

  @override
  State<CreateForumScreen> createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<CreateForumScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CreateForumController _createForumController = Get.find();

  String title = '';
  String description = '';
  ForumModel forum = ForumModel(forumId: '', industryId: '');
  bool isUpdating = false;
  late bool isbossup;
  late String industryId;
  String? categoryId;
  bool isVisible = false;
  String? _ytUrl;
  bool isImageSelected = false;
  bool isYoutubeSelected = false;
  final DetectableTextEditingController descriptionController =
      DetectableTextEditingController();

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;

    if (arguments == null) {
      Get.back();
    } else {
      isbossup = arguments['isBossUp'] ?? false;
      if (arguments['isUpdating'] != null) {
        isUpdating = true;
        forum = arguments['forum'];
        title = forum.title ?? '';
        description = forum.description ?? '';
        descriptionController.text = forum.description ?? '';
        industryId = forum.industryId;
        _createForumController.initializeForumEditImage(forum.images);
      } else {
        industryId = arguments['industryId'];
        categoryId = arguments['categoryId'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateForumController>(
      builder: (CreateForumController controller) {
        return GestureDetector(
          onTap: () => unFocusKeyboard(context),
          child: Scaffold(
            backgroundColor: backgroundcolorinterface,
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                isbossup
                    ? 'Enter Challenge'
                    : categoryId == Constants.LEARNINGID
                        ? 'Share Resources'
                        : 'Share Opportunities',
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    isbossup ? Get.back() : Get.back();
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      initialValue: forum.title,
                      onChanged: (String val) {
                        title = val;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      decoration: inputDecoration.copyWith(
                          hintText: isbossup
                              ? 'Enter Business name'
                              : categoryId == Constants.LEARNINGID
                                  ? 'Enter Resource Title'
                                  : 'Enter Opportunity Title'),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DetectableTextField(
                      regExp: detectionRegExp(hashtag: false)!,
                      keyboardType: TextInputType.multiline,
                      maxLength: 1000,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (String val) {
                        description = val;
                      },
                      decoration: inputDecoration.copyWith(
                          hintText: isbossup
                              ? 'Describe your Business'
                              : categoryId == Constants.LEARNINGID
                                  ? 'Enter your Description'
                                  : 'Describe the Opportunity'),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  // if (!isUpdating)
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    // child: Row(
                    //   children: [
                    //     Container(
                    //         decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(50)),
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 8, vertical: 8),
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               if (controller.imageFileList.length < 5) {
                    //                 controller.onPickImage();
                    //               } else {
                    //                 showSnackbar(
                    //                     message:
                    //                         'You can only upload up to 5 images.');
                    //               }
                    //             },
                    //             child: Row(
                    //               children: <Widget>[
                    //                 const TextWidget(
                    //                   text: 'Add Attachment',
                    //                   fontWeight: FontWeight.w700,
                    //                   size: 15,
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 SvgPicture.asset(
                    //                   'assets/svgs/addimagepost.svg',
                    //                   height: 11,
                    //                 ),

                    //                 // const Text(
                    //                 //   'Max file size for images is 10Mb',
                    //                 //   style: TextStyle(fontSize: 11, color: Colors.red),
                    //                 // )
                    //               ],
                    //             ),
                    //           ),
                    //         )),
                    //     const Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                    //       child: Text('or'),
                    //     ),
                    //     Container(
                    //         decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(50)),
                    //         child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               horizontal: 8, vertical: 8),
                    //           child: GestureDetector(
                    //             onTap: () {
                    //               setState(() {
                    //                 isVisible = !isVisible;
                    //               });
                    //             },
                    //             child: Row(
                    //               children: <Widget>[
                    //                 const TextWidget(
                    //                   text: 'Add Youtube link',
                    //                   fontWeight: FontWeight.w700,
                    //                   size: 15,
                    //                 ),
                    //                 const SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 SvgPicture.asset(
                    //                   'assets/svgs/yt.svg',
                    //                   height: 15,
                    //                 ),

                    //               ],
                    //             ),
                    //           ),
                    //         )),
                    //   ],
                    // ),

                    child: Row(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              child: GestureDetector(
                                onTap: () {
                                  if (controller.imageFileList.length < 5) {
                                    controller.onPickImage();
                                  } else {
                                    showSnackbar(
                                        message:
                                            'You can only upload up to 5 images.');
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    const TextWidget(
                                      text: 'Add Attachment',
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
                                    // Radio(
                                    //   value: true,
                                    //   groupValue: isImageSelected,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       isImageSelected = value!;
                                    //       isYoutubeSelected = false;
                                    //     });
                                    //   },
                                    // ),
                                    // const Text(
                                    //   'Max file size for images is 10Mb',
                                    //   style: TextStyle(fontSize: 11, color: Colors.red),
                                    // )
                                  ],
                                ),
                              ),
                            )),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('or'),
                        ),
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50)),
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
                                    // Radio(
                                    //   value: true,
                                    //   groupValue: isYoutubeSelected,
                                    //   onChanged: (value) {
                                    //     setState(() {
                                    //       isYoutubeSelected = value!;
                                    //       isImageSelected = false;
                                    //     });
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: Visibility(
                        visible: isVisible,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                            keyboardType: TextInputType.visiblePassword,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: 'Paste a Youtube Video link here',
                              border: InputBorder.none,
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: textColor.withValues(alpha: 0.2),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: custom_preview.Preview(
                      controller: controller,
                      isUpdating: isUpdating,
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MCustomButton(
                      buttonType: ButtonType.elevated,
                      onPressed: () {
                        if (isUpdating) {
                          controller.editForum(<String, dynamic>{
                            ...forum.toMap(),
                            'title': title.trim(),
                            'description': description.trim(),
                            'industryId': industryId,
                          }, isBossup: isbossup);
                        } else {
                          controller.createForum(context, <String, dynamic>{
                            'title': title.trim(),
                            'description': description.trim(),
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                            'industryId': industryId,
                            'ytUrl': _ytUrl,
                            'images': _ytUrl != null && _ytUrl != ''
                                ? 'https://api.businessbosses.co.uk/appfiles/1698854755_13_download_(1).png'
                                : null,
                          });
                        }
                      },
                      label: isUpdating ? 'Update Post' : 'Post',
                      isProcessing: controller.loading.value,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const MarketplaceScreen());
                        },
                        child: const Row(
                          children: <Widget>[
                            Text(
                              'To sell your products and services, list on',
                              style: TextStyle(color: textColor, fontSize: 12),
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
