import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

class CustomTileAnalyse extends StatelessWidget {
  final Function() onTap;

  final String label;
  final bool hideIcon;
  final bool showBorder;

  const CustomTileAnalyse({
    super.key,
    required this.onTap,
    required this.label,
    this.hideIcon = false,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: InkWell(
            onTap: onTap,
            child: Ink(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ListTile(
                leading: hideIcon
                    ? null
                    : SvgPicture.asset('assets/svgs/connectrelevant.svg'),
                title: Text(
                  label,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: textColor),
                ),
                trailing: hideIcon
                    ? null
                    : SvgPicture.asset('assets/svgs/nexticon.svg'),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: double.infinity,
          height: 1.5,
          child: ColoredBox(color: backgroundcolorinterface),
        ),
      ],
    );
  }
}
