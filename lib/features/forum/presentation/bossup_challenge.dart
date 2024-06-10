import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BossupChallenge extends StatefulWidget {
  const BossupChallenge({super.key});

  @override
  State<BossupChallenge> createState() => _BossupChallengeState();
}

class _BossupChallengeState extends State<BossupChallenge> {
  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChallengeController>(
      init:
          ChallengeController(), // Initialize controller here if not initialized before
      builder: (ChallengeController controller) {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.error.value) {
          return SafetyModel(
            clickableText: 'Reload',
            isLoading: false,
            icon: const Icon(Icons.warning, color: Colors.black),
            onTap: () async {
              controller.initCategories();
            },
            title: 'There was an error loading data',
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: ListView.builder(
              itemCount: controller.categories.length,
              itemBuilder: (BuildContext context, int index) {
                final Industry category = controller.categories[index];
                return GestureDetector(
                  onTap: () {
                    DateTime now = DateTime.now();
                    if (category.startAt != null &&
                        now.isBefore(category.startAt!)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'How It Works!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  category.criteria!,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  _calculateStartDate(category.startAt!),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    Get.to(() => BossUpSection(
                          industry: category,
                          bossUp: controller.categories[0],
                        ));
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(15),
                        margin:
                            const EdgeInsets.only(top: 15, left: 15, right: 15),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  category.industry!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17),
                                ),
                                SvgPicture.asset(
                                  'assets/svgs/nexticon.svg',
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 86,
                                  width: 142,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: CachedNetworkImage(
                                        width: 120,
                                        imageUrl: category.photo!,
                                        memCacheHeight: 256,
                                        memCacheWidth: 256,
                                        placeholder: (BuildContext context,
                                                String photo) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (BuildContext context,
                                                String photo, dynamic error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 25,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          category.industryId ==
                                                  '-MsUOGcOT9oRXGakCcJv'
                                              ? 'Free Promotion'
                                              : category.award ?? 'Win',
                                          style: const TextStyle(
                                            color: primaryColorLT,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Icon(
                                          Icons.watch_later_outlined,
                                          size: 15,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          category.industryId ==
                                                  '-MsUOGcOT9oRXGakCcJv'
                                              ? 'Every Monday'
                                              : _getChallengeStatus(category),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    _getChallengeTimeLeft(category),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  String _calculateTimeLeft(DateTime endTime) {
    DateTime now = DateTime.now();
    Duration difference = endTime.difference(now);

    if (difference.isNegative) {
      return "Time's up"; // Or handle accordingly if time is already passed
    } else if (difference.inDays > 0) {
      return "Ends in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}";
    } else {
      return '1 day left';
    }
  }

  Widget _getChallengeTimeLeft(Industry category) {
    DateTime now = DateTime.now();
    if (category.startAt != null && now.isBefore(category.startAt!)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.grey.withAlpha(40),
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        child: Text(
          _calculateTimeLeftToStart(category.startAt!),
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else if (category.endedAt != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(40),
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        child: Text(
          _calculateTimeLeft(category.endedAt!),
          style: const TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.green.withAlpha(40),
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
        ),
        child: const Text(
          'Ongoing',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }
  }

  String _calculateTimeLeftToStart(DateTime startTime) {
    DateTime now = DateTime.now();
    Duration difference = startTime.difference(now);

    if (difference.inDays > 0) {
      return "Starts in ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}";
    } else {
      return 'Starts in 1 day';
    }
  }

  String _calculateEndsDate(DateTime endedAt) {
    // Format the endedAt date using DateFormat
    String formattedDate = DateFormat('d MMM').format(endedAt);
    return 'Ends $formattedDate';
  }

  String _calculateStartDate(DateTime startAt) {
    // Format the endedAt date using DateFormat
    String formattedDate = DateFormat('d MMM').format(startAt);
    return 'Starts $formattedDate';
  }

  String _getChallengeStatus(Industry category) {
    DateTime now = DateTime.now();
    if (category.startAt != null && now.isBefore(category.startAt!)) {
      return _calculateStartDate(category.startAt!);
    } else if (category.endedAt != null) {
      return _calculateEndsDate(category.endedAt!);
    } else {
      return 'Ends';
    }
  }
}
