import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/impact/widgets/impactheadercard.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
          onPressed: () {
            Navigator.pop(context);
          },
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
          return SafetyModel();
        }
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ImpactHeaderCard(
                data: controller.data,
              ),
            ],
          ),
        );
      }),
    );
  }
}
