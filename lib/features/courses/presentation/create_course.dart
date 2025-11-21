import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/posts/widgets/image_item.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../action/action.dart';
import '../../../utils/theme/theme.dart';

class CreateCourseScreen extends StatefulWidget {
  static const String routeName = '/create-course-screen';
  final String industryId;
  final String? courseId;
  final CourseModel? course;

  const CreateCourseScreen({
    super.key,
    required this.industryId,
    this.courseId,
    this.course,
  });

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

enum ContentType { link, video, file }

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  String? title;
  String? description;
  bool isProcessing = false;
  final CourseController courseController = Get.put(CourseController());
  final ProfileController profileController = Get.find();
  DetectableTextEditingController? desccontroller =
      DetectableTextEditingController();
  ContentType _selectedContentType = ContentType.link;
  File? _selectedImage;
  String? photo;
  bool _isCustomPriceSelected = false;
  String? customPrice;
  List<String>? editDocuments;

  @override
  void initState() {
    super.initState();
    desccontroller = DetectableTextEditingController(
        regExp: detectionRegExp(hashtag: false)!,
        text: widget.course != null ? widget.course!.description : '');

    if (widget.course != null) {
      _initializeExistingCourse();
    } else {
      // Initialize with one empty link for new course
      contentLinks.add('');
    }
  }

  void _initializeExistingCourse() {
    // Determine content type from existing course
    if (widget.course!.contentType == 'file') {
      _selectedContentType = ContentType.file;
      editDocuments =
          List<String>.from(widget.course!.documents ?? <dynamic>[]);
    } else if (widget.course!.contentType == 'video') {
      _selectedContentType = ContentType.video;
      if (widget.course!.youtubeUrls != null) {
        contentLinks = List<String>.from(widget.course!.youtubeUrls!);
      } else {
        contentLinks = <String>[''];
      }
    } else if (widget.course!.contentType == 'link') {
      _selectedContentType = ContentType.link;
      contentLinks =
          List<String>.from(widget.course!.youtubeUrls ?? <dynamic>['']);
    }
  }

