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
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/field_container.dart';
import '../../../common/widgets/gallery_screen.dart';
import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../utils/theme/theme.dart';
import '../../home/bottom_nav.dart';
import '../../profile/controller/profile_controller.dart';
import '../models/market_model.dart';

class CreateSellingitemScreen extends StatefulWidget {
  CreateSellingitemScreen({Key? key, this.market, required this.isUpd})
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final ProfileController _profileController = Get.find();
  List<File>? _resourceFile;
  List<bool>? _fileProcessing;

  List<MyAssetEntity> _myAssetsEntities = [];

  MarketModel? _market;

  bool _isProcessing = false;
  bool? _isUpdating;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isUpdating = widget.isUpd;
    if (widget.isUpd) {
      MarketModel _market = MarketModel(
          marketId: '',
          category: '',
          userId: '',
          price: 1,
          description: '',
          location: '',
          user: UserModel());
    }
    _resourceFile = [];
    _fileProcessing = [];
  }

  @override
  Widget build(BuildContext context) {
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
                initialValue: _market?.price.toString(),
                onChanged: (val) => _market!.price = int.parse(val),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                maxLength: 15,
                decoration: inputDecoration.copyWith(
                  hintText: 'Enter Price in USD (Example \$10)',
                ),
              ),
              const SizedBox(height: 24.0),
              DetectableTextField(
                controller: TextEditingController(text: _market?.description),

                detectionRegExp: detectionRegExp(hashtag: false)!,
                onDetectionTyped: (text) {},
                onDetectionFinished: () {},
                keyboardType: TextInputType.multiline,
                // minLines: 5,
                maxLength: 300,
                maxLines: 5,
                basicStyle: Theme.of(context).textTheme.bodyText2,
                onChanged: (String val) => _market!.description = val,

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
                  value: _market?.category,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_right),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      _market!.category = newValue!;
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
                initialSelection: _market?.location,
                pickerBuilder:
                    (BuildContext context, CountryCode? countryCode) {
                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(radiusValue),
                    ),
                    child: ListTile(
                      leading: _market?.location != null
                          ? Text(_market!.location)
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
                    _market?.location = code!.name!;
                  });
                },
                useSafeArea: false,
              ),
              const SizedBox(
                height: 12,
              ),
              GestureDetector(
                onTap: _onImagePicker,
                child: FieldContainer(
                  message: '',
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svgs/file.svg'),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text('Add Attachment',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: hintColor)),
                      ),
                      const SizedBox(width: 16.0),
                      SvgPicture.asset('assets/svgs/upload.svg'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              if (_myAssetsEntities.isNotEmpty)
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _myAssetsEntities.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 5
                        : 3,
                    // crossAxisSpacing: 8,
                    // mainAxisSpacing: 8,
                    childAspectRatio: (1 / 1),
                  ),
                  itemBuilder: (BuildContext context, i) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: AssetViewer(
                              image: _myAssetsEntities[i].thumbnail,
                              height: 150.0,
                              width: 150.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          (!_fileProcessing![i] && _isProcessing)
                              ? const Center(
                                  child: SizedBox(
                                    height: 22.0,
                                    width: 22.0,
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : Container(),
                          _deleteImage(i),
                        ],
                      ),
                    );
                  },
                ),
              if ((_market?.images?.isNotEmpty ?? false))
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _market?.images?.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 5
                        : 3,
                    childAspectRatio: (1 / 1),
                  ),
                  itemBuilder: (BuildContext context, i) {
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: NetworkImageWithPlaceHolder(
                              imageUrl: _market!.images?[i],
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
                                _market!.images!.removeAt(i);
                                setState(() {});
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
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24.0),
              MCustomButton(
                onPressed: () {
                  if ((_market!.description.isEmpty) ||
                      (_market!.description.isEmpty)) {
                    showSnackBar(context,
                        message:
                            'Please select title and description to create a listing');
                    return;
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
  }

  Future<void> _onChangeForum() async {
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

  _onImagePicker() async {
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
              List.generate(_myAssetsEntities.length, (index) => false);
        });
      } else if (permissionState == PermissionState.denied) {
        final PermissionState _ps =
            await PhotoManager.requestPermissionExtend();
        if (!_ps.isAuth) {
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
