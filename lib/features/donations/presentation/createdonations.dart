import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/features/posts/widgets/preview.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../utils/theme/theme.dart';

class CreateDonationScreen extends StatefulWidget {
  static const String routeName = '/create-Donation-screen';

  const CreateDonationScreen({Key? key}) : super(key: key);

  @override
  State<CreateDonationScreen> createState() => _CreateDonationScreenState();
}

class _CreateDonationScreenState extends State<CreateDonationScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String title = '';
  String description = '';
  bool isUpdating = false;
  late String industryId;
  String? categoryId;
  bool isVisible = false;
  String? _ytUrl;
  bool isImageSelected = false;
  bool isYoutubeSelected = false;
  final TextEditingController descriptionController = TextEditingController();
  bool _shouldPromote = false;

  @override
  void initState() {
    super.initState();

    final arguments = Get.arguments;

    // if (arguments == null) {
    //   Get.back();
    // } else {
    //   isbossup = arguments['isBossUp'] ?? false;
    //   if (arguments['isUpdating'] != null) {
    //     isUpdating = true;
    //     Donation = arguments['Donation'];
    //     title = Donation.title ?? '';
    //     description = Donation.description ?? '';
    //     descriptionController.text = Donation.description ?? '';
    //     industryId = Donation.industryId;
    //     _createDonationController.initializeDonationEditImage(Donation.images);
    //   } else {
    //     industryId = arguments['industryId'];
    //     categoryId = arguments['categoryId'];
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        backgroundColor: backgroundcolorinterface,
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Create a Donation',
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
                      hintText: 'Tell us the story behind your project'),
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(14),
                      child:
                          SvgPicture.asset('assets/svgs/coin.svg', height: 30),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex:
                          6, // Adjust the flex value to control the relative sizes
                      child: Stack(children: [
                        TextFormField(
                          // controller: _priceController,
                          // onChanged: (String val) => price = val,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLength: 15,
                          decoration: inputDecoration.copyWith(
                            hintText: 'Enter Amount to raise',
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
              // if (!isUpdating)
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                              // if (controller.imageFileList.length < 5) {
                              //   controller.onPickImage();
                              // } else {
                              //   showSnackbar(
                              //       message:
                              //           'You can only upload up to 5 images.');
                              // }
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

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Preview(
              //     controller: controller,
              //     isUpdating: isUpdating,
              //   ),
              // ),
              const SizedBox(height: 24.0),
              Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Container(
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
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MCustomButton(
                  buttonType: ButtonType.elevated,
                  onPressed: () {
                    // if (isUpdating) {
                    //   controller.editDonation(<String, dynamic>{
                    //     ...Donation.toMap(),
                    //     'title': title.trim(),
                    //     'description': description.trim(),
                    //     'industryId': industryId,
                    //   }, isBossup: isbossup);
                    // } else {
                    //   controller.createDonation(<String, dynamic>{
                    //     'title': title.trim(),
                    //     'description': description.trim(),
                    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
                    //     'industryId': industryId,
                    //     'ytUrl': _ytUrl,
                    //     'images': _ytUrl != null && _ytUrl != ''
                    //         ? 'https://api.businessbosses.co.uk/appfiles/1698854755_13_download_(1).png'
                    //         : null,
                    //   });
                    // }
                  },
                  label: isUpdating ? 'Update Post' : 'Post',
                  // isProcessing: controller.loading.value,
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
                          'sddd'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
