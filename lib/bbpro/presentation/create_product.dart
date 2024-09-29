import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/multipleedit.dart';
import 'package:business_bosses_v2/bbpro/widgets/switchwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CreateProductListing extends StatefulWidget {
  final Product? product;
  const CreateProductListing({super.key, this.product});

  @override
  // ignore: library_private_types_in_public_api
  _CreateProductListingState createState() => _CreateProductListingState();
}

class _CreateProductListingState extends State<CreateProductListing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final OrderController orderController = Get.put(OrderController());
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.put(ShopController());
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

  bool isSubmitted = false;
  bool _isSwitched = false;

  // Form fields
  String? productName;
  String? price;
  String? discount;
  String? description;
  String? category;
  String country = '';
  List<String>? images = <String>[];
  String? paymentMethod;
  String? deliveryMethod;
  DateTime? startDate;
  DateTime? endDate;
  String? storageLocation;
  int? productNumber;
  int? quantity;
  String? color;
  String? size;
  List<String> paymentMethods = <String>[];

  @override
  void initState() {
    super.initState();
    for (dynamic payments in shopController.shop!.payments) {
      paymentMethods.add(payments['paymentMethod']);
    }
    if (widget.product != null) {
      // initiate Edit Here
      _productNameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
      _discountController.text = widget.product!.discount.toString();
      storageLocationController.text = widget.product!.storageLocation;
      productNumberController.text = widget.product!.productNumber.toString();
      quantityController.text = widget.product!.quantity.toString();
      colorController.text = widget.product!.color;
      sizeController.text = widget.product!.size;
      category = widget.product!.category;
      country = widget.product!.location;
      deliveryMethod = widget.product!.deliveryMethod;
      paymentMethod = widget.product!.paymentMethod;
      startDate = widget.product!.startAt;
      endDate = widget.product!.endAt;
      _isSwitched = widget.product!.isActive;

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
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.product == null
              ? 'Create Product Listing'
              : 'Edit Product Listing',
          style: const TextStyle(
            color: proprimaryColor,
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
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Product Name',
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
                    caption: 'Price',
                    hintText: 'Enter price in USD',
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CustomEditText(
                      padding: 0,
                      caption: 'Discount',
                      hintText: 'Enter discount',
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
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Describe your Product',
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
              caption: 'Select Category',
              hintText: 'Choose a category',
              items: const <String>['Beauty', 'Electronics', 'Fashion', 'Home'],
              iconName: 'assets/svgs/dropdown.svg',
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
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                initialSelection: country,
                pickerBuilder:
                    (BuildContext context, CountryCode? countryCode) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radiusValue),
                    ),
                    child: CustomTextWidget(
                      caption: 'Location',
                      iconName: 'assets/svgs/nexticon.svg',
                      text: country,
                    ),
                  );
                },
                onChanged: (CountryCode? code) async {
                  setState(() {
                    country = code!.name!;
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
                        Text('Add Attachment'),
                        Icon(Icons.image),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.file(
                      _selectedImages[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            CustomDropdownWidget(
              caption: 'Delivery Method',
              hintText: 'Choose a delivery method',
              items: const <String>['Online', 'Courier', 'In-Store Pickup'],
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? newValue) {
                setState(() {
                  deliveryMethod = newValue;
                });
              },
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
                    const Text('Delivery Date'),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Start Date',
                              hintText: _formatDate(startDate),
                            ),
                            onTap: () => _selectDate(context, true),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'End Date',
                              hintText: _formatDate(endDate),
                            ),
                            onTap: () => _selectDate(context, false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomDropdownWidget(
              caption: 'Payment Method',
              hintText: 'Choose a payment method',
              items: paymentMethods,
              iconName: 'assets/svgs/dropdown.svg',
              onChanged: (String? newValue) {
                setState(() {
                  paymentMethod = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Storage Location',
              hintText: 'Enter storage location',
              controller: storageLocationController,
            ),
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Product Number',
              hintText: 'Enter product number',
              inputType: TextInputType.number,
              controller: productNumberController,
            ),
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Quantity',
              hintText: 'Enter quantity',
              inputType: TextInputType.number,
              controller: quantityController,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: MultipleEditTextWidget(
                            padding: const EdgeInsets.all(5),
                            backgroundColor: backgroundColor,
                            buttonSize: 10,
                            caption: 'Color',
                            hintText: 'color',
                            controller: colorController,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MultipleEditTextWidget(
                            backgroundColor: backgroundColor,
                            padding: const EdgeInsets.all(5),
                            buttonSize: 10,
                            caption: 'Size',
                            hintText: 'size',
                            controller: sizeController,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                    'If status is active, this product will show in your shop',
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ProCustomButton(
              loading: isSubmitted,
              text: widget.product != null ? 'Save Changes' : 'Create',
              onPressed: _submitForm,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null &&
        pickedDate != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        isSubmitted = true;
      });
      for (File image in _selectedImages) {
        dynamic response = await ApiService.uploadFile(image);
        if (response['success']) {
          setState(() {
            images!.add(response['fileUrl']);
          });
        }
      }
      final Map<String, dynamic> productListing = <String, dynamic>{
        'userId': profileController.myProfile.uid,
        'shopId': shopController.shop?.id,
        'name': _productNameController.text,
        'price': _priceController.text,
        'discount': _discountController.text,
        'description': _descriptionController.text,
        'category': category,
        'location': country,
        'images': images,
        'paymentMethod': paymentMethod,
        'deliveryMethod': deliveryMethod,
        'url': 'http://example.com/product', // Example URL
        'itemType': 'product',
        'isActive': _isSwitched,
        'supplierId': null,
        'storageLocation': storageLocationController.text,
        'productNumber': productNumberController.text,
        'quantity': quantityController.text,
        'startAt': startDate?.toIso8601String(),
        'endAt': endDate?.toIso8601String(),
        'color': colorController.text,
        'size': sizeController.text,
      };
      if (widget.product == null) {
        bool response = await shopController.addProducts(productListing);
        if (response) {
          showSnackbar(
            message: 'Product Added Successfully!',
          );
          Navigator.pop(context);
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
          Navigator.pop(context);
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
  }
}
