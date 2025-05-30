import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart'
    as custom_preview;
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart' hide Preview;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../controller/create_bossup_controller.dart';

// ignore: public_member_api_docs
class CreateBossUpScreen extends StatefulWidget {
  final Industry industryModel;
  // ignore: public_member_api_docs
  static const String routeName = '/create-bossup-screen';

  // ignore: public_member_api_docs
  const CreateBossUpScreen({super.key, required this.industryModel});

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
  bool isVisible = false;
  String? _ytUrl;
  late String industryId;
  final DetectableTextEditingController descriptionController =
      DetectableTextEditingController();
  @override
  void initState() {
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
                  Text(widget.industryModel.createTitle ??
                      'Introduce Your Business'),
              automaticallyImplyLeading:
                  false, // Used for removing back buttoon.
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
                      hintText: widget.industryModel.createInfo ??
                          'Enter Business name',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  DetectableTextField(
                    regExp: detectionRegExp(hashtag: false)!,
                    keyboardType: TextInputType.multiline,
                    // minLines: 5,
                    maxLength: 1000,
                    maxLines: 5,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (String val) {
                      description = val;
                    },

                    decoration: inputDecoration.copyWith(
                        hintText: widget.industryModel.createDescription ??
                            'Describe your Business'),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
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
                              horizontal: 8,
                              vertical: 8,
                            ),
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
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
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
                    height: 8,
                  ),
                  custom_preview.Preview(controller: controller),
                  const SizedBox(height: 24.0),
                  MCustomButton(
                    buttonType: ButtonType.elevated,
                    onPressed: () async {
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
                      if (widget.industryModel.industryId ==
                          '-MsUOGcOT9oRXGakCcJv') {
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
                      } else {
                        _profileController.myProfile.postChallenges
                            ?.add(widget.industryModel.industryId!);
                        Map<String, dynamic> updateData = <String, dynamic>{
                          'postChallenges':
                              _profileController.myProfile.postChallenges,
                        };
                        await ApiService.put(
                          path: 'users/${_profileController.myProfile.uid}',
                          body: <String, dynamic>{
                            'postChallenges':
                                _profileController.myProfile.postChallenges,
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
                          colorFilter:
                              ColorFilter.mode(primaryColorLT, BlendMode.srcIn),
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
        );
      },
    );
  }

  // void _onImagePicker() {}

  // void _onChangeForum() {}
}
