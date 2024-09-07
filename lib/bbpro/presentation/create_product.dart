import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
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
  final OrderController orderController = Get.find();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.put(ShopController());
  bool isSubmitted = false;

  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = <File>[];

  // Form fields
  String? productName;
  String? price;
  String? discount;
  String? description;
  String? category; // Default selected category
  String? location; // Default selected location
  String? deliveryMethod; // Default selected delivery method
  List<String>? images = <String>[]; // Store uploaded images
  String country = '';
  DateTime? startDate; // Selected start date
  DateTime? endDate;

  String? paymentMethod;

  String? storageLocation; // Entered by the user
  int? productNumber; // Entered by the user
  int? quantity;
  String? color; // Selected or entered by the user
  String? size; // Selected end date

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Product Name Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  hintText: 'Enter product name here',
                  border: OutlineInputBorder(),
                ),
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

              // Price and Discount Fields (Row)
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        hintText: 'USD',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        setState(() {
                          price = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Discount',
                        hintText: '10 %',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        setState(() {
                          discount = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                maxLines: 3,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Describe your Listing',
                  hintText: 'Add product description here',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    description = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Select Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                value: category,
                items: <String>['Beauty', 'Electronics', 'Fashion', 'Home']
                    .map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue as String;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Location Dropdown
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

              // Add Attachment (Image Picker)
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Add Attachment',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      _pickImage();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const SizedBox(height: 8),
              if (_selectedImages.isNotEmpty)
                GridView.builder(
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

              // Delivery Method Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Delivery Method',
                  border: OutlineInputBorder(),
                ),
                value: deliveryMethod,
                items: <String>['Online', 'Courier', 'In-Store Pickup']
                    .map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    deliveryMethod = newValue as String;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        hintText: _formatDate(startDate),
                        border: const OutlineInputBorder(),
                      ),
                      onTap: () =>
                          _selectDate(context, true), // true means start date
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        hintText: _formatDate(endDate),
                        border: const OutlineInputBorder(),
                      ),
                      onTap: () =>
                          _selectDate(context, false), // false means end date
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              // Payment Method Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                value: paymentMethod,
                items: <String>['Credit Card', 'PayPal', 'Bank Transfer']
                    .map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    paymentMethod = newValue ?? 'Credit Card';
                  });
                },
              ),
              const SizedBox(height: 16),

// Storage Location Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Storage Location',
                  hintText: 'Shelf 3',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    // Update storage location value
                  });
                },
              ),
              const SizedBox(height: 16),

              // Product Number Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Product Number',
                  hintText: 'Enter product number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  setState(() {
                    productNumber = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Quantity Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Enter quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  setState(() {
                    quantity = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Color Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Color',
                  hintText: 'Enter product color',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    color = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Size Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Size',
                  hintText: 'Enter product size',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    size = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Storage Location Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Storage Location',
                  hintText: 'Enter storage location',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    storageLocation = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Sell Button
              ProCustomButton(
                loading: isSubmitted,
                text: 'Create',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to format dates
  String _formatDate(DateTime? date) {
    if (date == null) return 'Select Date';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Function to show date picker
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
    // Build the product listing JSON object based on form input
    final Map<String, dynamic> productListing = <String, dynamic>{
      'userId': profileController.myProfile.uid, // Get this from your auth
      'shopId': shopController.shop?.id, // Set accordingly
      'name': productName,
      'price': price,
      'discount': discount,
      'description': description,
      'category': category,
      'location': location,
      'images': images,
      'paymentMethod': paymentMethod, // Example
      'deliveryMethod': deliveryMethod,
      'url': 'http://example.com/laptop', // Example URL
      'itemType': 'product',
      'isActive': true,
      'supplierId': null, // Set accordingly
      'storageLocation': storageLocation,
      'productNumber': productNumber,
      'quantity': quantity,
      'startAt': startDate.toString(), // Example dates
      'endAt': endDate.toString(),
      'color': color,
      'size': size,
    };

    bool response = await orderController.addProducts(productListing);
    if (response) {
      showSnackbar(
        message: 'Product Added Succesfully!',
      );
      Get.back();
    } else {
      showSnackbar(
        message: 'Error While Adding Product',
        error: true,
      );
    }
    setState(() {
      isSubmitted = false;
    });

    // Here you can send this productListing to your backend or Firestore
  }
}
