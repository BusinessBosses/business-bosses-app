import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/boost_items.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/multipleedit.dart';
import 'package:business_bosses_v2/bbpro/widgets/switchwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateProductListing extends StatefulWidget {
  final bool? isMarketplace;
  final Product? product;
  const CreateProductListing({super.key, this.product, this.isMarketplace});

  @override
  // ignore: library_private_types_in_public_api
  _CreateProductListingState createState() => _CreateProductListingState();
}

class _CreateProductListingState extends State<CreateProductListing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileController profileController = Get.find();
  final ShopController shopController =
      Get.put(ShopController(), permanent: true);
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = <File>[];
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController storageLocationController =
      TextEditingController();
  final TextEditingController productNumberController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController currencycontroller = TextEditingController();
  final TextEditingController deliverydayscontroller = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  bool isSubmitted = false;
  bool _isSwitched = true;
  bool isExpanded = false;
  bool loading = false;
  final List<String> categories = <String>[
    'Agriculture, Food & Beverage',
    'Books & Education',
    'Construction & Real Estate',
    'Fashion & Beauty',
    'Finance & Legal',
    'Healthcare & Wellness',
    'Home, Gardens & Outdoors',
    'Jewellery & Timepieces',
    'Media & Entertainment',
    'Security, Safety & Equipment',
    'Technology, Games & Electronic',
    'Vehicle & Transportation'
  ];

  // Form fields
  String? productName;
  String? price;
  String? discount;
  String? description;
  String? category;
  String country = '';
  List<String>? images = <String>[];
  List<String>? updateImages = <String>[];
  String? paymentMethod;
  String? deliveryMethod;
  String? deliveryDuration;
  DateTime? startDate;
  DateTime? endDate;
  String? storageLocation;
  int? productNumber;
  int? quantity;
  String? color;
  String? size;
  List<String> paymentMethods = <String>[];
  List<String> colors = <String>[];
  List<String> sizes = <String>[];
  final bool _shouldPromote = true;

  @override
  void initState() {
    super.initState();
    if (shopController.shop == null) {
      loading = true;
      shopController.initShopData().then((bool value) {
        loading = false;
      });
    }
    for (dynamic payments in shopController.shop!.payments) {
      paymentMethods.add(payments['paymentMethod']);
    }
    currencycontroller.text = shopController.shop?.location != null
        ? '${currencyValues[shopController.shop!.location.toString()]}'
        : 'USD';

    if (widget.product != null) {
      // initiate Edit Here
      _productNameController.text = widget.product!.name;
      notesController.text = widget.product!.notes ?? '';
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
      _discountController.text = widget.product!.discount.toString();
      storageLocationController.text = widget.product!.storageLocation != null
          ? widget.product!.storageLocation!
          : '';
      productNumberController.text = widget.product!.productNumber.toString();
      quantityController.text = widget.product!.quantity.toString();
      colorController.text = widget.product!.color?.join(', ') ?? '';
      updateImages = widget.product!.images;
      images = widget.product!.images;
      deliveryDuration = widget.product!.deliveryDuration;
      sizeController.text = widget.product!.size?.join(', ') ?? '';
      category = widget.product!.category;

      country = widget.product!.location != null
          ? widget.product!.location!
          : shopController.shop!.location;
      deliveryMethod = widget.product!.deliveryMethod;
      paymentMethod = widget.product!.paymentMethod;
      startDate = widget.product!.startAt;
      endDate = widget.product!.endAt;
      _isSwitched = widget.product!.isActive;
      deliverydayscontroller.text = widget.product!.deliveryDuration ?? '';
      sizes = widget.product!.size!;
      colors = widget.product!.color!;

      // If images exist in the product model, you can populate the image list as well
      if (widget.product!.images != null) {
        images = widget.product!.images;
        // If you have the image paths, you can convert them to File and add them to _selectedImages.
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.product == null
              ? 'Create Product Listing'
              : 'Edit Product Listing',
          style: const TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
      body: loading
          ? const SafetyModel()
          : Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  const SizedBox(height: 16),
                  CustomEditText(
                    caption: 'Product Name *',
                    maxLength: 30,
                    hintText: 'Enter product name here',
                    controller: _productNameController,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a product name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: CustomEditText(
                          currencycontroller: currencycontroller,
                          caption: 'Price *',
                          iscurrencyfield: true,
                          maxLength: 15,
                          hintText: 'Enter price',
                          controller: _priceController,
                          inputType: TextInputType.number,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomEditText(
                          isps: true,
                          caption: 'Discount (%)',
                          hintText: 'Enter discount',
                          maxLength: 15,
                          controller: _discountController,
                          inputType: TextInputType.number,
                          validator: (String? value) {
                            if (value != null && value.isNotEmpty) {
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomEditText(
                    caption: 'Describe your Product *',
                    hintText: 'Add product description here',
                    controller: _descriptionController,
                    maxLength: 300,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomDropdownWidget(
                    caption: 'Select Category *',
                    hintText: 'Choose a category',
                    items: categories,
                    iconName: 'assets/svgs/dropdown.svg',
                    initialValue: category,
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: CountryListPick(
                      appBar: AppBar(
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                        ),
                        centerTitle: true,
                        title: const Text(
                          'Select Location',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      initialSelection: country.isEmpty
                          ? shopController.shop!.location
                          : country,
                      pickerBuilder:
                          (BuildContext context, CountryCode? countryCode) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(radiusValue),
                          ),
                          child: CustomTextWidget(
                            caption: 'Location *',
                            iconName: 'assets/svgs/nexticon.svg',
                            text: country.isEmpty
                                ? shopController.shop!.location
                                : country,
                          ),
                        );
                      },
                      onChanged: (CountryCode? code) async {
                        setState(() {
                          country = code!.name!;
                          currencycontroller.text =
                              '${currencyValues[code.name.toString()]}';
                        });
                      },
                      useSafeArea: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(radiusValue),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Add Attachment',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                              Icon(Icons.image),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedImages.isNotEmpty || updateImages!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (_selectedImages.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemCount: _selectedImages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Image.file(
                                        _selectedImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.removeAt(index);
                                          });
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 12,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          const SizedBox(height: 16),
                          if (updateImages!.isNotEmpty)
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                              ),
                              itemCount: updateImages!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: Image.network(
                                        updateImages![index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            updateImages!.removeAt(index);
                                          });
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 12,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  CustomEditText(
                    maxLength: 30,
                    caption: 'Quantity *',
                    hintText: 'Enter quantity',
                    inputType: TextInputType.number,
                    controller: quantityController,
                  ),
                  const SizedBox(height: 16),
                  ExpansionTile(
                      initiallyExpanded: true,
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
                      children: <Widget>[
                        CustomDropdownWidget(
                          caption: 'Delivery Method',
                          hintText: 'Choose a delivery method',
                          initialValue: deliveryMethod,
                          items: const <String>[
                            'Online',
                            'Courier',
                            'In-Store Pickup'
                          ],
                          iconName: 'assets/svgs/dropdown.svg',
                          onChanged: (String? newValue) {
                            setState(() {
                              deliveryMethod = newValue;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomEditText(
                          maxLength: 30,
                          inputType: const TextInputType.numberWithOptions(
                              decimal: false),
                          caption: 'Delivery Duration (Days)',
                          hintText:
                              'Enter number of days you can deliver after purchase',
                          controller: deliverydayscontroller,
                        ),
                        const SizedBox(height: 16),
                        CustomEditText(
                          maxLength: 30,
                          caption: 'Storage Location',
                          hintText: 'Enter storage location',
                          controller: storageLocationController,
                        ),
                        const SizedBox(height: 16),
                        CustomEditText(
                          maxLength: 30,
                          caption: 'Product Number',
                          hintText: 'Enter product number',
                          inputType: TextInputType.number,
                          controller: productNumberController,
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Product Variations',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    MultipleEditTextWidget(
                                      padding: const EdgeInsets.all(5),
                                      backgroundColor: backgroundColor,
                                      buttonSize: 20,
                                      caption: 'Color',
                                      hintText: 'color',
                                      initialValues: colors,
                                      onValuesChanged: (List<String> values) {
                                        setState(() {
                                          colors = values;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    MultipleEditTextWidget(
                                      padding: const EdgeInsets.all(5),
                                      backgroundColor: backgroundColor,
                                      buttonSize: 20,
                                      caption: 'Size',
                                      hintText: 'size',
                                      initialValues: sizes,
                                      onValuesChanged: (List<String> values) {
                                        setState(() {
                                          sizes = values;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomEditText(
                          caption: 'Notes',
                          hintText: 'Add order notes here',
                          controller: notesController,
                          maxLength: 300,
                        ),
                      ]),
                  const SizedBox(height: 16),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //   child: SwitchWidget(
                  //     value: _shouldPromote,
                  //     onChanged: (bool value) {
                  //       setState(() {
                  //         _shouldPromote = value;
                  //       });
                  //     },
                  //     icon: 'assets/svgs/rocket.svg',
                  //     caption: 'Boost this listing',
                  //     subtext: 'Reach a wider audience and get more views',
                  //     activeColor: widget.isMarketplace != null
                  //         ? primaryColorLT
                  //         : proprimaryColor,
                  //     inactiveColor: Colors.grey,
                  //   ),
                  // ),
                  // const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SwitchWidget(
                      value: _isSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          _isSwitched = value;
                        });
                      },
                      caption: 'Status',
                      subtext:
                          'This listing will show in your biz-centre and business bosses marketplace',
                      activeColor: widget.isMarketplace != null
                          ? primaryColorLT
                          : proprimaryColor,
                      inactiveColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProCustomButton(
                    color: widget.isMarketplace != null
                        ? primaryColorLT
                        : proprimaryColor,
                    loading: isSubmitted,
                    text: widget.product != null
                        ? 'Save Changes'
                        : 'Create Product',
                    onPressed: () async {
                      if (_productNameController.text.isEmpty) {
                        showSnackbar(
                            message: 'Enter product name', error: true);
                        return;
                      }

                      if (category == null) {
                        showSnackbar(message: 'Select a category', error: true);
                        return;
                      }

                      if (_priceController.text.isEmpty) {
                        showSnackbar(message: 'Enter price', error: true);
                        return;
                      }

                      if (_shouldPromote && !_isSwitched) {
                        showSnackbar(
                            message: 'You cannot boost a non-active product',
                            error: true);
                        return;
                      }

                      if (quantityController.text.isEmpty) {
                        showSnackbar(message: 'Enter quantity', error: true);
                        return;
                      }
                      _showBoostBottomSheet();
                    },
                  ),
                  const SizedBox(height: 16),
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
                              children: <InlineSpan>[
                                const TextSpan(
                                  text:
                                      'By clicking on Create Product, you confirm that you will abide by the ',
                                  style: TextStyle(
                                      fontSize: 12, color: subtextColor),
                                ),
                                TextSpan(
                                  text: 'Biz-Center Guidelines',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: widget.isMarketplace != null
                                        ? primaryColorLT
                                        : proprimaryColor,
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            sellingGuide(context),
                                      );
                                    },
                                ),
                                const TextSpan(
                                  text:
                                      ', and declare that the listing does not include any Prohibited Items',
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
    );
  }

  void _showBoostBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/svgs/rocket.svg',
                        color: textColor,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        'Boost Post',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Reach a wider audience and get more views',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Do you want to boost this post/listing?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            widget.isMarketplace == true
                                ? primaryColorLT
                                : proprimaryColor)),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();

                        setState(() {
                          isSubmitted = true;
                        });
                        List<String> finalImages =
                            List<String>.from(updateImages ?? <String>[]);

                        for (File image in _selectedImages) {
                          final dynamic response =
                              await ApiService.uploadFile(image);
                          if (response['success']) {
                            finalImages.add(response['fileUrl']);
                          }
                        }
                        final Map<String, dynamic> productListing =
                            <String, dynamic>{
                          'userId': profileController.myProfile.uid,
                          'shopId': shopController.shop?.id,
                          'name': _productNameController.text,
                          'price': _priceController.text,
                          'discount': _discountController.text.isEmpty
                              ? 0
                              : _discountController.text,
                          'description': _descriptionController.text,
                          'category': category,
                          'location': country.isEmpty
                              ? shopController.shop!.location
                              : country,
                          'images': finalImages,
                          'paymentMethod': paymentMethod,
                          'deliveryMethod': deliveryMethod,
                          'url': 'http://example.com/product',
                          'notes': notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                          'deliveryDuration': deliverydayscontroller.text,
                          'itemType': 'product',
                          'isActive': _isSwitched,
                          'supplierId': null,
                          'storageLocation': storageLocationController.text,
                          'productNumber': productNumberController.text,
                          'quantity': quantityController.text.isEmpty
                              ? 0
                              : quantityController.text,
                          'startAt': startDate?.toIso8601String(),
                          'endAt': endDate?.toIso8601String(),
                          'color': colors,
                          'size': sizes,
                        };
                        if (widget.product == null) {
                          ProductAddResult response =
                              await shopController.addProducts(productListing);
                          if (response.success) {
                            showSnackbar(
                              message: 'Product Added Successfully!',
                            );
                            Get.off(() => BoostItem(
                                  product: response.product,
                                ));
                          } else {
                            showSnackbar(
                              message: 'Error While Adding Product',
                              error: true,
                            );
                          }
                        } else {
                          bool response = await shopController.updateProduct(
                              widget.product!.id, productListing);
                          if (response) {
                            showSnackbar(
                              message: 'Product Updated Successfully!',
                            );
                            Get.off(() => BoostItem(
                                  product: widget.product,
                                ));
                            return;
                          } else {
                            showSnackbar(
                              message: 'Error While Updating Product',
                              error: true,
                            );
                          }
                        }
                        setState(() {
                          isSubmitted = false;
                        });
                      }
                    },
                    child: const Text('Yes'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: widget.isMarketplace == true
                          ? primaryColorLT
                          : proprimaryColor,
                      side: BorderSide(
                          color: widget.isMarketplace == true
                              ? primaryColorLT
                              : proprimaryColor,
                          width: 1),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();

                        setState(() {
                          isSubmitted = true;
                        });
                        List<String> finalImages =
                            List<String>.from(updateImages ?? <String>[]);

                        for (File image in _selectedImages) {
                          final dynamic response =
                              await ApiService.uploadFile(image);
                          if (response['success']) {
                            finalImages.add(response['fileUrl']);
                          }
                        }
                        final Map<String, dynamic> productListing =
                            <String, dynamic>{
                          'userId': profileController.myProfile.uid,
                          'shopId': shopController.shop?.id,
                          'name': _productNameController.text,
                          'price': _priceController.text,
                          'discount': _discountController.text.isEmpty
                              ? 0
                              : _discountController.text,
                          'description': _descriptionController.text,
                          'category': category,
                          'location': country.isEmpty
                              ? shopController.shop!.location
                              : country,
                          'images': finalImages,
                          'paymentMethod': paymentMethod,
                          'deliveryMethod': deliveryMethod,
                          'url': 'http://example.com/product',
                          'notes': notesController.text.trim().isEmpty
                              ? null
                              : notesController.text.trim(),
                          'deliveryDuration': deliverydayscontroller.text,
                          'itemType': 'product',
                          'isActive': _isSwitched,
                          'supplierId': null,
                          'storageLocation': storageLocationController.text,
                          'productNumber': productNumberController.text,
                          'quantity': quantityController.text.isEmpty
                              ? 0
                              : quantityController.text,
                          'startAt': startDate?.toIso8601String(),
                          'endAt': endDate?.toIso8601String(),
                          'color': colors,
                          'size': sizes,
                        };
                        if (widget.product == null) {
                          ProductAddResult response =
                              await shopController.addProducts(productListing);
                          if (response.success) {
                            Get.back();
                            showSnackbar(
                              message: 'Product Added Successfully!',
                            );
                          } else {
                            showSnackbar(
                              message: 'Error While Adding Product',
                              error: true,
                            );
                          }
                        } else {
                          bool response = await shopController.updateProduct(
                              widget.product!.id, productListing);
                          if (response) {
                            Get.back();
                            showSnackbar(
                              message: 'Product Updated Successfully!',
                            );
                          } else {
                            showSnackbar(
                              message: 'Error While Updating Product',
                              error: true,
                            );
                          }
                        }
                        setState(() {
                          isSubmitted = false;
                        });
                      }
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
