import 'package:business_bosses_v2/features/aipromote/ai_promote_sheet.dart';
import 'package:flutter/material.dart';

class AIPromoteButton extends StatefulWidget {
  const AIPromoteButton({super.key});

  @override
  State<AIPromoteButton> createState() => _AIPromoteButtonState();
}

class _AIPromoteButtonState extends State<AIPromoteButton>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotationController);

    // Start continuous rotation with pause
    _startRotationLoop();
  }

  void _startRotationLoop() async {
    while (mounted) {
      await _rotationController.forward();
      await Future<dynamic>.delayed(Duration(seconds: 2));
      _rotationController.reset();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _showPromoteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) => AIPromoteSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: <Color>[Color(0xFF6366F1), Color(0xFF818CF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: _showPromoteSheet,
          child: Center(
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (BuildContext context, Widget? child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Icon(
                    Icons.auto_fix_high,
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
