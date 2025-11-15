import 'package:business_bosses_v2/action/action.dart';
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

  @override
  void initState() {
    super.initState();
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SizedBox(
                  height: 200,
                  child: Image.asset('assets/images/invitepicture.png')),
            ),

            const SizedBox(height: 18),

            const Text(
              'Invite your Friends',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'to join Business Bosses and get a Free Promotion',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 5),
            const Text(
              'Copy link to share your InviteID with them',
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),

            const SizedBox(height: 25),

            // ---------------------------------------
            // INVITE ID + COPY BUTTON
            // ---------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
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
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      socialShare(
                          'Join Business Bosses using my invite ID $_referralId');
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
                value: 0.toString(),
                isLast: false,
              ),
            ),

            const Spacer(),

            // ---------------------------------------
            // TERMS
            // ---------------------------------------
            // GestureDetector(
            //   onTap: () {},
            //   child: const Padding(
            //     padding: EdgeInsets.only(bottom: 15),
            //     child: Text(
            //       'Terms and Conditions',
            //       style: TextStyle(
            //         color: Colors.red,
            //         fontSize: 12,
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
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
          color: Colors.grey.withOpacity(0.2),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
