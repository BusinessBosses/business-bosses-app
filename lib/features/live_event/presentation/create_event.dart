import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/presentation/confirm_create_event.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';

import '../../../common/widgets/buttons/custom_button.dart';
import '../controller/live_event_controller.dart';

class CreateEvent extends StatefulWidget {
  final EventModel? event;
  const CreateEvent({super.key, this.event});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  final ProfileController profileController = Get.find();
  DateTime startAt = DateTime.now();
  DateTime endAt = DateTime.now();
  DateTime selectedDateTime = DateTime.now();
  final LiveController liveEventController = Get.put(LiveController());
  bool isLoading = false;

  String? roomID;
  File? _selectedImage;
  String? updateImage;

  @override
  void initState() {
    super.initState();

    if (widget.event != null) {
      roomID = widget.event!.roomId;
      updateImage = widget.event!.image;
      titleController.text = widget.event!.title!;
      startAt = widget.event!.startAt!.toLocal();
      endAt = widget.event!.endAt!.toLocal();
      descriptionController.text = widget.event!.description ?? '';
      linkController.text = widget.event!.link ?? '';
    } else {
      roomID = generateRandomRoomID();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('d MMM, y');

    // Format the date
    final String formattedDate = dateFormat.format(startAt);

    // Here, you can define the content of your bottom sheet.
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: Text(
          widget.event != null ? 'Update Event' : 'Create Event',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                      244, 244, 244, 1), // Background color
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                  border: Border.all(
                    color:
                        const Color.fromRGBO(224, 224, 224, 1), // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Add Title',
                    labelStyle: TextStyle(fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                constraints: const BoxConstraints(
                  minHeight: 150.0, // Set a minimum height for the container
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                      244, 244, 244, 1), // Background color
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                  border: Border.all(
                    color:
                        const Color.fromRGBO(224, 224, 224, 1), // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextField(
                  controller: descriptionController,
                  maxLines: null, // Allow the text field to expand vertically
                  keyboardType:
                      TextInputType.multiline, // Allow multiline input
                  decoration: const InputDecoration(
                    labelText: 'Add Description',
                    labelStyle: TextStyle(fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(
                      244, 244, 244, 1), // Background color
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                  border: Border.all(
                    color:
                        const Color.fromRGBO(224, 224, 224, 1), // Border color
                    width: 1.0, // Border width
                  ),
                ),
                child: TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                    labelText: 'Add Zoom or Google Meet Link',
                    labelStyle: TextStyle(fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(235, 235, 235, 1),
                    ),
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, right: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                // ignore: unnecessary_null_comparison
                                startAt == null
                                    ? 'Select Start and Time'
                                    : 'Starts at:',
                              ),
                              onTap: () => _selectDate(context, true),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, true),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, true),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formatTime(startAt),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                // ignore: unnecessary_null_comparison
                                startAt == null
                                    ? 'Select Start and Time'
                                    : 'End at:',
                              ),
                              onTap: () => _selectDate(context, true),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, false),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _selectDate(context, false),
                            child: Container(
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color:
                                      const Color.fromRGBO(224, 224, 224, 1)),
                              child: Text(
                                formatTime(endAt),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            if (_selectedImage == null)
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    const TextWidget(
                      text: 'Add image',
                      fontWeight: FontWeight.w700,
                      size: 17,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => _pickImage(context),
                      child: CircleAvatar(
                        radius: 26 / 1.38,
                        backgroundColor: backgroundColor,
                        child: SvgPicture.asset(
                          'assets/svgs/addimagepost.svg',
                          height: 18,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'Max file size for images is 10Mb',
                      style: TextStyle(fontSize: 11, color: Colors.red),
                    )
                  ],
                ),
              ),
            if (_selectedImage != null || updateImage != null)
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
                    child: updateImage == null
                        ? Image.file(_selectedImage!)
                        : NetworkImageWithPlaceHolder(imageUrl: updateImage),
                  ),
                  Positioned(
                    top: 25,
                    right: 25,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make it a circle
                        color: Colors.red
                            .withOpacity(0.5), // Choose your desired color
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ), // Close icon
                        onPressed: _removeImage,
                      ),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(
                isProcessing: isLoading,
                buttonType: ButtonType.elevated,
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  String? imageUrl;
                  final DateTime endAtt = endAt.toUtc();
                  final DateFormat dateFormat =
                      DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS');
                  final DateFormat timeFormat = DateFormat('h:mm a');

                  // Format the UTC DateTime to the desired string format
                  String formattedEndDateTime = dateFormat.format(endAtt);
                  final DateTime startAtt = startAt.toUtc();

                  // Format the UTC DateTime to the desired string format
                  String formattedStartDateTime = dateFormat.format(startAtt);
                  String formattedStartTime = timeFormat.format(startAtt);

                  if (linkController.text.isNotEmpty &&
                      !isValidMeetingLink(linkController.text)) {
                    showSnackBar(
                      context,
                      message: 'Please enter a valid Zoom or Google Meet link',
                    );
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }
                  if (titleController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    showSnackBar(
                      context,
                      message: 'Please enter a title and description!',
                    );
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }
                  if (endAt.isBefore(startAt)) {
                    // Show an error message or handle it in a way that's appropriate for your app.
                    showSnackBar(context,
                        message: 'End time cannot be before start time');
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }
                  if (startAt.isBefore(DateTime.now()) ||
                      endAt.isBefore(DateTime.now())) {
                    // Show an error message or handle it as per your app's requirements.
                    showSnackBar(context,
                        message: 'Start time cannot be in the past');
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }

                  if (endAt.isAfter(startAt.add(const Duration(hours: 2)))) {
                    showSnackBar(context,
                        message: 'Event duration cannot be more than 2 hours');
                    setState(() {
                      isLoading = false;
                    });
                    return;
                  }
                  if (_selectedImage != null) {
                    dynamic response =
                        await ApiService.uploadFile(_selectedImage!);
                    if (response['success']) {
                      imageUrl = response['fileUrl'];
                    }
                  } else if (updateImage != null) {
                    imageUrl = updateImage;
                  }

                  Map<String, dynamic> data = <String, dynamic>{
                    'title': titleController.text,
                    'roomId': roomID,
                    'startAt': formattedStartDateTime,
                    'endAt': formattedEndDateTime,
                    'startTime': '00:00:00',
                    'user': profileController.myProfile.toMap(),
                    'image': imageUrl,
                    'link': widget.event!.link,
                    'description': widget.event!.description,
                  };

                  Map<String, dynamic> dataa = <String, dynamic>{
                    'title': titleController.text,
                    'roomId': roomID,
                    'date': formattedDate,
                    'starttime': formattedStartTime,
                    'startat': startAtt.toString(),
                    'endat': endAtt.toString(),
                    'host': profileController.myProfile.name,
                    'photourl': profileController.myProfile.photoUrl,
                    'user': profileController.myProfile.toString(),
                    'image': imageUrl,
                    'link': widget.event!.link,
                    'description': widget.event!.description,
                  };

                  String? jsonData = jsonEncode(dataa);

                  if (widget.event != null) {
                    data['id'] = widget.event?.id;
                  }
                  if (widget.event != null) {
                    await liveEventController.updateEvent(data);
                    Get.off(() => ConfirmCreateEvent(
                          roomID: roomID!,
                          time: '$formattedDate  $formattedStartTime ',
                          title: titleController.text,
                          livedata: jsonData,
                          isUpdate: false,
                        ));
                  } else {
                    dynamic id = await liveEventController.createEvent(data);
                    dataa['id'] = id;
                    jsonData = jsonEncode(dataa);
                    Get.off(() => ConfirmCreateEvent(
                          roomID: roomID!,
                          time: '$formattedDate  $formattedStartTime ',
                          title: titleController.text,
                          livedata: jsonData,
                          isUpdate: true,
                        ));
                  }
                },
                child: Text(
                    widget.event != null ? 'Update Event' : 'Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidMeetingLink(String link) {
    final RegExp zoomRegExp =
        RegExp(r'^https://(www\.)?zoom\.us/j/[a-zA-Z0-9]+');
    final RegExp googleMeetRegExp =
        RegExp(r'^https://meet\.google\.com/[a-zA-Z0-9\-]+');

    return zoomRegExp.hasMatch(link) || googleMeetRegExp.hasMatch(link);
  }

  // void jumpToLivePage(BuildContext context,
  //     {required String roomID, required bool isHost, required String title}) {
  //   Navigator.push(
  //     context,
  //     // ignore: always_specify_types
  //     MaterialPageRoute(
  //       builder: (BuildContext context) => CallRoom(
  //         roomID: roomID,
  //         isHost: isHost,
  //         title: title,
  //       ),
  //     ),
  //   );
  // }

  String formatTime(DateTime dateTime) {
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }

  String generateRandomRoomID() {
    final Random random = Random();

    // Generate three random letters for the "abc" part.
    // ignore: always_specify_types
    final String randomABC = String.fromCharCodes(List.generate(3,
        (_) => random.nextInt(26) + 97)); // ASCII values for lowercase letters.

    // Generate a random integer between 0 and 999 (inclusive).
    final String randomSuffix = random.nextInt(1000).toString().padLeft(3, '0');

    return '$randomABC-$randomSuffix';
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
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

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      updateImage = null;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartTime) async {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (DateTime date) {
        setState(() {
          selectedDateTime = date;
          if (isStartTime) {
            setState(() {
              startAt = selectedDateTime;
            });
          } else {
            setState(() {
              endAt = selectedDateTime;
            });
          }
        });
      },
      currentTime: DateTime.now(),
    );
  }
}
