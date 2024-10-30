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
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Addclient extends StatefulWidget {
  final Client? client;
  final VoidCallback? onClientAdded;
  const Addclient({super.key, this.client, this.onClientAdded});

  @override
  State<Addclient> createState() => _AddclientState();
}

class _AddclientState extends State<Addclient> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final ProfileController profileController = Get.find();
  final ClientsController clientsController = Get.put(ClientsController());
  String? selectedType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  bool isSubmit = false;
  String? image;
  List<String>? updateImage;

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      nameController.text = widget.client!.name;
      emailController.text = widget.client!.email;
      phoneController.text = widget.client!.phone;
      updateImage = widget.client!.image;
      selectedType = widget.client!.type.toApiString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.client != null ? 'Edit CLient' : 'Add a Client',
          style: const TextStyle(
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
                          (updateImage != null
                              ? updateImage![0]
                              : 'assets/images/shopplaceholder.png'),
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
                    // CustomDropdownWidget(
                    //   hintText: 'Select Client Type',
                    //   caption: 'Client Type',
                    //   items: ClientType.values
                    //       .skip(1) // Skip the first item
                    //       .map((ClientType type) => type.displayTitle)
                    //       .toList(),
                    //   iconName: 'assets/svgs/dropdown.svg',
                    // ),
                    widget.client != null
                        ? CustomDropdownWidget(
                            initialValue: toInitialString(selectedType!),
                            caption: 'Client Type',
                            items: ClientType.values
                                .skip(1) // Skip the first item
                                .map((ClientType type) => type.displayTitle)
                                .toList(),
                            onChanged: (String? value) {
                              selectedType = value;
                              setState(() {});
                            },
                            iconName: 'assets/svgs/dropdown.svg',
                          )
                        : CustomDropdownWidget(
                            caption: 'Client Type',
                            items: ClientType.values
                                .skip(1) // Skip the first item
                                .map((ClientType type) => type.displayTitle)
                                .toList(),
                            onChanged: (String? value) {
                              selectedType = value;
                              setState(() {});
                            },
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

                  // if (_selectedImage == null && updateImage == null) {
                  //   showSnackbar(
                  //     message: 'Please add a client image!',
                  //     error: true,
                  //   );
                  //   setState(() {
                  //     isSubmit = false;
                  //   });
                  //   return;
                  // }

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

                  if (selectedType == null) {
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
                    if (widget.client != null &&
                        _selectedImage == null &&
                        updateImage != null) {
                      image = updateImage![0];
                    }
                    // Handle the save action
                    final Map<String, dynamic> data = <String, dynamic>{
                      'userId': profileController
                          .myProfile.uid, // Fetch the user ID if applicable
                      'name': nameController.text,
                      'email': emailController.text,
                      'phone': phoneController.text,
                      'type': toApiString(selectedType!),
                      'image': image, // Handle images if necessary
                    };

                    bool response;

                    if (widget.client != null) {
                      response = await clientsController.updateClient(
                          widget.client!.id, data);
                    } else {
                      response = await clientsController.addClient(data);
                    }

                    if (response) {
                      showSnackbar(
                        message: widget.client != null
                            ? 'Client Updated Successfully!'
                            : 'Client Added Successfully!',
                      );
                      // ignore: use_build_context_synchronously

                      await clientsController
                          .initClients(profileController.myProfile.uid);
                      if (widget.onClientAdded != null) {
                        widget.onClientAdded?.call();
                      }
                      Navigator.pop(context);
                    } else {
                      showSnackbar(
                        message: widget.client != null
                            ? ' Error updatig client!'
                            : 'Error Adding Client!',
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

  String toApiString(String type) {
    switch (type) {
      case 'Online':
        return 'on-line';
      case 'In-Person':
        return 'in-person';
      case 'Bb-User':
        return 'bb-user';
      default:
        return 'on-line'; // default value, if needed
    }
  }

  String toInitialString(String type) {
    switch (type) {
      case 'on-line':
        return 'Online';
      case 'in-person':
        return 'In-Person';
      case 'bb-user':
        return 'Bb-User';
      default:
        return 'Online'; // default value, if needed
    }
  }
}
