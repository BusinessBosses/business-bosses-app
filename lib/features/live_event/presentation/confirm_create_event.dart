// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';

class ConfirmCreateEvent extends StatefulWidget {
  final String roomID;
  const ConfirmCreateEvent({super.key, required this.roomID});

  @override
  State<ConfirmCreateEvent> createState() => _ConfirmCreateEventState();
}

class _ConfirmCreateEventState extends State<ConfirmCreateEvent> {
  final LiveController liveController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Created'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () {
                  // Copy the generated room ID to the clipboard
                  final String generatedRoomID = widget.roomID;
                  Clipboard.setData(ClipboardData(text: generatedRoomID));
                  showSnackbar(message: 'Room ID copied to clipboard');
                },
              ),
              GestureDetector(
                onTap: () {
                  String message =
                      'Join My Event On The Business Bosses App With Room ID: ${widget.roomID}';
                  socialShare(message);
                },
                child: SvgPicture.asset(
                  'assets/svgs/share.svg',
                  height: 15.0,
                  width: 15.0,
                  // ignore: deprecated_member_use
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
              buttonType: ButtonType.elevated,
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
