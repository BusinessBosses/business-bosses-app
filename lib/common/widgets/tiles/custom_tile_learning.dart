import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Custom Tile For Forums Categories GridView
class CustomTileLearning extends StatelessWidget {
  final Function() onTap;
  final String label;
  final bool hideIcon;
  final bool showBorder;

  const CustomTileLearning({
    Key? key,
    required this.onTap,
    required this.label,
    this.hideIcon = false,
    this.showBorder = false,
  }) : super(key: key);

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
                        title: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        trailing: hideIcon
                            ? null
                            : SvgPicture.asset('assets/svgs/nexticon.svg')),
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
