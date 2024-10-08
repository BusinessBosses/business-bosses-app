import 'dart:io';

import 'package:business_bosses_v2/bbpro/widgets/customcard.dart';
import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/multipleedit.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Addclient extends StatefulWidget {
  const Addclient({super.key});

  @override
  State<Addclient> createState() => _AddclientState();
}

class _AddclientState extends State<Addclient> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ProfileController profileController = Get.find();
  final ClientsController clientsController = Get.put(ClientsController());
  final ClientType _selectedType = ClientType.online;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  bool isSubmit = false;
  String? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Add Client',
          style: TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 15),
                    CustomCard(
                      buttonvisible: true,
                      caption: 'Client Information',
                      subText: 'Add a photo for your client',
                      buttonText: 'Choose Photo',
                      onPressed: _pickImage,
                      imagePath: _selectedImage?.path ??
                          'assets/images/shopplaceholder.png',
                      iconpath: 'assets/svgs/uploadicon.svg',
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Client\'s Name',
                      hintText: 'Enter name here',
                      controller: nameController,
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Client\'s Email',
                      hintText: 'example@business.com',
                      controller: emailController,
                    ),
                    const SizedBox(height: 15),
                    CustomEditText(
                      caption: 'Client\'s Phone number',
                      hintText: '+234 000 000 000',
                      controller: phoneController,
                    ),
                    const SizedBox(height: 15),
                    CustomDropdownWidget(
                      hintText: 'Select Client Type',
                      caption: 'Client Type',
                      items: ClientType.values
                          .skip(1) // Skip the first item
                          .map((ClientType type) => type.displayTitle)
                          .toList(),
                      iconName: 'assets/svgs/dropdown.svg',
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ProCustomButton(
                loading: isSubmit,
                text: 'Save',
                onPressed: () async {
                  setState(() {
                    isSubmit = true;
                  });
                  // Manual validation
                  final String name = nameController.text;
                  final String email = emailController.text;
                  final String phone = phoneController.text;

                  if (_selectedImage == null) {
                    showSnackbar(
                      message: 'Please select a client image!',
                      error: true,
                    );
                    setState(() {
                      isSubmit = false;
                    });
                    return;
                  }

                  if (name.isEmpty) {
                    showSnackbar(
                        message: 'Please enter the client\'s name',
                        error: true);
                    setState(() {
                      isSubmit = false;
                    });
                    return;
                  }

                  if (email.isEmpty) {
                    showSnackbar(
                        message: 'Please enter the client\'s email',
                        error: true);
                    setState(() {
                      isSubmit = false;
                    });
                    return;
                  }

                  final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                  if (!emailRegex.hasMatch(email)) {
                    showSnackbar(
                        message: 'Please enter a valid email address',
                        error: true);
                    setState(() {
                      isSubmit = false;
                    });
                    return;
                  }

                  if (phone.isEmpty) {
                    showSnackbar(
                        message: 'Please enter the client\'s phone number',
                        error: true);
                    setState(() {
                      isSubmit = false;
                    });
                    return;
                  }

                  if (_selectedType.displayTitle.isEmpty) {
                    showSnackbar(
                        message: 'Please select a client type', error: true);
                    setState(() {
                      isSubmit = false;
                    });
                    return;
                  }

                  if (_formKey.currentState?.validate() ?? false) {
                    if (_selectedImage != null) {
                      dynamic response =
                          await ApiService.uploadFile(_selectedImage!);
                      if (response['success']) {
                        image = response['fileUrl'];
                      } else {
                        showSnackbar(
                          message: 'Error Uploading Thumbnail!',
                          error: true,
                        );
                        setState(() {
                          isSubmit = false;
                        });
                        return;
                      }
                    }
                    // Handle the save action
                    final Map<String, dynamic> data = <String, dynamic>{
                      'userId': profileController
                          .myProfile.uid, // Fetch the user ID if applicable
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'type': _selectedType.displayTitle,
                      'createdAt': DateTime.now().toString(),
                      'image': image, // Handle images if necessary
                    };

                    final bool response =
                        await clientsController.addClient(data);

                    if (response) {
                      Get.back();
                      showSnackbar(message: 'Client Added Successfully!');
                    } else {
                      showSnackbar(
                        message: 'Error Adding Client!',
                        error: true,
                      );
                      setState(() {
                        isSubmit = false;
                      });
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
}
