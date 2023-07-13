import 'package:business_bosses_v2/services/api_service.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/gallery_screen.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/widgets/field_container.dart';
import '../../posts/widgets/preview.dart';
import '../../profile/controller/profile_controller.dart';
import '../controllers/create_market_controller.dart';
import '../controllers/market_controller.dart';
import '../models/market_model.dart';

/// SELLING SCREEN MARKETPLACE
class CreateSellingitemScreen extends StatefulWidget {
  /// SELLING SCREEN MARKETPLACE
  const CreateSellingitemScreen({Key? key, this.market, required this.isUpd})
      : super(key: key);

  /// String if to update;
  final MarketModel? market;
  final bool isUpd;
  // CreateSellingitemScreen();
  @override
  _CreateSellingitemScreenState createState() =>
      _CreateSellingitemScreenState();
}

class _CreateSellingitemScreenState extends State<CreateSellingitemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  final ProfileController _profileController = Get.find();
  // ignore: unused_field
  final MarketController _marketController = Get.find();
  final CreateMarketController createMarketController =
      Get.put(CreateMarketController());
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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isUpdating = widget.isUpd;
    if (widget.isUpd) {
      _market = widget.market;
    }
    descriptionController.text = _market?.description ?? '';
    _priceController.text = _market?.price ?? '';
    _selectedCategory = _market?.category;
    _selectedLocation = _market?.location;
    _fileProcessing = [];
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateMarketController>(
        builder: (CreateMarketController controller) {
      return GestureDetector(
        onTap: () => unFocusKeyboard(context),
        child: Scaffold(
          backgroundColor: backgroundcolorinterface,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.isUpd ? 'Edit Listing' : 'Create Listing'),
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
            padding: const EdgeInsets.only(top: 16.0, left: 0.0, right: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: TextFormField(
                    controller: _priceController,
                    onChanged: (String val) => price = val,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    maxLength: 15,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Enter Price in USD (Example \$10)',
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: DetectableTextField(
                    controller: descriptionController,

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
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radiusValue),
                    ),
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                      top: 4,
                      bottom: 5,
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
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
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: CountryListPick(
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
                          color: Colors.white,
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
                ),
                const SizedBox(
                  height: 12,
                ),
                widget.isUpd
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: GestureDetector(
                          onTap: () {
                            if (createMarketController.imageFileList.length <
                                5) {
                              createMarketController.onPickImage();
                            } else {
                              showSnackbar(
                                  message:
                                      'You can only upload up to 5 images.');
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
                                CircleAvatar(
                                  radius: 26 / 1.38,
                                  backgroundColor: backgroundColor,
                                  child: SvgPicture.asset(
                                    'assets/svgs/addimagepost.svg',
                                    height: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                widget.isUpd
                    ? Container()
                    : Preview(controller: createMarketController),
                widget.isUpd
                    ? Container()
                    : Column(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                      children: [
                                        const Text(
                                          'No',
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700),
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
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700),
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
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: MCustomButton(
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });
                      if (descriptionController.text.isEmpty ||
                          _priceController.text.isEmpty) {
                        showSnackBar(
                          context,
                          message:
                              'Please enter price and description to create a listing',
                        );
                        setState(() {
                          _isProcessing = false;
                        });
                        return;
                      } else {
                        await _onChangeForum();
                      }
                      setState(() {
                        _isProcessing = false;
                      });
                    },
                    label: _isUpdating! ? 'Update' : 'Sell',
                    isProcessing: _isProcessing,
                    buttonType: ButtonType.elevated,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 20,
                      bottom: 50,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text:
                                    'By clicking on Post, you accept the Terms of Use, confirm that you will abide by the ',
                                style: TextStyle(
                                    fontSize: 12, color: subtextColor),
                              ),
                              TextSpan(
                                text: 'Marketplace Guidelines',
                                style: const TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Show the popup here
                                  },
                              ),
                              const TextSpan(
                                text:
                                    ', and declare that this posting does not include any Prohibited Items.',
                                style: TextStyle(
                                    fontSize: 12, color: subtextColor),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _onChangeForum() async {
    if (widget.isUpd == false) {
      await createMarketController.createForum(<String, dynamic>{
        'category': _selectedCategory,
        'location': _selectedLocation,
        'description': description,
        'price': price,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }, _shouldPromote);
    } else {
      await _marketController.updatePost(<String, dynamic>{
        'marketId': _market?.marketId,
        'category': _selectedCategory,
        'location': _selectedLocation,
        'description': descriptionController.text,
        'price': _priceController.text,
        'promote': _market?.promote,
        'likes': _market?.likes,
        'comments':
            _market?.comments?.map((CommentModel x) => x.toMap()).toList(),
        'coins': _market?.coins,
        'images': _market?.images,
        'userId': _market?.userId,
        'user': _market?.user.toMap(),
      });
      await ApiService.put(path: 'markets/${_market?.marketId}', body: {
        'category': _selectedCategory,
        'location': _selectedLocation,
        'description': descriptionController.text,
        'price': _priceController.text,
        'images': _market?.images,
      });
      Get.back();
    }
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
