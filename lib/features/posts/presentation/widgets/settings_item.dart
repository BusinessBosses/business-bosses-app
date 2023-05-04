import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../../utils/theme/theme.dart';

class SettingsItem extends StatefulWidget {
  final bool isTitle;
  final String label;
  final bool hasSwitch;
  bool switchValue;
  final Function onTap;

  SettingsItem({
    Key? key,
    this.isTitle = true,
    this.label = '',
    this.hasSwitch = true,
    this.switchValue = true,
    required this.onTap,
  }) : super(key: key);

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isTitle
            ? Text(
                widget.label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
              )
            : InkWell(
                onTap: () => widget.onTap(widget.label),
                borderRadius: BorderRadius.circular(radiusValue),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(radiusValue),
                  ),
                  child: ListTile(
                    title: Text(widget.label,
                        style: Theme.of(context).textTheme.bodyLarge),
                    trailing: widget.hasSwitch
                        ? Container(
                            width: 60.0,
                            alignment: Alignment.centerRight,
                            child: FlutterSwitch(
                                toggleSize: 18,
                                height: 24.0,
                                width: 48.0,
                                padding: 3,
                                activeColor: Theme.of(context).primaryColor,
                                inactiveColor: iconColor.withOpacity(0.4),
                                value: widget.switchValue,
                                onToggle: (_) {
                                  setState(() {
                                    widget.switchValue = !widget.switchValue;
                                  });
                                }),
                          )
                        : Icon(
                            Icons.keyboard_arrow_right,
                            color: textColor.withOpacity(0.8),
                          ),
                  ),
                ),
              ),
        const SizedBox(height: 12.0),
      ],
    );
  }
}
