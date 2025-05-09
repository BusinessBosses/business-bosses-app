import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: SvgPicture.asset(
        'assets/svgs/menu.svg',
        height: 25,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    );
  }
}
