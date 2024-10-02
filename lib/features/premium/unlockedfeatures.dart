import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeatureTile extends StatelessWidget {
  final FeatureItem feature;

  const FeatureTile({Key? key, required this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: feature.color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SvgPicture.asset(
          feature.iconPath,
          // color: iconColor, // Assuming your SVGs are white
          height: 24,
          width: 24,
        ),
      ),
      title: Text(
        feature.caption,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        feature.subtext,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }
}

class FeatureItem {
  final String iconPath;
  final String caption;
  final String subtext;
  final Color color;
  final Color? iconcolor;

  FeatureItem({
    required this.iconPath,
    required this.caption,
    required this.subtext,
    required this.color,
    this.iconcolor,
  });
}
