import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';

Center noNotificationsFoundWidget(String title) {
  return Center(
    child: SingleChildScrollView(
      child: Column(
        children: [
          SafetyModel(
            isLoading: false,
            icon: SvgPicture.asset(
              'assets/svgs/notification.svg',
              color: iconColor,
              height: 80.0,
              width: 80.0,
            ),
            title: 'You have no notification',
            subTitle: 'You\'ll receive all new $title here',
          ),
          const SizedBox(height: 150.0)
        ],
      ),
    ),
  );
}
