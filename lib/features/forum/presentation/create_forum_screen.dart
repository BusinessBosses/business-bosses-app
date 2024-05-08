import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:business_bosses_v2/features/forum/controller/create_forum_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';

import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

class CreateForumScreen extends StatefulWidget {
  static const String routeName = '/create-forum-screen';

  const CreateForumScreen({Key? key}) : super(key: key);

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
  final TextEditingController descriptionController = TextEditingController();

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
                      controller: descriptionController,
                      detectionRegExp: detectionRegExp(hashtag: false)!,
                      onDetectionTyped: (String text) {},
                      onDetectionFinished: () {},
                      keyboardType: TextInputType.multiline,
                      maxLength: 1000,
                      maxLines: 5,
                      basicStyle: Theme.of(context).textTheme.bodyMedium,
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
                      children: [
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
                                    color: textColor.withOpacity(0.2),
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
                    child: Preview(
                      controller: controller,
                      isUpdating: isUpdating,
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MCustomButton(
                      onPressed: () {
                        if (isUpdating) {
                          controller.editForum(<String, dynamic>{
                            ...forum.toMap(),
                            'title': title.trim(),
                            'description': description.trim(),
                            'industryId': industryId,
                          }, isBossup: isbossup);
                        } else {
                          controller.createForum(<String, dynamic>{
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
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        maxLines: null,
                        style: const TextStyle(
                          fontSize: 13,
                          color: subtextColor,
                        ),
                        categoryId == Constants.LEARNINGID
                            ? 'Only post articles, insights, and resources others can learn from.'
                            : 'Only post opportunities that will help you and others grow their businesses.',
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/report.svg',
                            height: 18,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.visible,
                            maxLines: null,
                            style: const TextStyle(
                                fontSize: 13, color: primaryColorLT),
                            isbossup == true
                                ? 'To sell your products and services, list on Marketplace'
                                : categoryId == Constants.LEARNINGID
                                    ? 'To sell your products and services, list on Marketplace'
                                    : 'To sell your products and services, list on Marketplace',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
