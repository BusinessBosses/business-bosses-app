import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AddSupplierScreen extends StatefulWidget {
  const AddSupplierScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddSupplierScreenState createState() => _AddSupplierScreenState();
}

class _AddSupplierScreenState extends State<AddSupplierScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProfileController profileController = Get.find();
  final OrderController orderController = Get.put(OrderController());

  // Define TextEditingControllers for each field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String country = '';
  bool isSubmitted = false;

  // Function to handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isSubmitted = true;
      });
      // Creating JSON to be sent
      Map<String, dynamic> supplierData = <String, dynamic>{
        'userId': profileController.myProfile.uid,
        'name': nameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'description': descriptionController.text,
        'url': urlController.text,
        'category': categoryController.text,
        'location': country,
      };

      print(supplierData); // Send this JSON data to the API
      try {
        // bool success = await orderController.addSupplier(supplierData);
        // if (success) {
        //   showSnackbar(message: 'Supplier Added Successfully!');
        //   await Future.delayed(
        //       const Duration(seconds: 1)); // Optional delay for visibility
        //   Navigator.pop(context);
        // } else {
        //   showSnackbar(message: 'Error Adding Supplier!', error: true);
        // }
      } catch (e) {
        showSnackbar(message: 'An error occurred: $e', error: true);
      } finally {
        setState(() {
          isSubmitted = false;
        });
      }
      // You can now send `supplierData` to your API endpoint
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Add Supplier',
          style: TextStyle(color: proprimaryColor),
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
            // Name Input
            CustomEditText(
              caption: 'Suppliers\' Business Name',
              hintText: 'Eg. AK Ventures',
              controller: nameController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter supplier name';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            // Email Input
            CustomEditText(
              caption: 'Email',
              hintText: 'dress@dresses.com',
              controller: emailController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                } else if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            // Phone Input
            CustomEditText(
              caption: 'Phone',
              hintText: '+234',
              controller: phoneController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                } else if (!RegExp(r'^\+[1-9]{1}[0-9]{3,14}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            // Description Input
            CustomEditText(
              caption: 'Description',
              hintText: 'Add product description here',
              controller: descriptionController,
              maxLength: 300,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            // URL Input
            CustomEditText(
              caption: 'URL',
              hintText: '',
              controller: urlController,
            ),

            const SizedBox(height: 16),
            // Category Input
            CustomEditText(
              caption: 'Category',
              hintText: '',
              controller: categoryController,
            ),

            const SizedBox(height: 16),
            // Location Input
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

            const SizedBox(height: 20),

            // Submit Button
            ProCustomButton(
              text: 'Add Supplier',
              onPressed: _submitForm,
              loading: isSubmitted,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
