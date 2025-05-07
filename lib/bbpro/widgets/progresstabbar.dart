import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class ProgressTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;

  const ProgressTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: prosemibackColor, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(
        children: tabs.asMap().entries.map((MapEntry<int, String> entry) {
          int idx = entry.key;
          String tab = entry.value;
          bool isActive = idx == currentIndex;
          bool isCompleted = idx < currentIndex;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color:
                        isActive || isCompleted ? proprimaryColor : backgroundColor,
borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    height: 4,
                    
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tab,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive || isCompleted ? Colors.black : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
