import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Custom Tile For Forums Categories GridView
class CustomTileLearning extends StatelessWidget {
  final Function() onTap;
  final String label;
  final bool hideIcon;
  final bool showBorder;
  final String? count;
  final String? url;

  const CustomTileLearning({
    super.key,
    required this.onTap,
    required this.label,
    this.hideIcon = false,
    this.showBorder = false,
    this.count,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Wrap(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: !showBorder
                    ? null
                    : Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 0.3,
                      ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: SizedBox(
                              width: 25,
                              height: 25,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: url ?? '',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '$count Courses' ?? '0',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                                Icon(
                                  LucideIcons.chevronRight,
                                  size: 15,
                                  color: primaryColorLT,
                                )
                              ]),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
