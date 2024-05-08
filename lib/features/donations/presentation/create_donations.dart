import 'dart:io';
import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

class CreateDonationScreen extends StatefulWidget {
  static const String routeName = '/create-Donation-screen';
  final DonationModel? donation;
  const CreateDonationScreen({Key? key, this.donation}) : super(key: key);

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  final DonationsController donationsController = Get.find();
  final ProfileController profileController = Get.find();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String title = '';
  String description = '';
  int? targetAmount;
  bool isUpdating = false;
  late String industryId;
  String? categoryId;
  bool isVisible = false;
  String? _ytUrl;
  String? photo;
  bool isImageSelected = false;
  bool isYoutubeSelected = false;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  bool _shouldPromote = false;
  bool isProcessing = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    if (widget.donation != null) {
      titleController.text = widget.donation!.title!;
      descriptionController.text = widget.donation!.description!;
      priceController.text = widget.donation!.targetAmount!.toString();
      photo =
          widget.donation!.images.isEmpty ? null : widget.donation!.images[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        backgroundColor: backgroundcolorinterface,
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
            widget.donation != null ? 'Update Donation' : 'Create a Donation',
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                  controller: titleController,
                  onChanged: (String val) {
                    title = val;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration:
                      inputDecoration.copyWith(hintText: 'Enter Project Title'),
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
                      hintText: 'Enter the story behind your project'),
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          SvgPicture.asset('assets/svgs/coin.svg', height: 30),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex:
                          6, // Adjust the flex value to control the relative sizes
                      child: Stack(
                        children: <Widget>[
                          TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')), // Allow only numbers
                            ],
                            controller: priceController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            maxLength: 7,
                            decoration: inputDecoration.copyWith(
                              hintText: 'Enter Amount to raise e.g 2000',
                              counterText: '',
                            ),
                            onChanged: (String val) {
                              targetAmount = int.tryParse(val) ?? 0;
                              setState(() {});
                            },
                          ),
                          Positioned(
                              top: 20,
                              bottom: 0,
                              right: 10,
                              child: Text(
                                priceController.text != ''
                                    ? ' \$${num.parse(priceController.text) / 100}'
                                    : '\$0',
                                style:
                                    TextStyle(color: textColor.withAlpha(100)),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              setState(() {
                                isVisible = false;
                                _ytUrl = null;
                              });
                              _pickImage(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(
                height: 20,
              ),
              if (_selectedImage != null || photo != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Stack(
                    children: <Widget>[
                      SizedBox(
                        width: 100, // Adjust the width as needed
                        height: 100, // Adjust the height as needed
                        child: photo == null
                            ? Image.file(_selectedImage!)
                            : NetworkImageWithPlaceHolder(imageUrl: photo),
                      ),
                      Positioned(
                        top: 25,
                        right: 25,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Make it a circle
                            color: Colors.red
                                .withOpacity(0.5), // Choose your desired color
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ), // Close icon
                            onPressed: _removeImage,
                          ),
                        ),
                      ),
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
                        keyboardType: TextInputType.visiblePassword,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Paste a Youtube Video link here',
                          border: InputBorder.none,
                          hintStyle:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
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
              const SizedBox(height: 24.0),
              if (widget.donation != null)
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 16, right: 16),
                        child: Row(
                          children: <Widget>[
                            SvgPicture.asset('assets/svgs/rocket.svg'),
                            const SizedBox(width: 15),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Boost this listing?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    'Reach a wider audience and get more views',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                      color: Color(0xFF777777),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                const Text(
                                  'No',
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.w700),
                                ),
                                Switch(
                                  value: _shouldPromote,
                                  onChanged: (bool value) {
                                    setState(() {
                                      _shouldPromote = value;
                                    });
                                  },
                                ),
                                const Text(
                                  'Yes',
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 24.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MCustomButton(
                  isProcessing: isProcessing,
                  buttonType: ButtonType.elevated,
                  onPressed: () async {
                    if (_selectedImage == null &&
                        photo == null &&
                        _ytUrl == null) {
                      Get.snackbar(
                        'Error!',
                        'You must add an image or youtube url to continue!',
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                    if (_ytUrl != null && !_isValidYoutubeUrl(_ytUrl!)) {
                      if (_selectedImage == null &&
                          photo == null &&
                          _ytUrl == null) {
                        Get.snackbar(
                          'Error!',
                          'You must add a valid youtube url to continue!',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                    setState(() {
                      isProcessing = true;
                    });
                    if (_selectedImage != null) {
                      dynamic response =
                          await ApiService.uploadFile(_selectedImage!);
                      if (response['success']) {
                        photo = response['fileUrl'];
                      }
                    }
                    if (widget.donation != null) {
                      await donationsController
                          .updateDonation(<String, dynamic>{
                        'isActive': true,
                        'isApproved': true,
                        'categoryId': '6463a069-657d-47ae-b937-9a5d4c336811',
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'targetAmount': int.tryParse(priceController.text),
                        'youtubeUrls': _ytUrl,
                        'images':
                            photo != null ? <String?>[photo] : <dynamic>[],
                      }, widget.donation!.id);
                    } else {
                      await donationsController
                          .createDonation(<String, dynamic>{
                        'categoryId': '6463a069-657d-47ae-b937-9a5d4c336811',
                        'userId': profileController.myProfile.uid,
                        'title': titleController.text,
                        'description': descriptionController.text,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'targetAmount': targetAmount,
                        'youtubeUrls': _ytUrl,
                        'images':
                            photo != null ? <String?>[photo] : <dynamic>[],
                        'comments': <CommentModel>[],
                        'likes': <dynamic>[],
                      });
                    }
                    setState(() {
                      isProcessing = false;
                    });
                  },
                  label: widget.donation != null ? 'Update Post' : 'Post',
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/svgs/report.svg',
                      height: 18,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    const Flexible(
                      child: Text(
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 13, color: subtextColor),
                        'Please note this donation MUST be for your business only. We do not currently support any charitable organisation donations. ',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Handle the selected image. You can save it, display it, or upload it.
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      photo = null;
    });
  }

  bool _isValidYoutubeUrl(String url) {
    final RegExp youtubeRegExp = RegExp(
      r'^(https?\:\/\/)?(www\.youtube\.com\/watch\?v=|youtu\.be\/).+$',
      caseSensitive: false,
      multiLine: false,
    );
    return youtubeRegExp.hasMatch(url);
  }
}
