import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/courses/controller/course_controller.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/courses/models/video_link_data.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
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

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  int optionCode = 1;
  String? title;
  String? description;
  final CourseController courseController = Get.put(CourseController());
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    if (videoLinks.isEmpty) {
      VideoLinkData videolin = VideoLinkData(url: '');
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
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        backgroundColor: backgroundcolorinterface,
        appBar: AppBar(
          title: Text(
              widget.course == null ? 'Start a Course' : 'Update Your Course'),
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
                  decoration:
                      inputDecoration.copyWith(hintText: 'Describe the Course'),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Add Youtube or Video links',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   margin: const EdgeInsets.only(bottom: 10),
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(15),
                //     ),
                //   ),
                //   child: Column(
                //     children: <Widget>[
                //       TextFormField(
                //         onChanged: (String value) {
                //           // Create a new VideoLinkData object from the entered URL
                //           VideoLinkData newVideoLink =
                //               VideoLinkData(url: value);
                //           // Replace the existing video link at index 0 with the new one
                //           videoLinks[0] = newVideoLink;
                //           setState(() {});
                //         },
                //         decoration: const InputDecoration(
                //           border: UnderlineInputBorder(),
                //           hintText: 'https://',
                //         ),
                //       ),
                //       const SizedBox(
                //         height: 10,
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Row(
                //             children: <Widget>[
                //               SvgPicture.asset('assets/svgs/subtitlesicon.svg'),
                //               const SizedBox(
                //                 width: 20,
                //               ),
                //               const Text('Subtitles / Closed Captions')
                //             ],
                //           ),
                //           Switch(
                //             value: _hasSubtitles,
                //             onChanged: (bool value) {
                //               setState(() {
                //                 _hasSubtitles = value;
                //               });
                //             },
                //           ),
                //         ],
                //       ),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: <Widget>[
                //           Row(
                //             children: <Widget>[
                //               SvgPicture.asset(
                //                   'assets/svgs/transcriptsicon.svg'),
                //               const SizedBox(
                //                 width: 20,
                //               ),
                //               const Text('Transcript'),
                //             ],
                //           ),
                //           Switch(
                //             value: _hasTranscript,
                //             onChanged: (bool value) {
                //               setState(() {
                //                 _hasTranscript = value;
                //               });
                //             },
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: videoLinks.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < videoLinks.length) {
                      return buildVideoLinkContainer(videoLinks[index], index);
                    } else {
                      return buildAddButton();
                    }
                  },
                ),

                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: (() async {
                    final FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true, // Allow multiple file selection
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Additional Course Materials (pdf,docx,doc,xls,etc)',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedFileNames
                      .map(
                        (String fileName) => Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(6),
                          color: Colors.white,
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
                //  Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: widget.isUpd
                //       ? Container()
                //       : Preview(controller: createMarketController),
                // ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Paid Course',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    Row(
                      children: <Widget>[
                        const Text(
                          'No',
                          style: TextStyle(
                              fontSize: 8, fontWeight: FontWeight.w700),
                        ),
                        Switch(
                          value: _paidCourse,
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
                                  } else {
                                    // Handle custom price
                                    // You can open a dialog or navigate to another screen for entering custom price
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
                              }).toList(),
                              DropdownMenuItem<int>(
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
                      if (selectedFilePaths.isNotEmpty) {
                        // Upload each file
                        for (String filePath in selectedFilePaths) {
                          await courseController.uploadFile(filePath);
                        }
                      }

                      if (title == null || title == '') {
                        Get.snackbar(
                          'Error',
                          'Title cannot be empty!',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      if (description == null || description == '') {
                        Get.snackbar(
                          'Error',
                          'Description cannot be empty!',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      if (!_validateVideoLinks()) {
                        Get.snackbar(
                          'Error',
                          'Please enter valid URLs for video links!',
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      Map<String, dynamic> course = <String, dynamic>{
                        'title': title,
                        'industryId': widget.industryId,
                        'description': description,
                        'userId': profileController.myProfile.uid,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'price': _courseprice,
                        'isPromoted': false,
                        'isActive': true,
                        'isApproved': false,
                        'subtitle': false,
                        'documents': selectedFileNames.isEmpty
                            ? null
                            : selectedFileNames,
                        'courseType': _paidCourse ? 'paid' : 'free',
                        'youtubeUrls': _extractYoutubeUrls(),
                        'transcript': '_extractTranscripts()',
                      };
                      widget.course == null
                          ? await courseController.createCourse(course)
                          : await courseController.updateCourse(course);
                    },
                    label: widget.course == null ? 'Post' : 'Update Course',
                    // isProcessing: _isProcessing,
                    buttonType: ButtonType.elevated,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                  onChanged: (String value) {
                    // Create a new VideoLinkData object from the entered URL
                    VideoLinkData newVideoLink = VideoLinkData(url: value);
                    // Replace the existing video link at index 0 with the new one
                    videoLinks.isNotEmpty
                        ? videoLinks[index] = newVideoLink
                        : videoLinks.add(newVideoLink);
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
                    ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Row(
          //       children: <Widget>[
          //         SvgPicture.asset('assets/svgs/subtitlesicon.svg'),
          //         const SizedBox(
          //           width: 20,
          //         ),
          //         const Text('Subtitles / Closed Captions')
          //       ],
          //     ),
          //     Switch(
          //       value: videoLinkData.hasSubtitles,
          //       onChanged: (bool value) {
          //         setState(() {
          //           videoLinkData.hasSubtitles = value;
          //         });
          //       },
          //     ),
          //   ],
          // ),
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
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(15),
                    hintText: 'Add transcript text here',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ))
        ],
      ),
    );
  }

  // Function to validate a URL using regular expressions
  bool _isValidUrl(String url) {
    // Regular expression to match URLs with optional HTTP/HTTPS protocol
    final RegExp urlRegExp = RegExp(
      r'^(https?://)?([a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+)(:\d+)?(/([^\s/]+)*)*(\?[\w\-.~!@$&*+=:?\\%]*[^\s/])?$',
      caseSensitive: false,
      multiLine: false,
    );
    return urlRegExp.hasMatch(url);
  }

  List<String> _extractYoutubeUrls() {
    List<String> youtubeUrls = [];
    for (dynamic videoLink in videoLinks) {
      if (_isValidUrl(videoLink.url)) {
        youtubeUrls.add(videoLink.url);
      }
    }
    return youtubeUrls;
  }

  List<String> _extractTranscripts() {
    List<String> videoTranscripts = [];
    for (dynamic videoLink in videoLinks) {
      videoTranscripts.add(videoLink.transcript);
    }
    return videoTranscripts;
  }

  bool _validateVideoLinks() {
    for (dynamic videoLink in videoLinks) {
      if (!_isValidUrl(videoLink.url)) {
        return false; // Return false if any URL is invalid
      }
    }
    return true; // Return true if all URLs are valid
  }

  Widget buildAddButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          videoLinks.length != 4
              ? videoLinks.add(VideoLinkData())
              : Get.snackbar('Error', 'You can only add 4 video links!');
          ;
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
