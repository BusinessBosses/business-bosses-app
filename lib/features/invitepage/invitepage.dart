import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Invitepage extends StatefulWidget {
  const Invitepage({super.key});

  @override
  State<Invitepage> createState() => _InvitepageState();
}

class _InvitepageState extends State<Invitepage> {
  ProfileController profileController = Get.find();
  late String _referralId;
  final ReachController controller = Get.put(ReachController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadData(
          profileController.myProfile.uid, profileController.myProfile.uid);
    });

    _referralId = profileController.myProfile.inviteId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Invite',
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.loading.value) {
          return const SafetyModel();
        }

        final dynamic invites = controller.referrals.length;

        return SingleChildScrollView(
            child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                  height: 150,
                  child: Image.asset('assets/images/invitepicture.png')),
            ),
            const Text(
              '🏆 Win Ambassador of the Week!',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const Text(
              'Invite your Friends',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),

            const Text(
              'to join Business Bosses, earn & get featured',
              style: TextStyle(color: Colors.black87),
            ),

            const Text(
              'Copy link to share your InviteID with them',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),

            const SizedBox(height: 25),

            // ---------------------------------------
            // INVITE ID + COPY BUTTON
            // ---------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Invite ID:',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w700,
                            fontSize: 13),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _referralId,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      socialShare(
                          'Join Business Bosses using my invite ID \nhttps://businessbosses.onelink.me/xLWk/36a2ff16\nInvite ID: $_referralId');
                    },
                    child: Container(
                      width: 170,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        color: primaryColorLT,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Share InviteID',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.share, color: Colors.white, size: 16)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            // ---------------------------------------
            // ACCEPTED INVITATION
            // ---------------------------------------
            GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.referalsscreen,
                  arguments: profileController.myProfile.uid,
                );
              },
              child: _buildImpactItem(
                icon: Icons.people,
                iconColor: Colors.green[400]!,
                iconBgColor: Colors.green[50]!,
                title: 'Referrals',
                subtitle: 'Click to see who',
                value: invites.toString(),
                isLast: false,
              ),
            ),

            /// Ambassador Challenge Sectionuser
            ///

            SizedBox(height: 25),
          ],
        ));
      }),
    );
  }

  Widget _buildImpactItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String value,
    required bool isLast,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // ICON
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          // TEXTS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // VALUE
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
