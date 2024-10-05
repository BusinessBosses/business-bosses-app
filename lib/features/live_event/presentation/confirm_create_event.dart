// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';

class ConfirmCreateEvent extends StatefulWidget {
  final String roomID;
  final String? time;
  final String? title;
  final String? livedata;
  final bool? isUpdate;

  const ConfirmCreateEvent({
    super.key,
    required this.roomID,
    this.time,
    this.title,
    this.livedata,
    this.isUpdate = false,
  });

  @override
  State<ConfirmCreateEvent> createState() => _ConfirmCreateEventState();
}

class _ConfirmCreateEventState extends State<ConfirmCreateEvent> {
  final LiveController liveController = Get.find();
  @override
  Widget build(BuildContext context) {
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
          widget.isUpdate != null && widget.isUpdate == true
              ? 'Event Updated'
              : 'Event Created',
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            child: Text(
              '\n\nYour Live Event Will Be Hosted With The following ID \n',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            child: Text(
              widget.roomID,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  final String generatedRoomID = widget.roomID;
                  Clipboard.setData(ClipboardData(text: generatedRoomID));
                  showSnackbar(message: 'Room ID copied to clipboard');
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15, top: 8, bottom: 8),
                    child: Row(
                      children: <Widget>[
                        Text('Copy ID'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.copy)
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: () {
                  String message =
                      'Join this Event On The Business Bosses App With Room ID: ${widget.roomID} https://businessbosses.onelink.me/xLWk/36a2ff16';
                  socialShare(message);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 15.0, right: 15, top: 8, bottom: 8),
                    child: Row(
                      children: <Widget>[
                        Text('Share ID'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.share)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              buttonType: ButtonType.elevated,
              onPressed: () {
                String sharemessage =
                    'Hey there! Join this event on ${widget.time} with Room ID: ${widget.roomID}';
                String title = '${widget.title}';
                String livedata = '${widget.livedata}';

                Get.toNamed(Routes.createPost, arguments: <String, String>{
                  'sharemessage': sharemessage,
                  'title': title,
                  'livedata': livedata,
                });
              },
              child: const Text('Post on Business Bosses'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
            child: CustomButton(
              buttonType: ButtonType.outline,
              onPressed: () {
                liveController.initEvents();
                Get.toNamed(Routes.liveEvents);
              },
              child: const Text('Go Back'),
            ),
          ),
        ],
      ),
    );
  }
}
