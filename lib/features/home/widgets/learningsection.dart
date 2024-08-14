import 'package:business_bosses_v2/features/live_event/widgets/event_call.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LearningSection extends StatelessWidget {
  const LearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Learnings',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Blogs on Learning',
                  style: TextStyle(fontSize: 15),
                ),
                Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      const Text(
                        'View all',
                        style: TextStyle(fontSize: 11),
                      ),
                      const SizedBox(width: 5.0),
                      SvgPicture.asset(
                        'assets/svgs/nexticon.svg',
                        // ignore: deprecated_member_use
                        color: textColor,
                        height: 8,
                      ),
                    ]),
              ],
            ),
          ),
          Container(
            height: 400,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    width: 400,
                    child: EventCall(
                      full: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
