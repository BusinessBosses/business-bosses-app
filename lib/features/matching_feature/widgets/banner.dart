import 'package:business_bosses_v2/features/matching_feature/widgets/pre_match_modal.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PersonalizationBanner extends StatelessWidget {
  final VoidCallback? onSetupPressed;
  final VoidCallback? onClosePressed;

  const PersonalizationBanner({
    super.key,
    this.onSetupPressed,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light amber background
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFFFE082), // Amber border
          width: 1,
        ),
      ),
      child: Row(
        children: <Widget>[
          // Warning icon
          Icon(
            LucideIcons.alertTriangle,
            color: const Color(0xFFFF8F00), // Orange color
            size: 20,
          ),
          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) => PreMatchModal());
              },
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF424242),
                    height: 1.3,
                  ),
                  children: <InlineSpan>[
                    const TextSpan(
                      text: 'Discover the right match for your growth. ',
                    ),
                    TextSpan(
                      text: 'Find My Match',
                      style: const TextStyle(
                        color: Color(0xFF1976D2), // Blue color
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      // You can add a recognizer here for tap handling
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Close button
          GestureDetector(
            onTap: onClosePressed,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: textColor.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.x,
                color: textColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
