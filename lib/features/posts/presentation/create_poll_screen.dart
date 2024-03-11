import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
import 'package:business_bosses_v2/features/posts/widgets/promote_section.dart';
import 'package:business_bosses_v2/features/posts/widgets/text_input.dart';
import 'package:business_bosses_v2/features/posts/widgets/user_details_widget.dart';
import 'package:business_bosses_v2/functions/unfocus_keyboard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../profile/controller/profile_controller.dart';
import '../models/post_model.dart';

/// CREATE POLL SCREEN
class CreatePollScreen extends StatefulWidget {
  final PostModel? postDetail;

  /// SCREEN CONSTRUCTOR
  const CreatePollScreen({Key? key, this.postDetail}) : super(key: key);
  static const String routeName = '/create-poll';

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  // ignore: unused_field
  final CreatePostController _createPostController =
      Get.put(CreatePostController());
  dynamic _overlayEntry;
  final TextEditingController _titleCtrl = TextEditingController();
  List<Widget> dynamicTextFields = <Widget>[];
  int optionCode = 2;
  // final TextEditingController _ytCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ProfileController _profileController = Get.find();
  final Map<String, dynamic>? arguments = Get.arguments;
  String? sharemessage;
  String? title;
  String? livedata;
  List<String> optionsValues = <String>[''];

  void onDetectionFinished() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() {});
  }

  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    if (widget.postDetail != null) {
      _titleCtrl.text = widget.postDetail!.title;

      // Check if postDetail has options and their length
      if (widget.postDetail!.options != null &&
          widget.postDetail!.options!.isNotEmpty) {
        // Clear the dynamicTextFields list before populating
        dynamicTextFields.clear();
        optionsValues.clear();
        for (int i = 0; i < widget.postDetail!.options!.length; i++) {
          optionsValues.add(widget.postDetail!.options![i]);
          if (i < optionsValues.length) {
            dynamicTextFields.add(_buildOptionRow(i));
          }
        }

        // Set the optionCode to the correct value
        optionCode = widget.postDetail!.options!.length + 1;
      }
    } else {
      // Add two options by default
      optionsValues.addAll(<String>['', '']);
      dynamicTextFields.addAll(<Widget>[
        _buildOptionRow(0),
        _buildOptionRow(1),
      ]);
    }
  }

  Widget _buildOptionRow(int index) {
    if (index < 0 || index >= optionsValues.length) {
      return SizedBox(); // Return an empty widget if index is out of bounds
    }
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 9),
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: const BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: TextFormField(
              onChanged: (String value) {
                optionsValues[index] = value;
              },
              initialValue: widget.postDetail?.options != null &&
                      widget.postDetail!.options!.isNotEmpty &&
                      index < widget.postDetail!.options!.length
                  ? widget.postDetail!.options![index]
                  : '',
              decoration: InputDecoration(
                hintText: 'Option ${index + 1}',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        _buildRemoveOptionButton(index), // Pass index here
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: Form(
          key: _formKey,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              centerTitle: true,
              title: widget.postDetail == null
                  ? const Text('Create Poll')
                  : const Text('Update Poll'),
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
                        children: <Widget>[
                          const UserDetailsWidget(),
                          TextInput(
                            isPost: false,
                            onDetectionTyped: (String text) {},
                            titleController: _titleCtrl,
                            onDetectionFinished: onDetectionFinished,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            children: dynamicTextFields,
                          ),
                          GestureDetector(
                            onTap: () {
                              _addOption();
                            },
                            child: Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 9),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Add Options',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.add_circle,
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    // if (controller.imageFileList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Preview(
                        controller: controller,
                        isUpdating: widget.postDetail != null,
                      ),
                    ),
                    widget.postDetail == null
                        ? PromoteSection(controller: controller)
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: CustomButton(
                        buttonType: ButtonType.elevated,
                        label: widget.postDetail == null ? 'Post' : 'Update',
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if (!_formKey.currentState!.validate()) return;

                          /// Otherwise, create the po st
                          List<String> nonEmptyOptions = optionsValues
                              .where(
                                  (String option) => option.trim().isNotEmpty)
                              .toList();
                          if (nonEmptyOptions.length <= 1) {
                            Get.snackbar('Error',
                                'You must add atleast 2 options to create a poll!');
                            return;
                          }
                          if (widget.postDetail == null) {
                            await controller.createPost(<String, dynamic>{
                              'isPolled': true,
                              'options': nonEmptyOptions,
                              'title': _titleCtrl.text.trim(),
                              'timestamp':
                                  DateTime.now().millisecondsSinceEpoch,
                            }, _profileController);
                          } else {
                            await controller.onEditPoll(widget.postDetail,
                                _titleCtrl.text.trim(), nonEmptyOptions);
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
      ),
    );
  }

  Widget _buildRemoveOptionButton(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _removeOption(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        child: const Icon(
          Icons.close,
          color: Colors.red, //
        ),
      ),
    );
  }

  void _removeOption(int index) {
    if (optionsValues.isNotEmpty &&
        index >= 0 &&
        index < optionsValues.length) {
      setState(() {
        optionsValues.removeAt(
            index); // Remove the corresponding option from optionsValues
        dynamicTextFields
            .removeAt(index); // Remove the corresponding text field widget
        optionCode = optionCode > 0
            ? optionCode - 1
            : 0; // Ensure optionCode doesn't go below 0

        // Update the indexes of subsequent options
        // for (int i = index; i < dynamicTextFields.length; i++) {
        //   dynamicTextFields[i] = _buildOptionRow(
        //       i); // Rebuild the text field widget with updated index
        // }
      });
    }
  }

  void _addOption() {
    setState(() {
      if (optionsValues.length >= 4) {
        Get.snackbar('Error', 'You can only add 4 options!');
        return;
      }
      optionsValues.add(''); // Add an empty string to optionsValues
      dynamicTextFields.add(
        _buildOptionRow(optionsValues.length - 1),
      );
    });
  }
}
