import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
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
  final bool? isPackage;
  final bool? isOrder;

  const Taskitem({
    super.key,
    required this.taskname,
    this.taskexpense,
    this.startdate,
    this.enddate,
    this.editOnTap,
    this.deleteOnTap,
    this.isPackage,
    this.isOrder,
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
    return DateFormat('yyyy-MM-dd').parse(date);
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
            Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  if (widget.isOrder != null)
                    const SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ClipRRect(
                          child: NetworkImageWithPlaceHolder(
                            imageUrl: '',
                            placeHolder: Icons.image,
                            iconSize: 22.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  if (widget.isOrder != null) const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(widget.taskname),
                      if (widget.isOrder != null)
                        Text(widget.taskexpense.toString()),
                    ],
                  )
                ]),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                if (widget.isOrder == null)
                  GestureDetector(
                    onTap: widget.editOnTap,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: backgroundColor,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: const Text('Edit'),
                    ),
                  ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: widget.deleteOnTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
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
        if (widget.isOrder == null)
          Text(widget.isPackage == null
              ? 'Expense: ${widget.taskexpense}'
              : 'Price: ${widget.taskexpense}'),
        if (startDateTime != null)
          Text('Start Date: ${formatDate(startDateTime)}'),
        if (endDateTime != null) Text('End Date: ${formatDate(endDateTime)}'),
        const SizedBox(height: 10),
        // Container(
        //   height: 0.5,
        //   color: Colors.black12,
        // ),
      ],
    );
  }
}
