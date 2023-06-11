import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../posts/widgets/my_container.dart';
import '../../utils/theme/theme.dart';

class InviteAFriendTermsAndConditions extends StatelessWidget {
  static const String routeName = '/tiles-rules-scree';

  const InviteAFriendTermsAndConditions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String description = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Invite a friend Terms & Conditions',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: MyContainer(
        margin: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Text(
            description ?? 'Description',
            style: bodyText2,
          ),
        ),
      ),
    );
  }
}
