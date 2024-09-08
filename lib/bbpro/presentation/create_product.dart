import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
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
  const CreateProductListing({super.key});

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
        title: const Text(
          'Create Product Listing',
          style: TextStyle(
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
              onChanged: (String value) {
                setState(() {
                  productName = value;
                });
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
                    onChanged: (String value) {
                      setState(() {
                        price = value;
                      });
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
                      onChanged: (String value) {
                        setState(() {
                          discount = value;
                        });
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
              onChanged: (String value) {
                setState(() {
                  description = value;
                });
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
              items: const <String>[
                'Credit Card',
                'PayPal',
                'Bank Transfer',
                'Cash'
              ],
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
              onChanged: (String value) {
                setState(() {
                  storageLocation = value;
                });
              },
              controller: storageLocationController,
            ),
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Product Number',
              hintText: 'Enter product number',
              inputType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  productNumber = int.tryParse(value);
                });
              },
              controller: productNumberController,
            ),
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Quantity',
              hintText: 'Enter quantity',
              inputType: TextInputType.number,
              onChanged: (String value) {
                setState(() {
                  quantity = int.tryParse(value);
                });
              },
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
              text: 'Create',
              onPressed: _submitForm,
            ),
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
        'name': productName,
        'price': price,
        'discount': discount,
        'description': description,
        'category': category,
        'location': country,
        'images': images,
        'paymentMethod': paymentMethod,
        'deliveryMethod': deliveryMethod,
        'url': 'http://example.com/product', // Example URL
        'itemType': 'product',
        'isActive': _isSwitched,
        'supplierId': null,
        'storageLocation': storageLocation,
        'productNumber': productNumber,
        'quantity': quantity,
        'startAt': startDate?.toIso8601String(),
        'endAt': endDate?.toIso8601String(),
        'color': color,
        'size': size,
      };

      bool response = await orderController.addProducts(productListing);
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
      setState(() {
        isSubmitted = false;
      });
    }
  }
}
