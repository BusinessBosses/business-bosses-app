import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Taskitem extends StatefulWidget {
  const Taskitem({super.key});

  @override
  State<Taskitem> createState() => _TaskitemState();
}

class _TaskitemState extends State<Taskitem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('data'),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: backgroundColor),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: const Text('Edit')),
                const SizedBox(
                  width: 5,
                ),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0x0ff00000)),
                    child: SvgPicture.asset('assets/svgs/trashicon.svg'))
              ],
            )
          ],
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
