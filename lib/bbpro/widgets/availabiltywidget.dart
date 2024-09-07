import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AvailabilityWidget extends StatefulWidget {
  const AvailabilityWidget({Key? key}) : super(key: key);

  @override
  _AvailabilityWidgetState createState() => _AvailabilityWidgetState();
}

class _AvailabilityWidgetState extends State<AvailabilityWidget> {
  final List<DateTime> _selectedDates = <DateTime>[];
  bool _isAlwaysAvailable = false;
  final List<bool> _selectedWeekdays = List.filled(7, false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(radius)),
        padding: const EdgeInsets.all(15),
        height: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Available Days'),
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
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: List.generate(7, (int index) {
                return ChoiceChip(
                  label: Text(_getWeekdayName(index)),
                  selected: _selectedWeekdays[index],
                  selectedColor: proprimaryColor,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedWeekdays[index] = selected;
                      _updateSelectedDates();
                    });
                  },
                );
              }),
            ),
            Expanded(
              child: _isAlwaysAvailable
                  ? const Center(child: Text('Always Available'))
                  : SfCalendar(
                      view: CalendarView.month,
                      initialDisplayDate: DateTime.now(),
                      monthViewSettings: const MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.indicator,
                      ),
                      dataSource: _getCalendarDataSource(),
                      onTap: _handleCalendarTap,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(int index) {
    List<String> weekdays = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    return weekdays[index];
  }

  void _updateSelectedDates() {
    _selectedDates.clear();
    DateTime now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      DateTime date = now.add(Duration(days: i));
      if (_selectedWeekdays[date.weekday - 1]) {
        _selectedDates.add(date);
      }
    }
  }

  CalendarDataSource _getCalendarDataSource() {
    List<Appointment> appointments = _selectedDates
        .map((DateTime date) => Appointment(
              startTime: date,
              endTime: date,
              subject: 'Available',
              color: proprimaryColor,
              isAllDay: true,
            ))
        .toList();

    return _AppointmentDataSource(appointments);
  }

  void _handleCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.calendarCell) {
      setState(() {
        DateTime selectedDate = DateTime(
            details.date!.year, details.date!.month, details.date!.day);
        if (_selectedDates.contains(selectedDate)) {
          _selectedDates.remove(selectedDate);
        } else {
          _selectedDates.add(selectedDate);
        }
      });
    }
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
