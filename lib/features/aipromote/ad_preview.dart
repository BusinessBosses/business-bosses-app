import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AdPreview extends StatefulWidget {
  final String title;
  final String content;
  final Function(String) onEdit;
  final Function(List<String> platforms, File? selectedImage) onPost;
  final bool isLoading;
  final int remainingPromos;

  const AdPreview({
    super.key,
    this.title = '',
    required this.content,
    required this.onEdit,
    required this.onPost,
    required this.isLoading,
    required this.remainingPromos,
  });

  @override
  State<AdPreview> createState() => _AdPreviewState();
}

class _AdPreviewState extends State<AdPreview> {
  bool _editMode = false;
  late TextEditingController _editController;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late FocusNode _editFocusNode;
  final Map<String, bool> _selectedPlatforms = <String, bool>{
    'homepage': true,
    'challenge': true,
  };

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.content);
    _editFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(covariant AdPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.content != widget.content && !_editMode) {
      _editController.text = widget.content;
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    _editFocusNode.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _editMode = !_editMode;
    });

    if (_editMode) {
      // Focus the field after the frame is drawn
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _editFocusNode.requestFocus();
      });
    }
  }

  void _saveEdit() {
    widget.onEdit(_editController.text);
    setState(() {
      _editMode = false;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle error - you might want to show a snackbar
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  // void _selectAll() {
  //   bool allSelected = _selectedPlatforms.values.every((bool v) => v);
  //   setState(() {
  //     _selectedPlatforms.forEach((String key, bool value) {
  //       _selectedPlatforms[key] = !allSelected;
  //     });
  //   });
  // }

  bool get _isAnyPlatformSelected =>
      _selectedPlatforms.values.any((bool v) => v);
  // bool get _areAllSelected => _selectedPlatforms.values.every((bool v) => v);

  ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus
              .unfocus(); // Only unfocus if something is actually focused
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 8),
          const Text(
            'Review and edit content before posting',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: <Color>[backgroundColor, backgroundColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(minHeight: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Image section
                  if (_selectedImage != null) ...<Widget>[
                    Container(
                      width: double.infinity,
                      height: 150,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Refined headline shown above the content.
                  if (widget.title.trim().isNotEmpty) ...<Widget>[
                    Text(
                      widget.title.trim(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Text content
                  _editMode
                      ? TextFormField(
                          controller: _editController,
                          focusNode: _editFocusNode,
                          maxLines: null,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Edit your ad content...',
                            hintStyle: TextStyle(color: Colors.white70),
                          ),
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : Text(
                          _editController.text,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            height: 1.5,
                          ),
                        ),

                  SizedBox(height: 16),

                  // Action buttons row
                  Row(
                    children: <Widget>[
                      // Edit/Save button
                      TextButton.icon(
                        onPressed: _editMode ? _saveEdit : _toggleEdit,
                        icon: Icon(
                          _editMode ? Icons.save : Icons.edit,
                          size: 16,
                          color: Colors.black,
                        ),
                        label: Text(
                          _editMode ? 'Save' : 'Edit',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Add image button
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(
                          Icons.add_photo_alternate,
                          size: 16,
                          color: Colors.black,
                        ),
                        label: Text(
                          _selectedImage != null ? 'Change' : 'Add Image',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          // Removed manual selection, now automatic
          // TextButton(
          //   onPressed: _selectAll,
          //   child: Text(
          //     _areAllSelected ? 'Deselect All' : 'Select All',
          //     style: TextStyle(
          //       fontSize: 14,
          //       color: Color(0xFF6366F1),
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 100),
          Center(
            child: const Text(
              'Post and, get discovered',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isAnyPlatformSelected && !widget.isLoading)
                  ? () {
                      // Push the latest edited text up before posting, so an
                      // edit made without tapping "Save" is still used.
                      widget.onEdit(_editController.text);
                      if (_editMode) {
                        setState(() => _editMode = false);
                      }

                      // collect keys with true value
                      final List<String> selected = _selectedPlatforms.entries
                          .where((MapEntry<String, bool> e) => e.value)
                          .map((MapEntry<String, bool> e) => e.key)
                          .toList();
                      widget.onPost(selected, _selectedImage);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColorLT,
                disabledBackgroundColor: backgroundColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ))
                  : const Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              profileController.myProfile.isSubscribed
                  ? ''
                  : 'Remaining free promotions per month: ${widget.remainingPromos}',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),

          !profileController.myProfile.isSubscribed
              ? GestureDetector(
                  onTap: () => <void>{showPremiumPaywall()},
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: <InlineSpan>[
                            TextSpan(
                              text: 'Upgrade to Pro,',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: primaryColorLT,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(
                              text: ' Get Unlimited Promotion',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