  List<String> selectedFileNames = <String>[];
  List<String> selectedFilePaths = <String>[];
  List<String> contentLinks =
      <String>[]; // For URL links (both regular links and videos)
  bool _paidCourse = false;
  int? _courseprice;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CourseController>(builder: (CourseController controller) {
      return GestureDetector(
        onTap: () => unFocusKeyboard(context),
        child: Scaffold(
          backgroundColor: backgroundcolorinterface,
          appBar: AppBar(
            title: Text(widget.course == null
                ? 'Create a Course'
                : 'Update Your Course'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Get.back(),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  TextFormField(
                    onChanged: (String val) {
                      setState(() {
                        title = val;
                      });
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    initialValue: widget.course?.title ?? '',
                    decoration: inputDecoration.copyWith(
                      hintText: 'Enter Course Title',
                    ),
                  ),
                  const SizedBox(height: 20),
                  DetectableTextField(
                    controller: desccontroller,
                    keyboardType: TextInputType.multiline,
                    maxLength: 1000,
                    maxLines: 5,
                    style: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (String val) {
                      setState(() {
                        description = val;
                      });
                    },
                    decoration: inputDecoration.copyWith(
                      hintText: 'Describe the Course',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Select Course Content Type',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RadioListTile<ContentType>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Link'),
                            value: ContentType.link,
                            groupValue: _selectedContentType,
                            onChanged: (ContentType? value) {
                              setState(() {
                                _selectedContentType = value!;
                                _resetContentFields();
                                contentLinks = <String>[''];
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RadioListTile<ContentType>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Video'),
                            value: ContentType.video,
                            groupValue: _selectedContentType,
                            onChanged: (ContentType? value) {
                              setState(() {
                                _selectedContentType = value!;
                                _resetContentFields();
                                contentLinks = <String>[''];
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: RadioListTile<ContentType>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('File'),
                            value: ContentType.file,
                            groupValue: _selectedContentType,
                            onChanged: (ContentType? value) {
                              setState(() {
                                _selectedContentType = value!;
                                _resetContentFields();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // LINK CONTENT TYPE
                  if (_selectedContentType == ContentType.link)
                    _buildLinkSection(),

                  // VIDEO CONTENT TYPE
                  if (_selectedContentType == ContentType.video)
                    _buildVideoSection(),

                  // FILE CONTENT TYPE
                  if (_selectedContentType == ContentType.file)
                    _buildFileSection(),

                  const SizedBox(height: 30),

                  // Thumbnail Section
                  _buildThumbnailSection(),

                  const SizedBox(height: 30),

                  // Paid Course Section
                  _buildPaidCourseSection(),

                  const SizedBox(height: 30),

                  // Submit Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: MCustomButton(
                      onPressed: _submitCourse,
                      label: widget.course == null ? 'Post' : 'Update Course',
                      isProcessing: isProcessing,
                      buttonType: ButtonType.elevated,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _resetContentFields() {
    contentLinks = <String>[];
    selectedFileNames = <String>[];
    selectedFilePaths = <String>[];
  }

  Widget _buildLinkSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Add Links',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...contentLinks.asMap().entries.map((MapEntry<int, String> entry) {
          int index = entry.key;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: contentLinks[index],
                    onChanged: (String value) {
                      setState(() {
                        contentLinks[index] = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'https://example.com',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                if (index != 0)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        contentLinks.removeAt(index);
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              contentLinks.add('');
            });
          },
          icon: const Icon(
            Icons.add,
            color: primaryColorLT,
          ),
          label: const Text(
            'Add Another Link',
            style: TextStyle(color: primaryColorLT),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Add YouTube Videos',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        ...contentLinks.asMap().entries.map((MapEntry<int, String> entry) {
          int index = entry.key;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: contentLinks[index],
                    onChanged: (String value) {
                      setState(() {
                        contentLinks[index] = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'https://youtube.com/watch?v=...',
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                if (index != 0)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        contentLinks.removeAt(index);
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.red),
                  ),
              ],
            ),
          );
        }),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () {
            setState(() {
              contentLinks.add('');
            });
          },
          icon: const Icon(
            Icons.add,
            color: primaryColorLT,
          ),
          label: const Text(
            'Add Another Video',
            style: TextStyle(color: primaryColorLT),
          ),
        ),
      ],
    );
  }

  Widget _buildFileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () async {
            final FilePickerResult? result =
                await FilePicker.platform.pickFiles(
              allowMultiple: true,
              type: FileType.custom,
              allowedExtensions: <String>['pdf'],
            );

            if (result != null) {
              setState(() {
                for (PlatformFile file in result.files) {
                  selectedFileNames.add(file.name);
                  selectedFilePaths.add(file.path!);
                }
              });
            }
          },
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Wrap(
                  children: <Widget>[
                    Text(
                      'Add Files',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      ' (Only PDFs are supported)',
                      style: TextStyle(
                        color: primaryColorLT,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset('assets/svgs/fileresources.svg'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (editDocuments != null && editDocuments!.isNotEmpty)
          ...editDocuments!.asMap().entries.map((MapEntry<int, String> entry) {
            int index = entry.key;
            String fileName = entry.value;
            return _buildFileItem(fileName, () => _removeFile(index));
          }),
        ...selectedFileNames.asMap().entries.map((MapEntry<int, String> entry) {
          int index = entry.key;
          String fileName = entry.value;
          return _buildFileItem(fileName, () => _removeFileUpload(index));
        }),
      ],
    );
  }

  Widget _buildFileItem(String fileName, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.insert_drive_file),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              fileName,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Add an image for your Course',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickImage(context),
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withAlpha(20)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Add an image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.add_circle),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          ImageItem(
            file: _selectedImage,
            onRemove: () {
              setState(() {
                _selectedImage = null;
              });
            },
          )
        else if (widget.course?.thumbnail != null)
          ImageItem(
            onRemove: () {},
            imageUrl: widget.course!.thumbnail,
          ),
      ],
    );
  }

  Widget _buildPaidCourseSection() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Is this a paid course?',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            Row(
              children: <Widget>[
                const Text(
                  'No',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
                ),
                Switch(
                  value: widget.course != null
                      ? widget.course!.courseType != 'free'
                      : _paidCourse,
                  activeThumbColor: Colors.white,
                  activeTrackColor: primaryColorLT,
                  inactiveTrackColor: Colors.grey,
                  onChanged: (bool value) {
                    setState(() {
                      _paidCourse = value;
                      if (!_paidCourse) {
                        _courseprice = null;
                        _isCustomPriceSelected = false;
                      }
                    });
                  },
                ),
                const Text(
                  'Yes',
                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
        if (_paidCourse) ...<Widget>[
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/svgs/coin.svg'),
                    const SizedBox(width: 20),
                  ],
                ),
                Expanded(
                  child: DropdownButton<int>(
                    value: _courseprice,
                    borderRadius: BorderRadius.circular(radius),
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_sharp),
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(height: 1, color: Colors.white),
                    onChanged: (int? newValue) {
                      setState(() {
                        if (newValue != null) {
                          if (newValue != -1) {
                            _courseprice = newValue;
                            _isCustomPriceSelected = false;
                          } else {
                            _courseprice = null;
                            _isCustomPriceSelected = true;
                          }
                        }
                      });
                    },
                    items: <DropdownMenuItem<int>>[
                      ...<int>[500, 1000, 5000]
                          .map<DropdownMenuItem<int>>((int value) {
                        int dollarValue = value ~/ 100;
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Coins (\$$dollarValue)'),
                        );
                      }),
                      const DropdownMenuItem<int>(
                        value: -1,
                        child: Text('Enter Custom Price'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isCustomPriceSelected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Custom Price',
                  hintText: 'Enter price in coins',
                ),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  setState(() {
                    customPrice = value;
                  });
                },
              ),
            ),
        ],
      ],
    );
  }

  void _removeFile(int index) {
    setState(() {
      editDocuments!.removeAt(index);
    });
  }

  void _removeFileUpload(int index) {
    setState(() {
      selectedFileNames.removeAt(index);
      selectedFilePaths.removeAt(index);
    });
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  bool _isValidUrl(String url) {
    final RegExp urlRegExp = RegExp(
      r'^(https?://)?([a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+)(:\d+)?(/([^\s/]+)*)*(\?[\w\-.~!@$&*+=:?\\%]*[^\s/])?$',
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegExp.hasMatch(url);
  }

  bool _isValidYoutubeUrl(String url) {
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  Future<void> _submitCourse() async {
    setState(() {
      isProcessing = true;
    });

    // Validation
    if (title == null || title!.isEmpty) {
      _showError('Title cannot be empty!');
      return;
    }

    if (description == null || description!.isEmpty) {
      _showError('Description cannot be empty!');
      return;
    }

    // Content type specific validation
    if (_selectedContentType == ContentType.link) {
      if (contentLinks.isEmpty ||
          contentLinks.every((String link) => link.isEmpty)) {
        _showError('You must add at least one link!');
        return;
      }
      if (!contentLinks
          .every((String link) => link.isEmpty || _isValidUrl(link))) {
        _showError('Please enter valid URLs!');
        return;
      }
    } else if (_selectedContentType == ContentType.video) {
      if (contentLinks.isEmpty ||
          contentLinks.every((String link) => link.isEmpty)) {
        _showError('You must add at least one video link!');
        return;
      }
      if (!contentLinks
          .every((String link) => link.isEmpty || _isValidUrl(link))) {
        _showError('Please enter valid video URLs!');
        return;
      }
      if (!contentLinks
          .every((String link) => link.isEmpty || _isValidYoutubeUrl(link))) {
        _showError('Only YouTube URLs are supported for videos!');
        return;
      }
    } else if (_selectedContentType == ContentType.file) {
      if (selectedFilePaths.isEmpty &&
          (editDocuments == null || editDocuments!.isEmpty)) {
        _showError('You must upload at least one file!');
        return;
      }
    }

    // Thumbnail validation
    if (_selectedImage == null && widget.course?.thumbnail == null) {
      _showError('Please add a thumbnail image for your course!');
      return;
    }

    // Paid course price validation
    if (_paidCourse) {
      // If user selected preset price
      if (!_isCustomPriceSelected && (_courseprice == null)) {
        _showError('Please select a price for the paid course!');
        return;
      }

      // If user selected custom price but left it empty
      if (_isCustomPriceSelected &&
          (customPrice == null || customPrice!.trim().isEmpty)) {
        _showError('Please enter a custom price for the paid course!');
        return;
      }

      // Custom price must be a valid number
      if (_isCustomPriceSelected && int.tryParse(customPrice!) == null) {
        _showError('Please enter a valid number for the custom price!');
        return;
      }
    }

    // Upload thumbnail if new image selected
    if (_selectedImage != null) {
      dynamic response = await ApiService.uploadFile(_selectedImage!);
      if (response['success']) {
        photo = response['fileUrl'];
      } else {
        showSnackbar(message: 'Error Uploading Thumbnail!', error: true);
        setState(() {
          isProcessing = false;
        });
        return;
      }
    } else if (widget.course != null) {
      photo = widget.course!.thumbnail;
    }

    // Upload files if any
    if (selectedFilePaths.isNotEmpty) {
      for (String filePath in selectedFilePaths) {
        await courseController.uploadFile(filePath);
      }
    }

    // Prepare course data
    List<String> urls = <String>[];
    List<String> documents = <String>[];

    if (_selectedContentType == ContentType.link ||
        _selectedContentType == ContentType.video) {
      urls = contentLinks.where((String link) => link.isNotEmpty).toList();
    } else if (_selectedContentType == ContentType.file) {
      if (widget.course != null && editDocuments != null) {
        documents = List<String>.from(editDocuments!)
          ..addAll(selectedFileNames);
      } else {
        documents = selectedFileNames;
      }
    }

    Map<String, dynamic> courseData = <String, dynamic>{
      'title': title,
      'industryId': widget.industryId,
      'description': description ?? desccontroller!.text,
      'userId': profileController.myProfile.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'price': _isCustomPriceSelected ? customPrice : _courseprice,
      'isPromoted': false,
      'isActive': true,
      'isApproved': false,
      'subtitle': false,
      'thumbnail': photo,
      'contentType': _selectedContentType.toString().split('.').last,
      'documents': documents.isEmpty ? null : documents,
      'courseType': _paidCourse ? 'paid' : 'free',
      'youtubeUrls': urls.isEmpty ? null : urls,
    };

    if (widget.course == null) {
      await courseController.createCourse(courseData);
    } else {
      await courseController.updateCourse(courseData, widget.course!.id);
    }

    setState(() {
      isProcessing = false;
    });
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
    setState(() {
      isProcessing = false;
    });
  }
}
