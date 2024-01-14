// ignore_for_file: public_member_api_docs

import 'dart:math';

import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/live_event/controller/live_event_controller.dart';
import 'package:business_bosses_v2/features/live_event/models/events_model.dart';
import 'package:business_bosses_v2/features/live_event/widgets/call_room.dart';
import 'package:business_bosses_v2/features/live_event/widgets/event_call.dart';
import 'package:business_bosses_v2/features/live_event/widgets/my_events.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import '../../../action/action.dart';
import 'create_event.dart';

class LiveEvent extends StatefulWidget {
  const LiveEvent({super.key});

  @override
  State<LiveEvent> createState() => _LiveEventState();
}

class _LiveEventState extends State<LiveEvent> {
  final LiveController liveEventController = Get.put(LiveController());
  TextEditingController joinEvent = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ProfileController profileController = Get.find();
  bool _isSearching = false;

  List<Widget> get mActions {
    return <Widget>[
      IconButton(
        icon: _isSearching
            ? const Icon(Icons.close)
            : SvgPicture.asset(
                'assets/svgs/search.svg',
              ),
        onPressed: () {
          // if (_isSearching) {
          _isSearching = !_isSearching;
          // }
          setState(() {});
          ;
        },
      ),
      IconButton(
        onPressed: () {
          Get.to(() => MyEvents(
                joined: liveEventController.joined,
              ));
        },
        icon: const Icon(Icons.calendar_month),
      ),
    ];
  }

  @override
  void initState() {
    tzdata.initializeTimeZones(); // Initialize time zones
    super.initState();
  }

  DateTime selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LiveController>(
      builder: (LiveController liveController) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Get.offNamed(Routes.home);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              centerTitle: true,
              title: _isSearching
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: joinEvent,
                            decoration: const InputDecoration(
                              hintText: 'Find Event By ID',
                              filled: true,
                              fillColor: backgroundColor,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 224, 224, 1),
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 0,
                                bottom: 0,
                              ),
                            ),
                            enableSuggestions: true, // Enable pasting
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (joinEvent.text.isEmpty) {
                              showSnackBar(
                                context,
                                message: 'Please enter a title',
                              );
                              return;
                            }
                            joinLive(context, joinEvent.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(242, 28, 41, 1),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: SvgPicture.asset(
                            'assets/svgs/search.svg',
                            color: Colors.white,
                            width: 20,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Live Events',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
              actions: mActions,
            ),
            body: liveController.loading.value
                ? const Center(child: CircularProgressIndicator())
                : NestedScrollView(
                    controller: scrollController,
                    headerSliverBuilder: (
                      BuildContext context,
                      bool innerBoxIsScrolled,
                    ) {
                      return <Widget>[
                        SliverStickyHeader(
                          sticky: true,
                          header: Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 10,
                                      right: 15,
                                      left: 15,
                                    ),
                                    height: 150,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/live_event.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const Positioned(
                                    top: 50,
                                    right: 35,
                                    child: Text(
                                      'Share your thoughts with bosses\n We want to listen as it happens',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    right: 35,
                                    child: ElevatedButton(
                                      onPressed: () => Navigator.push(
                                        context,
                                        // ignore: always_specify_types
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const CreateEvent(),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Create Live Event',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: DefaultTabController(
                      length: 3, // Number of tabs
                      child: Column(
                        children: <Widget>[
                          Container(
                            constraints:
                                const BoxConstraints.expand(height: 50),
                            child: TabBar(
                              tabs: <Widget>[
                                Tab(
                                  child: SvgPicture.asset(
                                    'assets/svgs/liveevent.svg',
                                    width: 15,
                                  ),
                                ),
                                const Tab(text: 'Ongoing'),
                                const Tab(text: 'Upcoming'),
                              ],
                            ),
                          ),
                          const Expanded(
                            child: TabBarView(
                              children: <Widget>[
                                // Content of Tab 1
                                EventCall(
                                  full: true,
                                ),

                                // Content of Tab 2
                                EventCall(
                                  ongoing: true,
                                ),

                                // Content of Tab 3

                                EventCall(
                                  ongoing: false,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
      },
    );
  }

  void jumpToLivePage(
    BuildContext context, {
    required String roomID,
    required bool isHost,
    required String title,
  }) {
    Navigator.push(
      context,
      // ignore: always_specify_types
      MaterialPageRoute(
        builder: (BuildContext context) => CallRoom(
          title: title,
          roomID: roomID,
          isHost: isHost,
        ),
      ),
    );
  }

  void joinLive(BuildContext context, String id) {
    final EventModel? event = liveEventController.getEventById(id);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final double screenHeight = MediaQuery.of(context).size.height;
        final double halfScreenHeight = screenHeight / 3;
        if (event != null) {
          final DateFormat dateFormat = DateFormat('d MMM, y');
          final String formattedDate = dateFormat.format(event.startAt!);
          final DateFormat timeFormat = DateFormat('h:mm a');

// Convert the event start and end times to the local time zone
          final DateTime localStartTime = event.startAt!.toLocal();
          final DateTime localEndTime = event.endAt!.toLocal();
          final String formattedStartTime = timeFormat.format(localStartTime);
          final String formattedEndTime = timeFormat.format(localEndTime);
          final DateTime now = DateTime.now();
          return SizedBox(
            height: halfScreenHeight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Title: ${event.title!}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Date: ${formattedDate.toString()}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    'Time: $formattedStartTime - $formattedEndTime',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Host:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      NetworkImageWithPlaceHolder(
                        imageUrl: event.user?.photoUrl,
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(event.user?.name ?? event.user!.username,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                    ],
                  ),
                  const Spacer(),
                  if (event.startAt!.isBefore(now) && event.endAt!.isAfter(now))
                    ElevatedButton(
                      child: const Text('Join'),
                      onPressed: () {
                        final String enteredRoomID = event.roomId!;
                        if (profileController.myProfile.uid !=
                            event.user?.uid) {
                          jumpToLivePage(
                            context,
                            title: event.title!,
                            roomID: enteredRoomID,
                            isHost: false,
                          );
                        } else {
                          jumpToLivePage(
                            context,
                            title: event.title!,
                            roomID: enteredRoomID,
                            isHost: true,
                          );
                        }
                      },
                    ),
                  ElevatedButton(
                    child: const Text('Back'),
                    onPressed: () {
                      // Handle Option 2 action here.
                      Navigator.pop(context); // Close the bottom sheet.
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return SizedBox(
            height: halfScreenHeight,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Event does not exist with the ID: $id',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    child: const Text('Back'),
                    onPressed: () {
                      // Handle Option 2 action here.
                      Navigator.pop(context); // Close the bottom sheet.
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
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
    Get.delete<LiveController>();
    super.dispose();
  }

  String formatTime(DateTime dateTime) {
    final String formattedTime = DateFormat('h:mm a').format(dateTime);
    return formattedTime;
  }
}
