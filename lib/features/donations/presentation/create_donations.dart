import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
import 'package:business_bosses_v2/features/donations/controller/donations_controller.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
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
  String? targetAmount;
  bool isUpdating = false;
  late String industryId;
  String? categoryId;
  bool isVisible = false;
  String? _ytUrl;
  String? photo;
  bool isImageSelected = false;
  bool isYoutubeSelected = false;
  final TextEditingController descriptionController = TextEditingController();
  bool _shouldPromote = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
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
                      hintText: 'Enter the story behind your project'),
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
                      child: Stack(children: [
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          maxLength: 15,
                          decoration: inputDecoration.copyWith(
                            hintText: 'Enter Amount to raise eg 2000',
                          ),
                          onChanged: (String val) {
                            targetAmount = val;
                          },
                        ),
                        Positioned(
                            top: 20,
                            bottom: 0,
                            right: 10,
                            child: Text(
                              '(\$20.00)',
                              style: TextStyle(color: textColor.withAlpha(100)),
                            ))
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),
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
                            onTap: () {},
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
                  isProcessing: isProcessing,
                  buttonType: ButtonType.elevated,
                  onPressed: () async {
                    setState(() {
                      isProcessing = true;
                    });
                    await donationsController.createDonation(<String, dynamic>{
                      'categoryId': '6463a069-657d-47ae-b937-9a5d4c336811',
                      'userId': profileController.myProfile.uid,
                      'title': title,
                      'description': descriptionController.text,
                      'timestamp': DateTime.now().millisecondsSinceEpoch,
                      'targetAmount': targetAmount,
                      'youtubeUrls': _ytUrl,
                      'photo': photo,
                    });
                    setState(() {
                      isProcessing = false;
                    });
                  },
                  label: isUpdating ? 'Update Post' : 'Post',
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
}
