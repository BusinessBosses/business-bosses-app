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
import '../../home/bottom_nav.dart';
import '../widgets/field_container.dart';

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
  bool isbossup = true;
  late String industryId;
  String? categoryId;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;

    if (arguments == null) {
      Get.back();
    } else {
      isbossup = arguments['isBossUp'] ?? true;
      if (arguments['isUpdating'] != null) {
        isUpdating = true;
        forum = arguments['forum'];
        title = forum.title ?? '';
        description = forum.description ?? '';
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
                        ? 'Start a Topic'
                        : 'Share Opportunities',
              ),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    isbossup
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const BottomNavScreen(2, true),
                            ),
                          )
                        : Get.back();
                  },
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
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
                                  ? 'Enter Topic Title'
                                  : 'Enter Opportunity Title'),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DetectableTextField(
                      controller:
                          TextEditingController(text: forum.description),
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
                  SizedBox(height: 12.0),
                  // if (!isUpdating)
                  GestureDetector(
                    onTap: () {
                      if (controller.imageFileList.length < 5) {
                        controller.onPickImage(isUpdating: true);
                      } else {
                        showSnackbar(
                            message: 'You can only upload up to 5 images.');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: FieldContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Add Attachment',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: hintColor),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            CircleAvatar(
                              radius: 26 / 1.38,
                              backgroundColor: backgroundColor,
                              child: SvgPicture.asset(
                                'assets/svgs/addimagepost.svg',
                                height: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Preview(
                      controller: controller,
                      isUpdating: true,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MCustomButton(
                      onPressed: () {
                        if (isUpdating) {
                          controller.editForum({
                            ...forum.toMap(),
                            'title': title.trim(),
                            'description': description.trim(),
                            'industryId': industryId,
                          });
                        } else {
                          controller.createForum({
                            'title': title.trim(),
                            'description': description.trim(),
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                            'industryId': industryId
                          });
                        }
                      },
                      label: isUpdating ? 'Update Post' : 'Post',
                      isProcessing: controller.loading.value,
                    ),
                  ),
                  SizedBox(height: 30),
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
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/report.svg',
                            height: 18,
                          ),
                          SizedBox(width: 2),
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
