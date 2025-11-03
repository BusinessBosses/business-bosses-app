import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/widgets/impactheadercard.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ImpactScreen extends StatefulWidget {
  final UserModel user;
  const ImpactScreen({super.key, required this.user});

  @override
  State<ImpactScreen> createState() => _ImpactScreenState();
}

class _ImpactScreenState extends State<ImpactScreen> {
  final ImpactController controller = Get.put(ImpactController());
  final ProfileController profileController = Get.find();

  @override
  void initState() {
    super.initState();
    controller.loadData(profileController.myProfile.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Impact',
          textAlign: TextAlign.center,
        ),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const SafetyModel();
        }

        final invites = controller.data['invitesThisWeek'] ?? 0;
        final rank = controller.data['rank'] ?? 12;

        // if (true) {
        //   return SafetyModel(
        //     isLoading: false,
        //     icon: Icon(Icons.warning),
        //     title: 'NO User Referred!',
        //   );
        // }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Ambassador Challenge Sectionuser
              if (widget.user == profileController.myProfile)
                Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '🏆 Win Ambassador of the Week!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Boost your Impact Score by getting more likes, views, and referrals this week to move up the leaderboard!',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Challenge + Progress
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: invites / 10,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade50,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$invites / 10 invites completed',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),

                      // Rank Display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Your Rank:',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '#$rank',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ImpactHeaderCard(data: controller.data),

              const SizedBox(height: 15),
            ],
          ),
        );
      }),
    );
  }
}
