import 'dart:io';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class CreateServiceListing extends StatefulWidget {
  const CreateServiceListing({super.key});

  @override
  _CreateServiceListingState createState() => _CreateServiceListingState();
}

class _CreateServiceListingState extends State<CreateServiceListing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final OrderController orderController = Get.find();
  final ShopController shopController = Get.put(ShopController());
  final ProfileController profileController = Get.find();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = <File>[];

  bool isSubmitted = false;

  // Form fields
  String? serviceName;
  double? price;
  String? description;
  String? category;
  String? location;
  List<String>? images = <String>[];
  String? paymentMethod;
  String? deliveryMethod;
  String? deliveryTime;
  DateTime? availableTime;
  String? serviceType;

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
          'Create Service Listing',
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
              // Service Name Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Service Name',
                  hintText: 'Enter service name here',
                  border: OutlineInputBorder(),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a service name';
                  }
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    serviceName = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'USD',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  setState(() {
                    price = double.tryParse(value);
                  });
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                maxLines: 3,
                maxLength: 300,
                decoration: const InputDecoration(
                  labelText: 'Describe your Service',
                  hintText: 'Add service description here',
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
                items: <String>[
                  'Design Services',
                  'Consulting',
                  'Technical Support'
                ].map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    category = newValue;
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
                  initialSelection: location,
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
                        text: location ?? 'Select Location',
                      ),
                    );
                  },
                  onChanged: (CountryCode? code) {
                    setState(() {
                      location = code?.name;
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
                items: <String>['Online', 'In-Person'].map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    deliveryMethod = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Delivery Time Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Delivery Time',
                  hintText: 'e.g., 3-5 business days',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    deliveryTime = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Available Time Field
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Available Time',
                  hintText: _formatDate(availableTime),
                  border: const OutlineInputBorder(),
                ),
                onTap: () => _selectDate(context),
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
                    paymentMethod = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Service Type Field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Service Type',
                  hintText: 'e.g., design',
                  border: OutlineInputBorder(),
                ),
                onChanged: (String value) {
                  setState(() {
                    serviceType = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Submit Button
              ProCustomButton(
                loading: isSubmitted,
                text: 'Create Service',
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Select date';
    }
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: availableTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != availableTime) {
      setState(() {
        availableTime = picked;
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
      // Create a map to hold form data
      final Map<String, dynamic> serviceData = <String, dynamic>{
        'userId': profileController.myProfile.uid,
        'shopId': shopController.shop?.id,
        'name': serviceName,
        'price': price,
        'description': description,
        'category': category,
        'location': location,
        'images': images,
        'paymentMethod': paymentMethod,
        'deliveryMethod': deliveryMethod,
        'deliveryTime': deliveryTime,
        'availableTime': availableTime?.toIso8601String(),
        'serviceType': serviceType,
        'itemType': 'service',
        'isActive': true
      };

      // For demonstration, print the map
      // You can now send this data to your API or database
      // Example:
      await orderController.addService(serviceData).then((bool response) {
        if (response) {
          // Handle success
          showSnackbar(message: 'Service Added Succesfully!');
          Get.back();
        } else {
          // Handle error
          showSnackbar(message: 'Error Adding Service!', error: true);
        }
      }).catchError((dynamic error) {
        Get.snackbar('Error', 'An unexpected error occurred');
      });
      setState(() {
        isSubmitted = false;
      });
      // Clear the form or navigate to another screen if needed
    }
  }
}
