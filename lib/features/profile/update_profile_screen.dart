import 'dart:convert';
import 'dart:io';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../action/action.dart';
import '../../common/models/analyser_data.dart';
import '../../common/models/api_response_model.dart';
import '../../common/models/for_data_picker.dart';
import '../../common/models/industry.dart';
import '../../common/models/my_response.dart';
import '../../common/models/my_title.dart';
import '../../common/models/my_user.dart';
import '../../common/widgets/buttons/custom_button.dart';
import '../../common/widgets/data_selection_screen.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/validators/validator.dart';
import '../../utils/theme/theme.dart';
import 'analysescreen.dart';
import 'myprofilescreen.dart';
import 'user_profile_image_item.dart';

var isExpanded = false;

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

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
  String? _achievements;
  String? _productsandservices;

  bool _isInit = false;
  bool _isNetworkImage = true;
  bool _isProcessing = false;
  bool? _isUniqueName;
  bool? email;

  File _imageFile = File('');
  final ImagePicker picker = ImagePicker();
  bool _isEditingMode = false;
  List<String> _usersToCompareUsername = [''];

  List<String> achievements = <String>[];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  TextEditingController achievementController = TextEditingController();
  TextEditingController productsController = TextEditingController();

  void addItemToList() {
    if (achievementController.text.isNotEmpty &&
        achievementController.text.trim().isNotEmpty &&
        achievements.length <= 2) {
      setState(() {
        achievements.insert(0, achievementController.text);
        _achievements = achievements.join('+');
      });
    }
  }

  List<String> productsandservices = <String>[];

  void addItemToproductList() {
    if (_productsandservices == null) {
      setState(() {
        productsandservices.insert(0, productsController.text);
        _productsandservices = productsandservices.join('+');
      });
    } else if (productsController.text.isNotEmpty &&
        productsController.text.trim().isNotEmpty &&
        productsandservices.length <= 6) {
      setState(() {
        productsandservices.insert(0, productsController.text);
        _productsandservices = productsandservices.join('+');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ModalRoute? currentRoute = ModalRoute.of(context);
    String? nameValidator = Validator.nameValidator(_name!);
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
        body: Column(
          children: [
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
                        child: ColoredBox(color: backgroundcolorinterface),
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
                          onImagePicker: () {},
                          height: 96.0,
                          width: 96.0,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      const SizedBox(
                        width: double.infinity,
                        height: 1.5,
                        child: ColoredBox(color: backgroundcolorinterface),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'Name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      initialValue: _name,
                                      onChanged: (String val) {
                                        _name = val;
                                        setState(() {});
                                      },
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      validator: Validator.nameValidator,
                                      decoration: inputDecoration.copyWith(
                                        hintStyle: const TextStyle(
                                          color: iconColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        suffixIcon: _name != null
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.close,
                                                color: _isUniqueName == null
                                                    ? Colors.transparent
                                                    : Colors.red,
                                              ),
                                        filled: true,
                                        fillColor: const Color(0xffF4F4F4),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'Title',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12.0),
                                    GestureDetector(
                                      onTap: () => onDataPicker(
                                        analyser: Analyser.category,
                                        title: 'Title',
                                        list: AnalyserData.industries,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: backgroundcolorinterface,
                                          borderRadius: BorderRadius.circular(
                                              radiusValue),
                                        ),
                                        child: ListTile(
                                          leading: _category != null
                                              ? Text(_category!)
                                              : Text(
                                                  'select a category or profession',
                                                  style: bodyText2.copyWith(
                                                      color: hintColor),
                                                ),
                                          trailing: const Icon(
                                              Icons.keyboard_arrow_right),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    RichText(
                                      text: const TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Bio',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: textColor,
                                                  fontWeight: FontWeight.w700)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      initialValue: _bio,
                                      onChanged: (val) {
                                        _bio = val;
                                      },
                                      maxLength: 150,
                                      maxLines: 5,
                                      keyboardType: TextInputType.text,
                                      validator: Validator.bioValidator,
                                      textInputAction: TextInputAction.next,
                                      decoration: inputDecoration.copyWith(
                                        hintStyle: const TextStyle(
                                          color: iconColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        suffixIcon: _bio != null
                                            ? const Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.close,
                                                color: _isUniqueName == null
                                                    ? Colors.transparent
                                                    : Colors.red,
                                              ),
                                        filled: true,
                                        fillColor: const Color(0xffF4F4F4),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 1.5,
                        child: ColoredBox(color: backgroundcolorinterface),
                      ),
                      ExpansionTile(
                        trailing: isExpanded
                            ? SvgPicture.asset(
                                'assets/svgs/dropdownexpansionup.svg',
                              )
                            : SvgPicture.asset(
                                'assets/svgs/dropdownexpansion.svg',
                              ),
                        title: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Additional Information',
                                  style: TextStyle(color: textColor)),
                              TextSpan(
                                  text: ' (Optional)',
                                  style: TextStyle(color: hintColor)),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text('Company Name',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              initialValue: _companyName,
                                              onChanged: (val) {
                                                debugPrint(
                                                    '_companyName $_companyName');
                                                _companyName = val;
                                              },
                                              keyboardType: TextInputType.name,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration:
                                                  inputDecoration.copyWith(
                                                hintStyle: const TextStyle(
                                                  color: iconColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                suffixIcon: _isUniqueName ==
                                                        true
                                                    ? const Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                      )
                                                    : Icon(
                                                        Icons.close,
                                                        color: _isUniqueName ==
                                                                null
                                                            ? Colors.transparent
                                                            : Colors.red,
                                                      ),
                                                filled: true,
                                                fillColor:
                                                    const Color(0xffF4F4F4),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text('Industry',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                const SizedBox(height: 10.0),
                                                GestureDetector(
                                                  onTap: () => onDataPicker(
                                                    analyser: Analyser.industry,
                                                    title: 'Industries',
                                                    list:
                                                        AnalyserData.industries,
                                                  ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          backgroundcolorinterface,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              radiusValue),
                                                    ),
                                                    child: ListTile(
                                                      leading: _industry != null
                                                          ? Text(_industry!)
                                                          : Text(
                                                              'select a industry',
                                                              style: bodyText2
                                                                  .copyWith(
                                                                      color:
                                                                          hintColor),
                                                            ),
                                                      trailing: const Icon(Icons
                                                          .keyboard_arrow_right),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                const Text('Website',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  initialValue: _website,
                                                  onChanged: (val) {
                                                    _website = val;
                                                  },
                                                  keyboardType:
                                                      TextInputType.url,
                                                  // validator: Validator.websiteValidator,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      inputDecoration.copyWith(
                                                    hintStyle: const TextStyle(
                                                      color: iconColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    suffixIcon: _isUniqueName ==
                                                            true
                                                        ? const Icon(
                                                            Icons.check_circle,
                                                            color: Colors.green,
                                                          )
                                                        : Icon(
                                                            Icons.close,
                                                            color: _isUniqueName ==
                                                                    null
                                                                ? Colors
                                                                    .transparent
                                                                : Colors.red,
                                                          ),
                                                    filled: true,
                                                    fillColor:
                                                        const Color(0xffF4F4F4),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                const Text('Instagram',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  initialValue: _instagram,
                                                  onChanged: (val) {
                                                    _instagram = val;
                                                  },
                                                  // validator: (val) =>
                                                  //     Validator
                                                  //         .socialValidator(
                                                  //             val,
                                                  //             "Instagram"),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      inputDecoration.copyWith(
                                                    hintStyle: const TextStyle(
                                                      color: iconColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    // suffixIcon:
                                                    //     _isUniqueName == true
                                                    //         ? const Icon(
                                                    //             Icons
                                                    //                 .check_circle,
                                                    //             color: Colors
                                                    //                 .green,
                                                    //           )
                                                    //         : Icon(
                                                    //             Icons.close,
                                                    //             color: _isUniqueName ==
                                                    //                     null
                                                    //                 ? Colors
                                                    //                     .transparent
                                                    //                 : Colors
                                                    //                     .red,
                                                    //           ),
                                                    filled: true,
                                                    fillColor:
                                                        const Color(0xffF4F4F4),
                                                  ),
                                                ),
                                                const SizedBox(height: 20.0),
                                                const Text('Twitter',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                TextFormField(
                                                  initialValue: _twitter,
                                                  onChanged: (val) {
                                                    _twitter = val;
                                                  },
                                                  // validator: (val) =>
                                                  //     Validator
                                                  //         .socialValidator(
                                                  //             val, "Twitter"),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  decoration:
                                                      inputDecoration.copyWith(
                                                    hintStyle: const TextStyle(
                                                      color: iconColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                        const Color(0xffF4F4F4),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                              ],
                                            ),
                                            const Text('Age Range',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            DropdownButton<String>(
                                              value: _ageRange,
                                              borderRadius:
                                                  BorderRadius.circular(radius),
                                              isExpanded: true,
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                              iconSize: 24,
                                              elevation: 16,
                                              underline: Container(
                                                height: 1,
                                                color: hintColor,
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _ageRange = newValue;
                                                });
                                              },
                                              items: <String>[
                                                '18-24',
                                                '25-34',
                                                '35-44',
                                                '45-54',
                                                '55-64',
                                                '64+'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text('Gender',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            DropdownButton<String>(
                                              value: _gender,
                                              isExpanded: true,
                                              icon: const Icon(Icons
                                                  .keyboard_arrow_down_sharp),
                                              iconSize: 24,
                                              elevation: 16,
                                              underline: Container(
                                                height: 1,
                                                color: hintColor,
                                              ),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  _gender = newValue;
                                                });
                                              },
                                              items: <String>[
                                                'Male',
                                                'Female',
                                                'Other'
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text('Invite ID',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: textColor,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              onChanged: (val) {
                                                _referralId = val;
                                              },
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType: TextInputType.text,
                                              decoration:
                                                  inputDecoration.copyWith(
                                                      hintText:
                                                          'Eg AKUK_D4U16710',
                                                      filled: true,
                                                      fillColor: const Color(
                                                          0xffF4F4F4)),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text('Location',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            const SizedBox(height: 10.0),
                                            CountryListPick(
                                              appBar: AppBar(
                                                leading: IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: SvgPicture.asset(
                                                      'assets/svgs/backbutton.svg'),
                                                ),
                                                centerTitle: true,
                                                // ignore: prefer_const_constructors
                                                title: Text(
                                                  'Select Country',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                              ),
                                              initialSelection:
                                                  _location ?? 'GB',
                                              pickerBuilder: (BuildContext
                                                      context,
                                                  CountryCode? countryCode) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                        backgroundcolorinterface,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            radiusValue),
                                                  ),
                                                  child: ListTile(
                                                    leading: _location != null
                                                        ? Text(_location!)
                                                        : Text(
                                                            'select a location',
                                                            style: bodyText2
                                                                .copyWith(
                                                                    color:
                                                                        hintColor),
                                                          ),
                                                    trailing: const Icon(Icons
                                                        .keyboard_arrow_right),
                                                  ),
                                                );
                                              },
                                              onChanged: (CountryCode? code) {
                                                debugPrint(
                                                    'code: ${code!.code}');
                                                setState(() {
                                                  _location = code.name;
                                                });
                                              },
                                              useSafeArea: false,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const SizedBox(height: 24.0),
                                          ]),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ])),
                        ],
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 1.5,
                        child: ColoredBox(color: backgroundcolorinterface),
                      ),
                      ExpansionTile(
                        trailing: isExpanded
                            ? SvgPicture.asset(
                                'assets/svgs/dropdownexpansionup.svg',
                              )
                            : SvgPicture.asset(
                                'assets/svgs/dropdownexpansion.svg',
                              ),
                        title: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Add Achievements',
                                  style: TextStyle(color: textColor)),
                              TextSpan(
                                  text: ' (Optional)',
                                  style: TextStyle(color: hintColor)),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'You can add up to 3 Achievements',
                                        style: TextStyle(color: subtextColor),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 5),
                                  child: TextFormField(
                                    maxLength: 30,
                                    controller: achievementController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Enter achievement here',
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: achievements.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            width: double.infinity,
                                            height: 1.5,
                                            child: ColoredBox(
                                                color:
                                                    backgroundcolorinterface),
                                          ),
                                          ListTile(
                                            title: Text(achievements[index]),
                                            leading: SizedBox(
                                              width: 30,
                                              height: 30,
                                              child: SvgPicture.asset(
                                                  'assets/svgs/trophy.svg'),
                                            ),
                                            trailing: SizedBox(
                                              width: 25,
                                              height: 25,
                                              child: SvgPicture.asset(
                                                  'assets/svgs/close.svg'),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                achievements.remove(
                                                    achievements[index]);
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        addItemToList();
                                        achievementController.clear();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          'Add Achievement',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 1.5,
                        child: ColoredBox(color: backgroundcolorinterface),
                      ),
                      ExpansionTile(
                        trailing: isExpanded
                            ? SvgPicture.asset(
                                'assets/svgs/dropdownexpansionup.svg',
                              )
                            : SvgPicture.asset(
                                'assets/svgs/dropdownexpansion.svg',
                              ),
                        title: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Add Products & Services',
                                  style: TextStyle(color: textColor)),
                              TextSpan(
                                  text: ' (Optional)',
                                  style: TextStyle(color: hintColor)),
                            ],
                          ),
                        ),
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'You can add up to 7 products and services',
                                              style: TextStyle(
                                                  color: subtextColor),
                                            )
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 20,
                                          bottom: 5),
                                      child: TextField(
                                        controller: productsController,
                                        maxLength: 30,
                                        // ignore: prefer_const_constructors
                                        decoration: InputDecoration(
                                          border: const OutlineInputBorder(),
                                          labelText: 'Add Products & Services',
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: productsandservices.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  width: double.infinity,
                                                  height: 1.5,
                                                  child: ColoredBox(
                                                      color:
                                                          backgroundcolorinterface),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                      productsandservices[
                                                          index]),
                                                  leading: SizedBox(
                                                    width: 28,
                                                    height: 28,
                                                    child: SvgPicture.asset(
                                                        'assets/svgs/product.svg'),
                                                  ),
                                                  trailing: SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child: SvgPicture.asset(
                                                        'assets/svgs/close.svg'),
                                                  ),
                                                  onTap: () {
                                                    setState(() {
                                                      productsandservices.remove(
                                                          productsandservices[
                                                              index]);
                                                    });
                                                  },
                                                )
                                              ],
                                            ));
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: ElevatedButton(
                                        child: const Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Text(
                                            'Add Product',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        onPressed: () {
                                          addItemToproductList();
                                          productsController.clear();
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ])),
                        ],
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 1.5,
                        child: ColoredBox(color: backgroundcolorinterface),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const SizedBox(height: 24),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
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

  Future<void> onDataPicker({
    required Analyser analyser,
    required String title,
    required List<ForDataPicker> list,
  }) async {
    final MyResponse? res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => DataSelectionScreen(
          analyser: analyser,
        ),
      ),
    );

    if (res!.success) {
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

  Future<void> _attemptToComplete() async {
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
    final String token = sandBox.read(Constants.USER_ID);
    ApiResponseModel response =
        await ApiService.put(path: 'users/$token', body: updateData);
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
}
