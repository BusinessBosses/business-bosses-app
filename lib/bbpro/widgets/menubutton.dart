import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: SvgPicture.asset(
        'assets/svgs/menu.svg',
        height: 25,
        color: Colors.black,
      ),
    );
  }
}
