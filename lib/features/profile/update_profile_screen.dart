import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/widgets/additionalinformationtile.dart';
import 'package:business_bosses_v2/features/profile/widgets/compulsoryfields.dart';
import 'package:business_bosses_v2/features/profile/widgets/productsandservicestile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../action/action.dart';
import '../../common/models/analyser_data.dart';
import '../../common/models/api_response_model.dart';
import '../../common/models/for_data_picker.dart';
import '../../common/models/industry.dart';
import '../../common/models/my_response.dart';
import '../../common/models/my_title.dart';
import '../../common/widgets/buttons/custom_button.dart';
import '../../common/widgets/data_selection_screen.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/validators/validator.dart';
import '../../utils/theme/theme.dart';
import 'widgets/achievementtile.dart';
import 'analysescreen.dart';
import 'user_profile_image_item.dart';

var isExpanded = false;

class UpdateProfileScreen extends StatefulWidget {
  final UserModel? user;
  const UpdateProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  ScrollController _scrollController = ScrollController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _referralId;
  String? _location;
  String? _category;
  String? _industry;
  String? _photoUrl;
  String? _companyName;
  String? _username;
  String? _name = '';
  String? _surname;
  String? _bio;
  String? _website;
  String? _instagram;
  String? _twitter;
  String? _ageRange;
  String? _gender;

// String? blas;
  bool _isInit = false;
  bool _isNetworkImage = false;
  bool _isUploading = false;
  bool _isProcessing = false;
  bool? _isUniqueName;
  bool? email;

  File? _imageFile;
  final ImagePicker picker = ImagePicker();
  bool _isEditingMode = false;
  List<String> _usersToCompareUsername = [''];

  List<String> achievements = <String>[];

  List<String> productsandservices = <String>[];

  void onPickImage() async {
    try {
      final XFile? avatar = await picker.pickImage(source: ImageSource.gallery);

      if (avatar != null) {
        setState(() {
          _imageFile = File(avatar.path);
          _isUploading = true;
        });

        final dynamic res = await ApiService.uploadFile(File(avatar.path));
        if (res != null) {
          setState(() {
            _photoUrl = res['fileUrl'];
            _isUploading = false;
          });
        } else {
          setState(() {
            _imageFile = null;
            _isUploading = false;
          });
          showSnackbar(
              title: "OOPS!!", message: 'Could not upload Image. Try again');
        }
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    ModalRoute? currentRoute = ModalRoute.of(context);

    return GestureDetector(
        onTap: () => unFocusKeyboard(context),
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: currentRoute!.isFirst
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
              centerTitle: true,
              // ignore: prefer_const_constructors
              title: Text(
                currentRoute.isFirst ? 'Complete your Profile' : 'Edit Profile',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            body: Column(children: [
              Expanded(
                  child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(0.0),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoValidateMode,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: double.infinity,
                              height: 20,
                              child:
                                  ColoredBox(color: backgroundcolorinterface),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: UserProfileImageItem(
                                imageUrl: _photoUrl,
                                imageFile: _imageFile,
                                isNetWorkImage: _isNetworkImage,
                                onImagePicker: onPickImage,
                                height: 96.0,
                                width: 96.0,
                                isUploading: _isUploading,
                              ),
                            ),
                            const SizedBox(height: 40.0),
                            const SizedBox(
                              width: double.infinity,
                              height: 1.5,
                              child:
                                  ColoredBox(color: backgroundcolorinterface),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                const Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Requiredfieldstile(),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 1.5,
                                  child: ColoredBox(
                                      color: backgroundcolorinterface),
                                ),
                                const AdditionalInfoTile(),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 1.5,
                                  child: ColoredBox(
                                      color: backgroundcolorinterface),
                                ),
                                const AchievementsExpansionTile(),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 1.5,
                                  child: ColoredBox(
                                      color: backgroundcolorinterface),
                                ),
                                const ProductsandServicesExpansionTile(),
                                const SizedBox(
                                  width: double.infinity,
                                  height: 1.5,
                                  child: ColoredBox(
                                      color: backgroundcolorinterface),
                                ),
                                const SizedBox(height: 30),
                                CustomButton(
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 50),
                                  label: 'Save',
                                  onPressed: _attemptToComplete,
                                  isProcessing: _isProcessing,
                                  buttonType: ButtonType.elevated,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )))
            ])));
  }

  void _settingModalBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Wrap(
          children: <Widget>[
            ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  return _onImagePick(ImageSource.camera);
                }),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();

                return _onImagePick(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  void _onImagePick(ImageSource imageSource) async {
    try {
      final pickedImage = await picker.pickImage(source: imageSource);
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        setState(() {
          _imageFile = File(pickedImage.path);
          _isNetworkImage = false;
        });
      } else {
        debugPrint('Image not selected');
      }
    } catch (exception) {
      showSnackBar(context, message: exception.toString());
    }
  }

  Future<void> _attemptToComplete() async {
    setState(() {
      _isProcessing = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    Map<String, dynamic> updateData = <String, dynamic>{
      'name': _name,
      'bio': _bio,
      'companyName': _companyName,
      'website': _website,
      'instagram': _instagram,
      'twitter': _twitter,
      'industry': _industry,
      'category': _category,
      'location': _location,
      'achievements': achievements,
      'productsandservices': productsandservices,
      'ageRange': _ageRange,
      'gender': _gender,
      'photoURL': _photoUrl,
    };
    final String? userId = prefs.getString(Constants.USER_ID);
    // print('$userId token $updateData');
    // return;
    ApiResponseModel response =
        await ApiService.put(path: 'users/$userId', body: updateData);
    if (response.success) {
      Get.snackbar('Success', 'Profile Completed Succesfully');
      Get.toNamed(Routes.bottomNavigation);
    } else {
      Get.snackbar('Error', response.message);
    }
    _formKey.currentState!.save();
    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });
    if (!_formKey.currentState!.validate()) {
      _scrollController.animateTo(
        3,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
    setState(() {
      _isProcessing = true;
    });

    // if (_referralId != null) {
    //   _setUpReferral();
    // }

    if (_imageFile != null) {
      // MyResponse res = await _firebase.uploadFile(_imageFile);
      // debugPrint('data; ${res.success} : ${res.data}');
      // if (res.success) {
      //   debugPrint('file uploaded');
      //   _photoUrl = res.data;
      // }
    }
    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> onDataPicker({
    required Analyser analyser,
    required String title,
    required List<ForDataPicker> list,
  }) async {
    final MyResponse? res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => DataSelectionScreen(
          analyser: analyser,
          // list: list,
        ),
      ),
    );

    if (res != null && res.success) {
      if (analyser == Analyser.category) {
        MyTitle category = res.data;
        setState(() {
          _category = category.category;
        });
      } else if (analyser == Analyser.industry) {
        Industry industry = res.data;
        setState(() {
          _industry = industry.industry;
        });
      } else {
        debugPrint('CATEGORY FALE');
      }
    }
  }
}
