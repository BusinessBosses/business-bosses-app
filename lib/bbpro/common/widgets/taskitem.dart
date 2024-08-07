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
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('data'),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: backgroundColor),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text('Edit')),
                SizedBox(
                  width: 5,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF00000)),
                    child: SvgPicture.asset('assets/svgs/trashicon.svg'))
              ],
            )
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
