import 'dart:io';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';
import '../../../common/models/api_response_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/gallery_screen.dart';
import '../../../common/widgets/text_widget.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/widgets/field_container.dart';
import '../../posts/widgets/preview.dart';
import '../../profile/controller/profile_controller.dart';
import '../controllers/create_market_controller.dart';
import '../controllers/market_controller.dart';
import '../models/market_model.dart';
import 'boost_market_screen.dart';

class CreateSellingitemScreen extends StatefulWidget {
  const CreateSellingitemScreen({Key? key, this.market, required this.isUpd})
      : super(key: key);
  // String topicType;
  final MarketModel? market;
  final bool isUpd;
  // CreateSellingitemScreen();
  @override
  _CreateSellingitemScreenState createState() =>
      _CreateSellingitemScreenState();
}

class _CreateSellingitemScreenState extends State<CreateSellingitemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProfileController _profileController = Get.find();
  final MarketController _marketController = Get.find();
  final CreateMarketController createMarketController =
      Get.put(CreateMarketController());
  List<File>? _resourceFile;
  List<bool>? _fileProcessing;

  List<MyAssetEntity> _myAssetsEntities = [];

  MarketModel? _market;

  String? description;
  String? price;
  String? _selectedCategory;
  String? _selectedLocation;
  String? filterCode;
  String? filterLocation;
  String? filterCategory;

  bool _isProcessing = false;
  bool? _isUpdating;
  bool _shouldPromote = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isUpdating = widget.isUpd;
    if (widget.isUpd) {
      _market = MarketModel(
          marketId: '',
          category: '',
          userId: '',
          price: '1',
          description: '',
          location: '',
          user: UserModel());
    }
    _resourceFile = [];
    _fileProcessing = [];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<CreateMarketController>(
        builder: (CreateMarketController controller) {
      return GestureDetector(
        onTap: () => unFocusKeyboard(context),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Create Listing'),
            automaticallyImplyLeading: false, // Used for removing back buttoon.
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: price,
                  onChanged: (String val) => price = val,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  decoration: inputDecoration.copyWith(
                    hintText: 'Enter Price in USD (Example \$10)',
                  ),
                ),
                const SizedBox(height: 24.0),
                DetectableTextField(
                  controller: TextEditingController(text: description),

                  detectionRegExp: detectionRegExp(hashtag: false)!,
                  onDetectionTyped: (String text) {},
                  onDetectionFinished: () {},
                  keyboardType: TextInputType.multiline,
                  // minLines: 5,
                  maxLength: 300,
                  maxLines: 5,
                  basicStyle: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (String val) => description = val,

                  decoration: inputDecoration.copyWith(
                    hintText: 'Describe your Listing',
                  ),
                ),
                const SizedBox(height: 12.0),
                Container(
                  decoration: BoxDecoration(
                    color: backgroundcolorinterface,
                    borderRadius: BorderRadius.circular(radiusValue),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16,
                    top: 4,
                    bottom: 5,
                  ),
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: _selectedCategory,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_right),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategory = newValue!;
                      });
                    },
                    items: <String?>[
                      null,
                      'Home, Garden & Outdoors',
                      'Fashion & Beauty',
                      'Sports & Entertainment',
                      'Books & Education',
                      'Jewellery & Timepieces',
                      'Security, Safety & Equipment',
                      'Video Games & Electronics',
                      'Agriculture, Food, Beverage',
                      'Construction & Real Estate',
                      'Vehicle & Transportation',
                      'Business Services & Events',
                      'Other',
                    ].map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: value != null
                            ? Text(value)
                            : Text(
                                value ?? 'Select Category',
                                style: bodyText2.copyWith(
                                  color: hintColor,
                                ),
                              ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12.0),
                CountryListPick(
                  appBar: AppBar(
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                    ),
                    centerTitle: true,
                    // ignore: prefer_const_constructors
                    title: Text(
                      'Select Location',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  initialSelection: _selectedLocation,
                  pickerBuilder:
                      (BuildContext context, CountryCode? countryCode) {
                    return Container(
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(radiusValue),
                      ),
                      child: ListTile(
                        leading: _selectedLocation != null
                            ? Text(_selectedLocation!)
                            : Text(
                                'Location',
                                style: bodyText2.copyWith(color: hintColor),
                              ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                    );
                  },
                  onChanged: (CountryCode? code) {
                    setState(() {
                      _selectedLocation = code!.name!;
                    });
                  },
                  useSafeArea: false,
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    if (createMarketController.imageFileList.length < 5) {
                      createMarketController.onPickImage();
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
                Preview(controller: createMarketController),
                Column(
                  children: [
                    SizedBox(
                      height: 55,
                      child: Align(
                        alignment: Alignment.center,
                        child: SwitchListTile(
                          value: _shouldPromote,
                          onChanged: (bool value) {
                            setState(() {
                              _shouldPromote = value;
                            });
                          },
                          title: Row(
                            children: [
                              SvgPicture.asset('assets/svgs/rocket.svg'),
                              const SizedBox(
                                width: 30,
                              ),
                              const Text(
                                'Boost Post',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (_shouldPromote)
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                'assets/images/boostbanner.png',
                                width: size.width,
                                height: size.width / 2,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Positioned(
                              bottom: 20,
                              left: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Reach\na Wider Audience',
                                    color: Color(0xFFFFFFFF),
                                    fontWeight: FontWeight.w800,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_box,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextWidget(
                                        text: 'More Goods/Service Sale',
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check_box,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TextWidget(
                                        text: 'More connections',
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    const SizedBox(height: 24.0),
                  ],
                ),
                MCustomButton(
                  onPressed: () async {
                    if ((description?.isEmpty == true) ||
                        (price?.isEmpty == true)) {
                      showSnackBar(context,
                          message:
                              'Please select price and description to create a listing');
                      return;
                    } else {
                      await _onChangeForum();
                    }
                  },
                  label: _isUpdating! ? 'Update' : 'Sell',
                  isProcessing: _isProcessing,
                  buttonType: ButtonType.elevated,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _onChangeForum() async {
    _resourceFile?.clear();
    unFocusKeyboard(context);
    setState(() {
      _isProcessing = true;
    });
    Map<String, dynamic> data = <String, dynamic>{
      'category': _selectedCategory,
      'location': _selectedLocation,
      'description': description,
      'price': price,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'images': createMarketController.imageFileList
    };
    ApiResponseModel response =
        await ApiService.post(path: 'markets', body: data);
    setState(() {
      _isProcessing = false;
    });
    dynamic mId = response.data['marketId'];
    _marketController.addNewPost({
      ...data,
      'marketId': mId,
    }, _profileController);
    setState(() {});
    if (_shouldPromote) {
      Get.to(() => BoostMarket(
            postId: mId,
          ));
    } else {
      Get.back();
    }

    // setState(() {
    //   _isProcessing = true;
    // });

    // List<String> fileUrls = [];

    // for (int i = 0; i < _myAssetsEntities.length; i++) {
    //   File? file = await toFile(_myAssetsEntities[i]);
    //   _resourceFile?.add(file!);
    // }

    // for (int i = 0; i < _resourceFile!.length; i++) {
    //   final int bytes = _resourceFile![i].readAsBytesSync().lengthInBytes;
    //   final double kb = bytes / 1024;
    //   final double mb = kb / 1024;
    //   if (mb >= 3) {
    //     setState(() {
    //       _isProcessing = false;
    //     });
    //     showSnackBar(context, message: 'Image size should be maximum 3 MB.');
    //     return;
    //   }

    //   // Call the image upload API and obtain the image URL
    //   final dynamic res = await ApiService.uploadFile(_resourceFile![i]);
    //   if (res == null) {
    //     return;
    //   } else {
    //     fileUrls.add(res['fileUrl']);
    //   }
    // }
    // print(fileUrls);

    // setState(() {
    //   _isProcessing = false;
    // });

    // final appUser = Provider.of<UserController>(context, listen: false);
    // final appForums = Provider.of<AppCommunities>(context, listen: false);
    // _resourceFile?.clear();
    // unFocusKeyboard(context);
    // setState(() {
    //   _isProcessing = true;
    // });
    // for (int i = 0; i < _myAssetsEntities.length; i++) {
    //   Future<File?>? file = await toFile(_myAssetsEntities[i]);
    //   _resourceFile?.add(file);
    // }
    // List<String> fileUrls = [];
    // int l = _resourceFile.length;
    // for (int i = 0; i < l; i++) {
    //   final bytes = _resourceFile[i].readAsBytesSync().lengthInBytes;
    //   final kb = bytes / 1024;
    //   final mb = kb / 1024;
    //   if (mb >= 3) {
    //     setState(() {
    //       _isProcessing = false;
    //     });
    //     showSnackBar(context, message: 'Image size should be maximum 3 MB.');
    //     return;
    //   }
    //   MyResponse res = await _firebase.uploadFile(_resourceFile[i]);
    //   if (res.success) {
    //     fileUrls.add(res.data.toString());
    //     // setState(() {
    //     //   _fileProcessing[i] = true;
    //     // });
    //   }
    // }
    // if (_myAssetsEntities.length == fileUrls.length) {
    //   _forum.industryId = _forum.industryId ?? _industry.industryId;
    //   _forum.uid = _forum.uid ?? _firebase.uid;
    //   // title: _titleController.text;
    //   // description: _desController.text;
    //   _forum.categoryId = _forum.categoryId ?? _industry?.categoryId;
    //   _forum.user = appUser.user;
    //   _forum.timestamp =
    //       _forum.timestamp ?? DateTime.now().millisecondsSinceEpoch;
    //   _forum.forumId = _forum.forumId =
    //       _forum.forumId ?? _firebase.uniqueKey(Constants.FORUMS);

    //   _forum.images ??= [];
    //   _forum.images.addAll(fileUrls);

    //   } else {

    //       // updateBossOfTheWeekTimeStamp();
    //       _isUpdating = false;

    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (BuildContext context) => const BottomNavScreen(2, true),
    //         ),
    //       );
    //   }
    // } else {
    //   setState(() {
    //     _isProcessing = false;
    //   });
    //   showSnackBar(context,
    //       message: 'An error occurred. Please try again later.');
    // }
  }

  Future<void> _onImagePicker() async {
    try {
      PermissionState permissionState =
          await PhotoManager.requestPermissionExtend();

      if (permissionState.isAuth ||
          permissionState == PermissionState.limited) {
        var data = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GalleryPhotosScreen(
              galleryType: GalleryType.images,
              selectedMyAssetEntities: _myAssetsEntities,
            ),
          ),
        );
        if (data == null) return;
        setState(() {
          _myAssetsEntities = data;
          _fileProcessing =
              List.generate(_myAssetsEntities.length, (int index) => false);
        });
      } else if (permissionState == PermissionState.denied) {
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (!ps.isAuth) {
          PhotoManager.openSetting();
        }
      }
    } catch (e) {}
  }

  void _removeImage(int index) {
    List<MyAssetEntity> ae = _myAssetsEntities;

    ae.removeAt(index);
    setState(() {
      _myAssetsEntities = ae;
      _fileProcessing?.removeAt(index);
    });
  }

  Widget _deleteImage(int index) {
    return Positioned(
      right: 5.0,
      top: 5.0,
      child: GestureDetector(
        onTap: _isProcessing ? null : () => _removeImage(index),
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
    );
  }
}
