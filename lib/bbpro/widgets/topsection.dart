import 'package:business_bosses_v2/bbpro/widgets/iconbutton.dart';
import 'package:flutter/material.dart';

class TopsectionWidget extends StatelessWidget {
  final String buttonText;
  final VoidCallback onHowItWorksPressed;
  final VoidCallback onAddProjectPressed;

  const TopsectionWidget({
    super.key,
    required this.buttonText,
    required this.onHowItWorksPressed,
    required this.onAddProjectPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton.icon(
            onPressed: onHowItWorksPressed,
            icon: const Icon(Icons.info_outline, color: Colors.black),
            label: const Text(
              'How it works',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ProIconButton(
            icon: const Icon(Icons.add),
            onPressed: onAddProjectPressed,
            text: buttonText,
            radius: 10,
          ),
        ],
      ),
    );
  }
}
