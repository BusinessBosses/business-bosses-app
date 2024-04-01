import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChallengeController>(
      init:
          ChallengeController(), // Initialize controller here if not initialized before
      builder: (ChallengeController controller) {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.error.value) {
          return const Center(child: Text('Error fetching data'));
        } else {
          return ListView.builder(
            itemCount: controller.categories.length,
            itemBuilder: (BuildContext context, int index) {
              final Industry category = controller.categories[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => BossUpSection(industry: category));
                },
                child: Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                                  fontWeight: FontWeight.w700, fontSize: 17),
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
                            Container(
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
                                    placeholder:
                                        (BuildContext context, String photo) =>
                                            const CircularProgressIndicator(),
                                    errorWidget: (BuildContext context,
                                            String photo, dynamic error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      category.industry == 'Boss Up Challenge '
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      category.industry == 'Boss Up Challenge '
                                          ? 'Every Monday'
                                          : category.award ??
                                              _calculateEndsDate(
                                                  category.endedAt!),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 25,
                    bottom: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(
                            20), // Adjust the radius as needed
                      ),
                      child: category.endedAt != null
                          ? Text(
                              _calculateTimeLeft(category.endedAt!),
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            )
                          : const Text(
                              'Ongoing',
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w700),
                            ),
                    ),
                  )
                ]),
              );
            },
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
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} left";
    } else {
      return '1 day left';
    }
  }

  String _calculateEndsDate(DateTime endedAt) {
    // Format the endedAt date using DateFormat
    String formattedDate = DateFormat('d MMM').format(endedAt);
    return 'Ends $formattedDate';
  }
}
