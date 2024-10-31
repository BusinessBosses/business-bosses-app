import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class SwitchWidget extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final String caption;
  final String subtext;

  const SwitchWidget({
    Key? key,
    required this.value,
    required this.onChanged,
    this.activeColor = proprimaryColor,
    this.inactiveColor = Colors.grey,
    this.caption = '',
    this.subtext = '',
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.caption,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (widget.subtext.isNotEmpty)
                Expanded(
                  child: Text(
                    widget.subtext,
                    style: const TextStyle(
                      fontSize: 14,
                      color: subtextColor,
                    ),
                  ),
                ),
              GestureDetector(
                onTap: () {
                  widget.value
                      ? _animationController.reverse()
                      : _animationController.forward();
                  widget.onChanged(!widget.value);
                },
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: widget.value
                            ? widget.activeColor
                            : widget.inactiveColor,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: widget.value ? 20 : 0,
                            right: widget.value ? 0 : 20,
                            top: 2,
                            bottom: 2,
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Center(
                                child: widget.value
                                    ? Icon(
                                        Icons.check,
                                        size: 12,
                                        color: widget.activeColor,
                                      )
                                    : Icon(
                                        Icons.close,
                                        size: 12,
                                        color: widget.inactiveColor,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
