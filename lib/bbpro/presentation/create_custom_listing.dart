import 'dart:io';

import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateCustomListing extends StatefulWidget {
  final Customitem? customItem;
  const CreateCustomListing({super.key, this.customItem});

  @override
  State<CreateCustomListing> createState() => _CreateCustomListingState();
}

class _CreateCustomListingState extends State<CreateCustomListing> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final ShopController shopController = Get.find();
  final ProfileController profileController = Get.find();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _selectedImages = <File>[];
  List<String>? updateImages = <String>[];
  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
    // If a customItem is provided, pre-populate fields for editing
    if (widget.customItem != null) {
      _titleController.text = widget.customItem!.title;
      _descriptionController.text = widget.customItem!.description;
      _linkController.text = widget.customItem!.link ?? '';
      updateImages = widget.customItem!.images != null
          ? widget.customItem!.images!
          : <String>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          widget.customItem == null
              ? 'Create Custom Listing'
              : 'Edit Custom Listing',
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
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 16),
            CustomEditText(
              caption: 'Title *',
              maxLength: 30,
              hintText: 'Enter title here',
              controller: _titleController,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a listing name';
                }
                return null;
              },
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
            CustomEditText(
              caption: 'Link (Optional)',
              maxLength: 30,
              hintText: 'Enter url link here',
              controller: _linkController,
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
            const SizedBox(
              height: 30,
            ),
            ProCustomButton(
              text: widget.customItem == null
                  ? 'Create Custom Listing'
                  : 'Update ',
              onPressed: () async {
                // Validate the form before proceeding
                if (_formKey.currentState?.validate() ?? false) {
                  if (updateImages!.isEmpty && _selectedImages.isEmpty) {
                    showSnackbar(
                      message: 'Please select at least one image to upload!',
                      error: true,
                    );
                    return;
                  }
                  setState(() => isSubmit = true);
                  // 1. Clear the final images list
                  List<String> finalImages = <String>[];

                  // 2. Add back any *retained* old images
                  //    (i.e., those still in updateImages)
                  for (String oldImageUrl in updateImages!) {
                    finalImages.add(oldImageUrl);
                  }

                  // 3. Upload and add newly selected images
                  for (File image in _selectedImages) {
                    final dynamic response = await ApiService.uploadFile(image);
                    if (response['success']) {
                      finalImages.add(response['fileUrl']);
                    }
                  }
                  final dynamic data = <String, dynamic>{
                    'images': finalImages,
                    'title': _titleController.text,
                    'link': _linkController.text,
                    'description': _descriptionController.text,
                    'userId': profileController.myProfile.uid,
                    'shopId': shopController.shop!.id,
                  };
                  bool response;
                  if (widget.customItem != null) {
                    // Update existing custom listing
                    response = await shopController.updateCustomItem(
                      widget.customItem!.id,
                      data,
                    );
                  } else {
                    // Create new custom listing
                    response = await shopController.addCustomItem(data);
                  }
                  if (response) {
                    showSnackbar(
                      message: widget.customItem != null
                          ? 'Listing Updated Successfully!'
                          : 'Listing Created Successfully!',
                    );
                    goBack();
                  } else {
                    showSnackbar(
                      message: widget.customItem != null
                          ? 'Failed to update listing!'
                          : 'Failed to create listing!',
                      error: true,
                    );
                  }
                  setState(() => isSubmit = false);
                } else {
                  return;
                }
              },
              loading: isSubmit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  void goBack() {
    Navigator.pop(context);
  }
}
