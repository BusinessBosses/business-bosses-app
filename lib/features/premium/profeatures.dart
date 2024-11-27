import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfeatureTile extends StatelessWidget {
  final ProFeatureItem feature;

  const ProfeatureTile({Key? key, required this.feature}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: feature.color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  feature.iconPath,
                  height: 15,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      feature.caption,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      feature.subtext!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProFeatureItem {
  final String iconPath;
  final String caption;
  final String? subtext;
  final Color? color;
  final Color? iconcolor;

  ProFeatureItem({
    required this.iconPath,
    required this.caption,
    this.subtext,
    this.color,
    this.iconcolor,
  });
}
