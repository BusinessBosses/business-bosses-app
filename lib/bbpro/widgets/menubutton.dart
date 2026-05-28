import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CustomMenuButton extends StatelessWidget {
  const CustomMenuButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.transparent,
      child: Icon(LucideIcons.menu, color: textColor, size: 25),
    );
  }
}
