import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../utils/theme/theme.dart';
import '../../home/bottom_nav.dart';
import '../models/industry.dart';
import '../widgets/deleteimage.dart';
import '../widgets/field_container.dart';
import '../widgets/optionsdialog.dart';
import 'all_forum_screen.dart';

// ignore: public_member_api_docs
class CreateForumScreen extends StatelessWidget {
  // ignore: public_member_api_docs
  static const String routeName = '/create-forum-screen';

  // ignore: public_member_api_docs
  const CreateForumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    Industry? industry;
    final ForumModel forum = ForumModel();
    bool isProcessing = false;
    bool isUpdating = false;
    String isbossup = 'true';

    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Start a Topic'),
          automaticallyImplyLeading: false, // Used for removing back buttoon.
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                isbossup == 'false'
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BottomNavScreen(2, true),
                        ),
                      )
                    : navigateWithReplaceTo(
                        context,
                        routeName: AllForumScreen.routeName,
                        arguments: industry!.industryId,
                      );
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isbossup == 'false'
                  ? TextFormField(
                      // controller: _titleController,
                      initialValue: forum.title,
                      onChanged: (String val) => forum.title = val,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Enter Business name',
                      ),
                    )
                  : TextFormField(
                      // controller: _titleController,
                      initialValue: forum.title,
                      onChanged: (val) => forum.title = val,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      maxLength: 50,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Enter Topic Title',
                      ),
                    ),
              const SizedBox(height: 24.0),
              isbossup == 'false'
                  ? DetectableTextField(
                      controller:
                          TextEditingController(text: forum.description),

                      detectionRegExp: detectionRegExp(hashtag: false)!,
                      onDetectionTyped: (text) {},
                      onDetectionFinished: () {
                        debugPrint('finished');
                      },
                      keyboardType: TextInputType.multiline,
                      // minLines: 5,
                      maxLength: 1000,
                      maxLines: 5,
                      basicStyle: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (String val) => forum.description = val,

                      decoration: inputDecoration.copyWith(
                        hintText: 'Describe your Business',
                      ),
                    )
                  : DetectableTextField(
                      controller:
                          TextEditingController(text: forum.description),

                      detectionRegExp: detectionRegExp(hashtag: false)!,
                      onDetectionTyped: (text) {},
                      onDetectionFinished: () {
                        debugPrint('finished');
                      },
                      keyboardType: TextInputType.multiline,
                      // minLines: 5,
                      maxLength: 1000,
                      maxLines: 5,
                      basicStyle: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (val) => forum.description = val,

                      decoration: inputDecoration.copyWith(
                        hintText: 'Enter your Description',
                      ),
                    ),
              const SizedBox(height: 12.0),
              GestureDetector(
                onTap: _onImagePicker,
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
              if ((forum.images?.isNotEmpty ?? false))
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: forum.images!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 5
                        : 3,
                    childAspectRatio: (1 / 1),
                  ),
                  itemBuilder: (BuildContext context, int i) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: NetworkImageWithPlaceHolder(
                              imageUrl: forum.images![i],
                              height: 150.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 5.0,
                            top: 5.0,
                            child: GestureDetector(
                              onTap: () {
                                forum.images!.removeAt(i);
                              },
                              child: Container(
                                height: 30.0,
                                width: 30.0,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          // _deleteImage(i),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24.0),
              MCustomButton(
                onPressed: () {
                  if ((forum.description?.isEmpty ?? true) ||
                      (forum.title?.isEmpty ?? true))
                  /*if ((_titleController != null ||
                          _titleController.text.trim().isEmpty) &&
                      (_desController == null ||
                          _desController.text.trim().isEmpty))*/
                  {
                    showSnackBar(context,
                        message:
                            'Please select title and description to create a forum');
                    return;
                  }
                  if (!(industry!.industry!.contains('Boss Up Challenge'))) {
                    _onChangeForum();
                  } else {
                    if (isUpdating) {
                      _onChangeForum();
                    } else {
                      optionsDialog(context, () {
                        Navigator.pop(context);
                        _onChangeForum();
                      });
                    }
                  }
                },
                label: isUpdating ? 'Update Post' : 'Post',
                isProcessing: isProcessing,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onImagePicker() {}

  void _onChangeForum() {}
}
