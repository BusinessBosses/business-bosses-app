import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/forum/controller/create_forum_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';
import '../../home/bottom_nav.dart';
import '../widgets/field_container.dart';

// ignore: public_member_api_docs
class CreateForumScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/create-forum-screen';

  // ignore: public_member_api_docs
  const CreateForumScreen({Key? key}) : super(key: key);

  @override
  State<CreateForumScreen> createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<CreateForumScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CreateForumController _createForumController = Get.find();
  // Industry? industry;
  String title = '';
  String description = '';
  ForumModel forum = ForumModel(forumId: '', industryId: '');
  bool isProcessing = false;
  bool isUpdating = false;
  bool isbossup = true;
  late String industryId;
  String? categoryId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Get.arguments == null) {
      Get.back();
    } else {
      isbossup = Get.arguments['isBossUp'] ?? true;
      if (Get.arguments['isUpdating'] != null) {
        isUpdating = true;
        forum = Get.arguments['forum'];
        title = forum.title ?? '';
        description = forum.description ?? '';
        industryId = forum.industryId;
        _createForumController.initializeForumEditImage(forum.images);
      } else {
        industryId = Get.arguments['industryId'];
        categoryId = Get.arguments['categoryId'];
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
                isbossup == true
                    ? 'Enter Challenge'
                    : categoryId == Constants.LEARNINGID
                        ? 'Start a Topic'
                        : 'Share Opportunities',
              ),
              automaticallyImplyLeading:
                  false, // Used for removing back buttoon.
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
              padding:
                  const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    // controller: _titleController,
                    initialValue: forum.title,
                    onChanged: (String val) {
                      title = val;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: inputDecoration.copyWith(
                        hintText: isbossup == true
                            ? 'Enter Business name'
                            : categoryId == Constants.LEARNINGID
                                ? 'Enter Topic Title'
                                : 'Enter Opportunity Title'),
                  ),
                  const SizedBox(height: 24.0),
                  DetectableTextField(
                    controller: TextEditingController(text: forum.description),

                    detectionRegExp: detectionRegExp(hashtag: false)!,
                    onDetectionTyped: (String text) {},
                    onDetectionFinished: () {},
                    keyboardType: TextInputType.multiline,
                    // minLines: 5,
                    maxLength: 1000,
                    maxLines: 5,
                    basicStyle: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (String val) {
                      description = val;
                    },

                    decoration: inputDecoration.copyWith(
                        hintText: isbossup == true
                            ? 'Describe your Business'
                            : categoryId == Constants.LEARNINGID
                                ? 'Enter your Description'
                                : 'Describe the Opportunity'),
                  ),
                  const SizedBox(height: 12.0),
                  if (!isUpdating)
                    GestureDetector(
                      onTap: () {
                        if (controller.imageFileList.length < 5) {
                          controller.onPickImage();
                        } else {
                          showSnackbar(
                              message: 'You can only upload up to 5 images.');
                        }
                      },
                      child: FieldContainer(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('Add Attachment',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: hintColor)),
                            ),
                            const SizedBox(width: 16.0),
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
                  const SizedBox(height: 8.0),
                  Preview(controller: controller),
                  const SizedBox(height: 24.0),
                  MCustomButton(
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
                  const SizedBox(height: 30),
                  Flexible(
                    child: Text(
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible,
                      maxLines: null,
                      style: const TextStyle(fontSize: 13, color: subtextColor),
                      categoryId == Constants.LEARNINGID
                          ? 'Only post articles, insights, and resources others can learn from To sell your products and services, list on Marketplace'
                          : 'Only post opportunities that will help you and others grow their businesses To sell your products and services, list on Marketplace',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/svgs/report.svg',
                        height: 20,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Flexible(
                        child: Text(
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.visible,
                          maxLines: null,
                          style: const TextStyle(
                              fontSize: 13, color: subtextColor),
                          categoryId == Constants.LEARNINGID
                              ? 'To sell your products and services, list on Marketplace'
                              : 'To sell your products and services, list on Marketplace',
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
