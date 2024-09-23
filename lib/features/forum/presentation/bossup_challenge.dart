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
  final Color? backgroundColor;
  final bool? ishome;
  const BossupChallenge({super.key, this.ishome, this.backgroundColor});

  @override
  State<BossupChallenge> createState() => _BossupChallengeState();
}

class _BossupChallengeState extends State<BossupChallenge> {
  final ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor ?? Colors.white,
        appBar: widget.ishome == false
            ? AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                ),
                centerTitle: true,
                title: const Text(
                  'Challenge',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              )
            : null,
        body: GetBuilder<ChallengeController>(
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
              return ListView.builder(
                scrollDirection:
                    widget.ishome! == true ? Axis.horizontal : Axis.vertical,
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
                          padding: widget.ishome == true
                              ? const EdgeInsets.only(left: 10, right: 10)
                              : const EdgeInsets.all(15),
                          margin: widget.ishome == false
                              ? const EdgeInsets.only(
                                  top: 15, left: 15, right: 15)
                              : const EdgeInsets.only(
                                  left: 10,
                                ),
                          decoration: BoxDecoration(
                            border:
                                Border.all(width: 0.5, color: Colors.black12),
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              if (widget.ishome == false)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  Container(
                                    height: 86,
                                    width: 142,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(9.9),
                                        border: Border.all(
                                          color: Colors.black12,
                                          width: 0.5,
                                        )),
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
                                              const Center(
                                            child: SizedBox(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (BuildContext context,
                                                  String photo,
                                                  dynamic error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (widget.ishome == false)
                                    const SizedBox(
                                      width: 25,
                                    ),
                                  if (widget.ishome == false)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                  : _getChallengeStatus(
                                                      category),
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
                              if (widget.ishome == true)
                                const SizedBox(
                                  height: 10,
                                ),
                              if (widget.ishome == true)
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      const Spacer(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: _getChallengeTimeLeft(category),
                                      ),
                                    ],
                                  ),
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }

  String _calculateTimeLeft(DateTime endTime) {
    DateTime now = DateTime.now();
    Duration difference = endTime.difference(now);

    if (difference.isNegative) {
      return "Time's up"; // Or handle accordingly if time is already passed
    } else if (difference.inDays > 0) {
      return "Ends ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}";
    } else {
      return '1 day left';
    }
  }

  Widget _getChallengeTimeLeft(Industry category) {
    DateTime now = DateTime.now();
    bool hasNotStarted =
        category.startAt != null && now.isBefore(category.startAt!);

    return SizedBox(
      width: 142,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              color: hasNotStarted
                  ? Colors.grey.withAlpha(40)
                  : Colors.green.withAlpha(40),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              hasNotStarted
                  ? _calculateTimeLeftToStart(category.startAt!)
                  : category.endedAt != null
                      ? _calculateTimeLeft(category.endedAt!)
                      : 'Ongoing',
              style: TextStyle(
                color: hasNotStarted ? Colors.black54 : Colors.green,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (widget.ishome == true)
            GestureDetector(
              onTap: () {
                hasNotStarted
                    ? null
                    : Get.to(() => BossUpSection(
                          industry: category,
                          bossUp: Get.find<ChallengeController>().categories[0],
                        ));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: hasNotStarted
                        ? Colors.grey.withAlpha(40)
                        : primaryColorLT,
                  ),
                ),
                child: Text(
                  'Enter',
                  style: TextStyle(
                    color: hasNotStarted ? Colors.grey : primaryColorLT,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _calculateTimeLeftToStart(DateTime startTime) {
    DateTime now = DateTime.now();
    Duration difference = startTime.difference(now);

    if (difference.inDays > 0) {
      return "Starts ${difference.inDays} day${difference.inDays > 1 ? 's' : ''}";
    } else {
      return 'Starts 1 day';
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
