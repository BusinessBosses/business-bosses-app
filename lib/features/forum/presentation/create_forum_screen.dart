import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/forum/controller/create_forum_controller.dart';
import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
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
  // Industry? industry;
  String title = '';
  String description = '';
  ForumModel forum = ForumModel(forumId: '', industryId: '');
  bool isProcessing = false;
  bool isUpdating = false;
  bool isbossup = true;
  late String industryId;
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
      } else {
        industryId = Get.arguments['industryId'];
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
            key: scaffoldKey,
            appBar: AppBar(
              title: //Text(Provider.of<AppCommunities>(context, listen: false).label(_industry.categoryId, isUpdating: _isUpdating)),
                  const Text('Start a Topic'),
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
                      hintText: isbossup == false
                          ? 'Enter Business name'
                          : 'Enter Topic Title',
                    ),
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
                      hintText: isbossup == false
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
                        children: [
                          SvgPicture.asset('assets/svgs/file.svg'),
                          const SizedBox(width: 16.0),
                          Expanded(
                            child: Text('Add Attachment',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: hintColor)),
                          ),
                          const SizedBox(width: 16.0),
                          SvgPicture.asset('assets/svgs/upload.svg'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Preview(controller: controller),
                  // if (_myAssetsEntities?.isNotEmpty ?? false)
                  //   GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: _myAssetsEntities.length,
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: MediaQuery.of(context).orientation ==
                  //               Orientation.landscape
                  //           ? 5
                  //           : 3,
                  //       childAspectRatio: (1 / 1),
                  //     ),
                  //     itemBuilder: (context, i) {
                  //       return Container(
                  //         margin: const EdgeInsets.all(8.0),
                  //         child: Stack(
                  //           children: [
                  //             ClipRRect(
                  //               borderRadius: BorderRadius.circular(10.0),
                  //               child: AssetViewer(
                  //                 image: _myAssetsEntities[i].thumbnail,
                  //                 height: 150.0,
                  //                 width: 150.0,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //             (!_fileProcessing[i] && isProcessing)
                  //                 ? const Center(
                  //                     child: SizedBox(
                  //                       height: 22.0,
                  //                       width: 22.0,
                  //                       child: CircularProgressIndicator(),
                  //                     ),
                  //                   )
                  //                 : Container(),
                  //             deleteImage(i),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // if ((forum.images?.isNotEmpty ?? false))
                  //   GridView.builder(
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: forum.images!.length,
                  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: MediaQuery.of(context).orientation ==
                  //               Orientation.landscape
                  //           ? 5
                  //           : 3,
                  //       childAspectRatio: (1 / 1),
                  //     ),
                  //     itemBuilder: (BuildContext context, int i) {
                  //       return Container(
                  //         margin: const EdgeInsets.all(8.0),
                  //         child: Stack(
                  //           children: [
                  //             ClipRRect(
                  //               borderRadius: BorderRadius.circular(10.0),
                  //               child: NetworkImageWithPlaceHolder(
                  //                 imageUrl: forum.images![i],
                  //                 height: 150.0,
                  //                 width: 150.0,
                  //                 fit: BoxFit.cover,
                  //               ),
                  //             ),
                  //             Positioned(
                  //               right: 5.0,
                  //               top: 5.0,
                  //               child: GestureDetector(
                  //                 onTap: () {
                  //                   forum.images!.removeAt(i);
                  //                 },
                  //                 child: Container(
                  //                   height: 30.0,
                  //                   width: 30.0,
                  //                   alignment: Alignment.center,
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.black54,
                  //                     borderRadius: BorderRadius.circular(40.0),
                  //                   ),
                  //                   child: const Icon(
                  //                     Icons.close,
                  //                     size: 18.0,
                  //                     color: Colors.white,
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //             // _deleteImage(i),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),

                  const SizedBox(height: 24.0),
                  MCustomButton(
                    onPressed: () {
                      controller.createForum({
                        'title': title.trim(),
                        'description': description.trim(),
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'industryId': industryId
                      });
                    },
                    label: isUpdating ? 'Update Post' : 'Post',
                    isProcessing: controller.loading.value,
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
