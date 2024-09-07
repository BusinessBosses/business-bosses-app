import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AvailabilityWidget extends StatefulWidget {
  const AvailabilityWidget({Key? key}) : super(key: key);

  @override
  _AvailabilityWidgetState createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  final List<Appointment> _appointments = <Appointment>[];
  bool _isAlwaysAvailable = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(radius)),
        padding: const EdgeInsets.all(15),
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Available Times'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text('I am always available to offer this service'),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAlwaysAvailable = !_isAlwaysAvailable;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: _isAlwaysAvailable ? proprimaryColor : Colors.grey,
                    ),
                    child: Center(
                      child: _isAlwaysAvailable
                          ? const Icon(
                              Icons.check,
                              size: 12,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _isAlwaysAvailable
                  ? const Center(child: Text('Always Available'))
                  : SfCalendar(
                      view: CalendarView.week,
                      dataSource: _getCalendarDataSource(),
                      onTap: _handleCalendarTap,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  CalendarDataSource _getCalendarDataSource() {
    return _AppointmentDataSource(_appointments);
  }

  void _handleCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell) {
      setState(() {
        _appointments.add(Appointment(
          startTime: details.date!,
          endTime: details.date!.add(const Duration(hours: 1)),
          subject: 'Available',
          color: proprimaryColor,
        ));
      });
    }
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
