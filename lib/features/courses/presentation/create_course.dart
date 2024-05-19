import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/models/video_link_data.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:image_picker/image_picker.dart';
import '../../../action/action.dart';
import '../../../utils/theme/theme.dart';

class CreateCourseScreen extends StatefulWidget {
  static const String routeName = '/create-course-screen';
  final String industryId;
  final String? courseId;
  final CourseModel? course;

  const CreateCourseScreen({
    Key? key,
    required this.industryId,
    this.courseId,
    this.course,
  }) : super(key: key);

  @override
  State<CreateCourseScreen> createState() => _CreateCourseScreenState();
}

enum ContentType { videos, files, both }

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  int optionCode = 1;
  String? title;
  String? description;
  bool isProcessing = false;
  final CourseController courseController = Get.put(CourseController());
  final ProfileController profileController = Get.find();
  TextEditingController? desccontroller = TextEditingController();
  ContentType _selectedContentType = ContentType.videos;
  File? _selectedImage;
  String? photo;

  List<Map<String, dynamic>> types = <Map<String, dynamic>>[
    <String, dynamic>{
      'type': 'files',
    },
    <String, dynamic>{
      'type': 'videos',
    },
    <String, dynamic>{
      'type': 'both',
    },
  ];

  @override
  void initState() {
    desccontroller = TextEditingController(
        text: widget.course != null ? widget.course!.description : '');
    if (widget.course != null) {
      videoLinks.clear();
      int minLength = widget.course!.youtubeUrls!.length;
      for (int i = 0; i < minLength; i++) {
        videoLinks.add(
          VideoLinkData(
            hasTranscript: widget.course!.transcript == null ? false : true,
            url: widget.course!.youtubeUrls![i],
            transcript: widget.course!.transcript == null
                ? ''
                : widget.course!.transcript![i],
          ),
        );
      }
    } else {
      VideoLinkData videolin = VideoLinkData(url: '', transcript: '');
      videoLinks.add(videolin);
    }

    super.initState();
  }

  List<String> selectedFileNames = <String>[];
  List<String> selectedFilePaths = <String>[];

  bool _shouldPromote = false;
  bool _paidCourse = false;
  int? _courseprice;
  List<VideoLinkData> videoLinks = <VideoLinkData>[];
  List<VideoLinkData> videoTranscripts = <VideoLinkData>[];

  @override
  Widget build(BuildContext context) {
    widget.course != null ? title = widget.course!.title : '';
    widget.course != null ? description = widget.course!.description : '';
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
                onPressed: () {
                  Get.back();
                },
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
                      initialValue:
                          widget.course == null ? '' : widget.course!.title,
                      decoration: inputDecoration.copyWith(
                        hintText: 'Enter Course Title',
                      )),
                  const SizedBox(height: 24.0),
                  DetectableTextField(
                    controller: desccontroller,
                    detectionRegExp: detectionRegExp(hashtag: false)!,
                    onDetectionTyped: (String text) {},
                    onDetectionFinished: () {},
                    keyboardType: TextInputType.multiline,
                    maxLength: 1000,
                    maxLines: 5,
                    basicStyle: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (String val) {
                      setState(() {
                        description = val;
                      });
                    },
                    decoration: inputDecoration.copyWith(
                        hintText: 'Describe the Course'),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Select Course Content type',
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
                              borderRadius: BorderRadius.circular(10)),
                          child: RadioListTile<ContentType>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Videos'),
                            value: ContentType.videos,
                            groupValue: _selectedContentType,
                            onChanged: (ContentType? value) {
                              setState(() {
                                _selectedContentType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: RadioListTile<ContentType>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Files'),
                            value: ContentType.files,
                            groupValue: _selectedContentType,
                            onChanged: (ContentType? value) {
                              setState(() {
                                _selectedContentType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: RadioListTile<ContentType>(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text('Both'),
                            value: ContentType.both,
                            groupValue: _selectedContentType,
                            onChanged: (ContentType? value) {
                              setState(() {
                                _selectedContentType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Visibility(
                    visible: _selectedContentType.toString() ==
                            'ContentType.videos' ||
                        _selectedContentType.toString() == 'ContentType.both',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Add Youtube or Video links',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: videoLinks.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index < videoLinks.length) {
                              return buildVideoLinkContainer(
                                  videoLinks[index], index);
                            } else {
                              return buildAddButton();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !_validateVideoLinks(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Add a Thumbnail for your Course',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickImage(context);
                          },
                          child: Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black.withAlpha(20)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  _selectedImage == null
                                      ? 'Add an image'
                                      : _selectedImage!.path.split('/').last,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.add_circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _selectedContentType.toString() ==
                            'ContentType.files' ||
                        _selectedContentType.toString() == 'ContentType.both',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: (() async {
                            final FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              allowMultiple: true,
                            );
                            if (result != null) {
                              result.files
                                  .map((PlatformFile file) => setState(() {
                                        selectedFileNames.add(file.name);

                                        selectedFilePaths.add(file.path!);
                                      }))
                                  .toList();
                            }
                          }),
                          child: Container(
                            height: 55,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  const Text(
                                    'Add Files (pdf,docx,doc,xls,etc)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: SvgPicture.asset(
                                      'assets/svgs/fileresources.svg',
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: selectedFileNames
                              .map(
                                (String fileName) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(Icons.insert_drive_file),
                                      const SizedBox(width: 8),
                                      Text(fileName),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Paid Course',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                      Row(
                        children: <Widget>[
                          const Text(
                            'No',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.w700),
                          ),
                          Switch(
                            value: widget.course != null
                                ? widget.course!.courseType.toString() == 'free'
                                    ? false
                                    : true
                                : _paidCourse,
                            onChanged: (bool value) {
                              setState(() {
                                _paidCourse = value;
                                if (!_paidCourse) {
                                  _courseprice = null;
                                }
                              });
                            },
                          ),
                          const Text(
                            'Yes',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Visibility(
                    visible: _paidCourse,
                    child: Container(
                      height: 55,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                      ),
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
                              underline: Container(
                                height: 1,
                                color: Colors.white,
                              ),
                              onChanged: (int? newValue) {
                                setState(() {
                                  if (newValue != null) {
                                    if (newValue != -1) {
                                      _courseprice = newValue;
                                    } else {}
                                  }
                                });
                              },
                              items: <DropdownMenuItem<int>>[
                                ...<int>[500, 1000, 5000]
                                    .map<DropdownMenuItem<int>>((int value) {
                                  int dollarValue = value ~/ 100;
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child:
                                        Text('$value Coins (\$$dollarValue)'),
                                  );
                                }).toList(),
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
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: <Widget>[
                      SvgPicture.asset('assets/svgs/rocket.svg'),
                      const SizedBox(width: 15),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Boost this listing?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Reach a wider audience and get more views',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: Color(0xFF777777),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          const Text(
                            'No',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.w700),
                          ),
                          Switch(
                            value: _shouldPromote,
                            onChanged: (bool value) {
                              setState(() {
                                _shouldPromote = value;
                              });
                            },
                          ),
                          const Text(
                            'Yes',
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: MCustomButton(
                      onPressed: () async {
                        setState(() {
                          isProcessing = true;
                        });
                        if (_selectedImage != null) {
                          dynamic response =
                              await ApiService.uploadFile(_selectedImage!);
                          if (response['success']) {
                            photo = response['fileUrl'];
                          } else {
                            showSnackbar(
                                message: 'Error Uploading Thumbnail!',
                                error: true);
                            setState(() {
                              isProcessing = false;
                            });
                            return;
                          }
                        }
                        if (title == null || title == '') {
                          Get.snackbar(
                            'Error',
                            'Title cannot be empty!',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          setState(() {
                            isProcessing = false;
                          });
                          return;
                        }
                        if (description == null || description == '') {
                          Get.snackbar(
                            'Error',
                            'Description cannot be empty!',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          setState(() {
                            isProcessing = false;
                          });
                          return;
                        }
                        if (_selectedImage != null) {
                          Get.snackbar(
                            'Error',
                            'Please add a thumbnail for your course',
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                          setState(() {
                            isProcessing = false;
                          });
                          return;
                        }
                        Map<String, dynamic> course = <String, dynamic>{
                          'title': title,
                          'industryId': widget.industryId,
                          'description': description ?? desccontroller!.text,
                          'userId': profileController.myProfile.uid,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                          'price': _courseprice,
                          'isPromoted': false,
                          'isActive': true,
                          'isApproved': false,
                          'subtitle': false,
                          'thumbnail': photo,
                          'contentType':
                              _selectedContentType.toString().split('.').last,
                          'documents': selectedFileNames.isEmpty
                              ? null
                              : selectedFileNames,
                          'courseType': _paidCourse ? 'paid' : 'free',
                          'youtubeUrls': _extractYoutubeUrls(),
                          'transcript': _extractTranscripts(),
                        };
                        widget.course == null
                            ? await courseController.createCourse(course)
                            : await courseController.updateCourse(
                                course, widget.course!.id);
                        setState(() {
                          isProcessing = false;
                        });
                      },
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

  Widget buildVideoLinkContainer(VideoLinkData videoLinkData, dynamic index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue:
                      widget.course != null ? videoLinks[index].url : '',
                  onChanged: (String value) {
                    VideoLinkData newVideoLink = VideoLinkData(
                        url: value, transcript: videoLinkData.transcript);

                    if (videoLinks.isNotEmpty && index < videoLinks.length) {
                      videoLinks[index] = newVideoLink;
                    } else {
                      videoLinks.add(newVideoLink);
                    }
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'https://',
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              if (index != 0)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      videoLinks.removeAt(index);
                    });
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/close.svg',
                    height: 20,
                  ),
                ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SvgPicture.asset('assets/svgs/transcriptsicon.svg'),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text('Transcript'),
                ],
              ),
              Switch(
                value: videoLinkData.hasTranscript,
                onChanged: (bool value) {
                  setState(() {
                    videoLinkData.hasTranscript = value;
                  });
                },
              ),
            ],
          ),
          Visibility(
            visible: videoLinkData.hasTranscript,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: backgroundcolorinterface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextFormField(
                onChanged: (String value) {
                  setState(() {
                    videoLinkData.transcript = value;
                  });
                },
                initialValue: videoLinkData.transcript, // Set initial value
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Add transcript text here',
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidUrl(String url) {
    final RegExp urlRegExp = RegExp(
      r'^(https?://)?([a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+)(:\d+)?(/([^\s/]+)*)*(\?[\w\-.~!@$&*+=:?\\%]*[^\s/])?$',
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegExp.hasMatch(url);
  }

  List<String> _extractYoutubeUrls() {
    List<String> youtubeUrls = <String>[];
    for (dynamic videoLink in videoLinks) {
      if (_isValidUrl(videoLink.url)) {
        youtubeUrls.add(videoLink.url);
      }
    }
    return youtubeUrls;
  }

  List<String> _extractTranscripts() {
    List<String> videoTranscripts = <String>[];
    for (dynamic videoLink in videoLinks) {
      videoTranscripts.add(videoLink.transcript);
    }
    return videoTranscripts;
  }

  bool _validateVideoLinks() {
    for (dynamic videoLink in videoLinks) {
      if (!_isValidYoutubeUrl(videoLink.url)) {
        return false;
      }
    }
    return true;
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Handle the selected image. You can save it, display it, or upload it.
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  bool _isValidYoutubeUrl(String url) {
    final RegExp youtubeRegExp = RegExp(
      r'^(https?\:\/\/)?(www\.youtube\.com\/watch\?v=|youtu\.be\/).+$',
      caseSensitive: false,
      multiLine: false,
    );
    return youtubeRegExp.hasMatch(url);
  }

  Widget buildAddButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          videoLinks.length != 4
              ? videoLinks.add(VideoLinkData())
              : Get.snackbar('Error', 'You can only add 4 video links!');
        });
      },
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(
          horizontal: 9,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withAlpha(20)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              'Add more video links to create a course bundle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: const Icon(
                Icons.add_circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// /// Coursetype CARD
// class CourseTypeSelect extends StatelessWidget {
//   /// CONSTRUCTOR
//   const CourseTypeSelect({
//     Key? key,
//     required this.type,
//     required this.activetype,
//     required this.onTap,
//   }) : super(key: key);
//   final String type;
//   final String activetype;
//   final Function(String) onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
    
//         // print(activetype);
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 15),
//         padding: const EdgeInsets.all(15.0),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color:  const Color.fromRGBO(0, 0, 0, 0.0530),
//             width: 3,
//           ),
//           borderRadius: BorderRadius.circular(13),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
               
//                   const CircleAvatar(
//                     radius: 9,
//                     backgroundColor: Color(0xFFF01C29),
//                     child: CircleAvatar(
//                       radius: 5,
//                       backgroundColor: Colors.white,
//                     ),
//                   ),
//                 TextWidget(
//                   text: 'llnln',
//                   size: 15,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
