import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';
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
  final CreateForumController _createForumController =
      Get.put(CreateForumController());

  String title = '';
  String description = '';
  ForumModel forum = ForumModel(forumId: '', industryId: '');
  bool isUpdating = false;
  bool isbossup = false;
  String? industryId;
  String? categoryId;
  bool isVisible = false;
  String? _ytUrl;
  bool isImageSelected = false;
  bool isYoutubeSelected = false;
  final DetectableTextEditingController descriptionController =
      DetectableTextEditingController();

  // Add lists for industries and categories
  final List<Map<String, String>> industries = <Map<String, String>>[
    <String, String>{'id': '1', 'name': 'Technology'},
    <String, String>{'id': '2', 'name': 'Healthcare'},
    <String, String>{'id': '3', 'name': 'Finance'},
    <String, String>{'id': '4', 'name': 'Education'},
    <String, String>{'id': '5', 'name': 'Retail'},
    <String, String>{'id': '6', 'name': 'Manufacturing'},
    <String, String>{'id': '7', 'name': 'Real Estate'},
    <String, String>{'id': '8', 'name': 'Hospitality'},
    <String, String>{'id': '9', 'name': 'Business Services & Consulting'},
  ];

  final List<Map<String, String>> categories = <Map<String, String>>[
    <String, String>{
      'id': Constants.LEARNINGID,
      'name': 'Learning & Resources'
    },
    <String, String>{'id': '2', 'name': 'Opportunities'},
    <String, String>{'id': '3', 'name': 'Challenges'},
  ];

  @override
  void initState() {
    super.initState();

    final dynamic arguments = Get.arguments;

    debugPrint('CreateForumScreen arguments: $arguments');

    if (arguments != null) {
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
                'Share Learning posts',
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),

                  // Industry Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      initialValue: industryId,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Select Industry',
                        labelText: 'Industry',
                      ),
                      items: industries.map((Map<String, String> industry) {
                        return DropdownMenuItem<String>(
                          value: industry['id'],
                          child: Text(industry['name']!),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          industryId = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an industry';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Category Dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      initialValue: categoryId,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Select Category',
                        labelText: 'Category',
                      ),
                      items: categories.map((Map<String, String> category) {
                        return DropdownMenuItem<String>(
                          value: category['id'],
                          child: Text(category['name']!),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          categoryId = value;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
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
                            },
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
                        // Validate industry and category selection
                        if (industryId == null || industryId!.isEmpty) {
                          showSnackbar(message: 'Please select an industry');
                          return;
                        }
                        if (categoryId == null || categoryId!.isEmpty) {
                          showSnackbar(message: 'Please select a category');
                          return;
                        }
                        if (title.trim().isEmpty) {
                          showSnackbar(message: 'Please enter a title');
                          return;
                        }
                        if (description.trim().isEmpty) {
                          showSnackbar(message: 'Please enter a description');
                          return;
                        }

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
                            'categoryId': categoryId,
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
