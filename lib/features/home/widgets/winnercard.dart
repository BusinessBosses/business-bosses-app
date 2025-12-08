import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

enum WinnerType { boss, backer, mentor, partner, ambassador }

class WinnerCard extends StatelessWidget {
  final WinnerType type;
  final int winCount;
  final String? avatarUrl;
  final bool? isMatchCard;

  const WinnerCard({
    super.key,
    required this.type,
    required this.winCount,
    this.avatarUrl,
    this.isMatchCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final CardConfig config = _getConfig();

    return Container(
      width: isMatchCard! ? null : double.infinity,
      margin: EdgeInsets.symmetric(horizontal: isMatchCard! ? 0 : 15),
      height: isMatchCard! ? 25 : 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: config.gradientColors.first.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -10,
            top: -10,
            child: Icon(
              config.icon,
              size: 80,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isMatchCard! ? 5 : 16,
                vertical: isMatchCard! ? 5 : 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        config.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMatchCard! ? 8 : 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _buildBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isMatchCard! ? 5 : 10, vertical: isMatchCard! ? 0 : 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.emoji_events,
            size: isMatchCard! ? 12 : 16,
            color: Color(0xFFF59E0B),
          ),
          const SizedBox(width: 4),
          Text(
            '×$winCount',
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: isMatchCard! ? 10 : 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  CardConfig _getConfig() {
    switch (type) {
      case WinnerType.boss:
        return CardConfig(
          title: 'BOSS OF THE WEEK',
          icon: Icons.emoji_events,
          gradientColors: <Color>[backgroundColor, backgroundColor],
        );
      case WinnerType.backer:
        return CardConfig(
          title: 'BACKER OF THE WEEK',
          icon: Icons.trending_up,
          gradientColors: <Color>[
            Color(0xFFE0F2F1),
            Color(0xFFE0F2F1),
          ],
        );
      case WinnerType.mentor:
        return CardConfig(
          title: 'MENTOR OF THE WEEK',
          icon: Icons.school,
          gradientColors: <Color>[
            Color(0xFFE0F2FE),
            Color(0xFFE0F2FE),
          ],
        );
      case WinnerType.partner:
        return CardConfig(
          title: 'PARTNER OF THE WEEK',
          icon: Icons.handshake,
          gradientColors: <Color>[
            Color.fromARGB(255, 251, 249, 231),
            Color.fromARGB(255, 251, 249, 231),
          ],
        );
      case WinnerType.ambassador:
        return CardConfig(
          title: 'AMBASSADOR OF THE WEEK',
          icon: Icons.handshake,
          gradientColors: <Color>[
            Color(0xFFEDE9FE),
            Color(0xFFEDE9FE),
          ],
        );
    }
  }
}

class CardConfig {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;

  CardConfig({
    required this.title,
    required this.icon,
    required this.gradientColors,
  });
}
