import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:business_bosses_v2/utils/theme/theme.dart';

class Taskitem extends StatefulWidget {
  final String taskname;
  final String? taskexpense;
  final String? startdate;
  final String? enddate;
  final VoidCallback? editOnTap;
  final VoidCallback? deleteOnTap;

  const Taskitem({
    super.key,
    required this.taskname,
    this.taskexpense,
    this.startdate,
    this.enddate,
    this.editOnTap,
    this.deleteOnTap,
  });

  @override
  State<Taskitem> createState() => _TaskitemState();
}

class _TaskitemState extends State<Taskitem> {
  String formatDate(DateTime date) {
    String day = DateFormat('d').format(date);
    String suffix;
    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    return DateFormat("d'$suffix' MMMM yyyy").format(date);
  }

  DateTime parseDate(String date) {
    return DateFormat("yyyy-MM-dd").parse(date);
  }

  @override
  Widget build(BuildContext context) {
    DateTime? startDateTime;
    DateTime? endDateTime;

    if (widget.startdate != null) {
      startDateTime = parseDate(widget.startdate!);
    }

    if (widget.enddate != null) {
      endDateTime = parseDate(widget.enddate!);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.taskname),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: widget.editOnTap,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: backgroundColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: widget.deleteOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0x0ff00000),
                    ),
                    child: SvgPicture.asset('assets/svgs/trashicon.svg'),
                  ),
                ),
              ],
            ),
          ],
        ),
        if (widget.taskexpense != null)
          Text('Expense: \$${widget.taskexpense}'),
        if (startDateTime != null)
          Text('Start Date: ${formatDate(startDateTime)}'),
        if (endDateTime != null) Text('End Date: ${formatDate(endDateTime)}'),
        const SizedBox(height: 10),
        Container(
          height: 0.5,
          color: Colors.black12,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
