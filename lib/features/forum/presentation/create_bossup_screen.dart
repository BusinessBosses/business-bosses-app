import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../../home/bottom_nav.dart';
import '../controller/create_bossup_controller.dart';
import '../widgets/field_container.dart';

// ignore: public_member_api_docs
class CreateBossUpScreen extends StatefulWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/create-bossup-screen';

  // ignore: public_member_api_docs
  const CreateBossUpScreen({Key? key}) : super(key: key);

  @override
  State<CreateBossUpScreen> createState() => _CreateBossUpScreenState();
}

class _CreateBossUpScreenState extends State<CreateBossUpScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ProfileController _profileController = Get.find();
  // Industry? industry;
  String title = '';
  String description = '';
  ForumModel forum = ForumModel(forumId: '', industryId: '');
  bool isProcessing = false;
  bool isUpdating = false;
  bool isbossup = true;
  late String industryId;
  final TextEditingController descriptionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descriptionController.text = forum.description ?? '';
    if (Get.arguments == null) {
      Get.back();
    } else {
      isbossup = Get.arguments['isBossUp'] ?? true;
      if (Get.arguments['isUpdating'] != null) {
        isUpdating = true;
        forum = Get.arguments['forum'];
      } else {
        industryId = Get.arguments['industryId'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateBossUpController>(
      builder: (CreateBossUpController controller) {
        return GestureDetector(
          onTap: () => unFocusKeyboard(context),
          child: Scaffold(
            backgroundColor: backgroundcolorinterface,
            key: scaffoldKey,
            appBar: AppBar(
              title: //Text(Provider.of<AppCommunities>(context, listen: false).label(_industry.categoryId, isUpdating: _isUpdating)),
                  const Text('Introduce Your Business'),
              automaticallyImplyLeading:
                  false, // Used for removing back buttoon.
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    isbossup
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const BottomNavScreen(1, true),
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
                children: <Widget>[
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
                          : 'Enter Topic Title',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  DetectableTextField(
                    controller: descriptionController,

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
                          : 'Enter your Description',
                    ),
                  ),
                  const SizedBox(height: 12.0),
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
                        children: <Widget>[
                          SvgPicture.asset('assets/svgs/file.svg'),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text(
                              'Add Attachment',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: hintColor),
                            ),
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
                    onPressed: () async {
                      controller.createForum(<String, dynamic>{
                        'title': title.trim(),
                        'description': description.trim(),
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'industryId': industryId
                      });
                      if (isbossup == true) {
                        Map<String, dynamic> updateData = <String, dynamic>{
                          'bossOfTheWeekTimeStamp':
                              DateTime.now().millisecondsSinceEpoch,
                        };
                        await ApiService.put(
                          path: 'users/${_profileController.myProfile.uid}',
                          body: <String, dynamic>{
                            'bossOfTheWeekTimeStamp':
                                DateTime.now().millisecondsSinceEpoch,
                          },
                        );
                        _profileController.updateProfile(<String, dynamic>{
                          ..._profileController.myProfile.toMap(),
                          ...updateData
                        });
                      }
                    },
                    label: isUpdating ? 'Update Post' : 'Post',
                    isProcessing: controller.loading.value,
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
                          color: primaryColorLT,
                          height: 18,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'To sell your products and services, list on Marketplace',
                          style: TextStyle(color: primaryColorLT),
                        )
                      ],
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

  void _onImagePicker() {}

  void _onChangeForum() {}
}
