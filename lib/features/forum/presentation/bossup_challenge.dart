import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/forum/controller/challenge_controller.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_screen.dart';
import 'package:business_bosses_v2/features/forum/widgets/challengeitem.dart';
import 'package:business_bosses_v2/features/home/widgets/learningpage.dart';
import 'package:business_bosses_v2/features/partners/presentation/boss_up_partner.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
      body: GetBuilder<ChallengeController>(
        init: ChallengeController(),
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
            return Container(
              color: backgroundColor,
              padding: EdgeInsets.all(15),
              child: MasonryGridView.count(
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                scrollDirection:
                    widget.ishome! == true ? Axis.horizontal : Axis.vertical,

                // UPDATED: removed ambassador challenge (+3 instead of +4)
                itemCount: controller.categories.length + 3,

                itemBuilder: (BuildContext context, int index) {
                  if (index < controller.categories.length) {
                    final Industry category = controller.categories[index];
                    return Challengeitem(
                      time: category.industryId == '-MsUOGcOT9oRXGakCcJv'
                          ? 'Every Monday'
                          : _getChallengeStatus(category),
                      category: category,
                      title: category.industry!,
                      imageurl: category.photo,
                      categorytype:
                          category.industryId == '-MsUOGcOT9oRXGakCcJv'
                              ? 'Free Promotion'
                              : category.award ?? 'Win',
                      OnTap: () {
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
                    );
                  }

                  // REMOVED: Ambassador challenge block

                  else if (index == controller.categories.length) {
                    return Challengeitem(
                      isCrowdfund: true,
                      OnTap: () {
                        Get.to(() => const DonationsPage(
                              ishome: false,
                            ));
                      },
                      description:
                          'Share your project to receive funding support ',
                      iscustom: true,
                      title: 'Crowdfund',
                      imageurl: 'assets/images/donationpic.png',
                    );
                  } else if (index == controller.categories.length + 1) {
                    return Challengeitem(
                      isMentor: true,
                      OnTap: () {
                        Get.to(() => LearningPage());
                      },
                      title: 'Mentor of the Week',
                      description:
                          'Share learnings and resources for upskilling and mentorship',
                      imageurl:
                          'https://images.pexels.com/photos/247819/pexels-photo-247819.jpeg',
                    );
                  } else {
                    return Challengeitem(
                      isPartner: true,
                      OnTap: () {
                        Get.to(() => BossUpPartner());
                      },
                      title: 'Partner\'s Deals',
                      description: 'Discover and list deals and get customers.',
                      imageurl:
                          'https://images.pexels.com/photos/5520322/pexels-photo-5520322.jpeg',
                    );
                  }
                },
                crossAxisCount: 2,
              ),
            );
          }
        },
      ),
    );
  }

  String _calculateStartDate(DateTime startAt) {
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

  String _calculateEndsDate(DateTime endedAt) {
    String formattedDate = DateFormat('d MMM').format(endedAt);
    return 'Ends $formattedDate';
  }
}
