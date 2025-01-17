import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/user_shop_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderpaymentcard.dart';
import 'package:business_bosses_v2/bbpro/widgets/ordersummarycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicetypesection.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookServiceScreen extends StatefulWidget {
  final Service service;
  final Shop shop;
  const BookServiceScreen(
      {super.key, required this.service, required this.shop});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen> {
  final ProfileController profileController = Get.find();
  final OrderController orderController = Get.put(OrderController());
  final ShopController shopController = Get.find();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController deliveryController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isSubmit = false;

  List<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[];
  DateTime? deliveryDate = DateTime.now();
  String? clientId;
  String? selectedClient;
  double selectedpackagesprice = 0;

  List<String> clientsName = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];

  late FocusNode _focusNode;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  int? duration;

  DateTime? _startDate;
  DateTime? _endDate;
  final List<DateTime> _selectedDates = <DateTime>[];

  bool timeslotselected = false;
  String? selectedSlot;

  @override
  void initState() {
    super.initState();
    fullNameController.text = profileController.myProfile.name ?? '';
    emailController.text = profileController.myProfile.email;
    _focusNode = FocusNode();
    quantityController.text = '1';
    duration = widget.service.serviceDuration ?? 60;
    selectedItems.add(
      <String, dynamic>{
        'type': 'service',
        'id': widget.service.id,
        'name': widget.service.name
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: GestureDetector(
            onTap: () {
              Get.to(UserShopScreen(
                user: widget.service.user!,
              ));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.service.shop!.name,
                  style: const TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(radius)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Visit Biz-Center',
                        style: TextStyle(
                          fontSize: 10,
                          color: textColor,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: textColor,
                        size: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          children: <Widget>[
            // Service Image Section
            if (widget.service.images != null &&
                widget.service.images!.isNotEmpty)
              SizedBox(
                height: 250,
                child: GenericSlider(
                  radius: 0,
                  images: widget.service.images ?? <String>[],
                ),
              ),

            // Service Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 15),
                  Text(
                    widget.service.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (widget.service.discount > 0)
                        Row(
                          children: <Widget>[
                            Text(
                              '${widget.shop.currency}${((widget.service.price * (1 - widget.service.discount / 100)) * 100).round() / 100}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.shop.currency}${widget.service.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '${widget.shop.currency}${widget.service.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  DetectableText(
                    text: widget.service.description,
                    detectionRegExp: detectionRegExp(hashtag: false)!,
                    detectedStyle: bodyText2.copyWith(color: Colors.blue),
                    moreStyle: bodyText2.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    lessStyle: bodyText2.copyWith(
                        color: Colors.black, fontWeight: FontWeight.bold),
                    trimLength: 100,
                    trimExpandedText: '  show less',
                    basicStyle: bodyText2.copyWith(color: textColor),
                    onTap: (_) {},
                  ),
                  const SizedBox(height: 15),
                  if (widget.service.notes != null)
                    const Text(
                      'Seller\'s Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  if (widget.service.notes != null)
                    DetectableText(
                      text: widget.service.notes ?? 'No note added!',
                      detectionRegExp: detectionRegExp(hashtag: false)!,
                      detectedStyle: bodyText2.copyWith(color: Colors.blue),
                      moreStyle: bodyText2.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      lessStyle: bodyText2.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      trimLength: 100,
                      trimExpandedText: '  show less',
                      basicStyle: bodyText2.copyWith(color: textColor),
                      onTap: (_) {},
                    ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Calendar Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(radius),
              ),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Select a Date and Time',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (widget.service.deliveryTime == 'true')
                    Column(children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/checkfilled.svg',
                            height: 13,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'This service is always available',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: SfCalendar(
                          initialSelectedDate: _startDate ??
                              (_selectedDates.isNotEmpty
                                  ? _selectedDates[0]
                                  : DateTime.now()),
                          selectionDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          todayTextStyle: const TextStyle(color: Colors.black),
                          todayHighlightColor: Colors.transparent,
                          view: CalendarView.month,
                          initialDisplayDate: _startDate ??
                              (_selectedDates.isNotEmpty
                                  ? _selectedDates[0]
                                  : DateTime.now()),
                          minDate: DateTime.now(),
                          monthViewSettings: const MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator,
                            showAgenda:
                                false, // Enable agenda view to select dates
                          ),
                          onTap: (CalendarTapDetails details) {
                            if (widget.service.deliveryTime == 'false' &&
                                details.targetElement ==
                                    CalendarElement.calendarCell) {
                              setState(() {
                                DateTime selectedDate = DateTime(
                                    details.date!.year,
                                    details.date!.month,
                                    details.date!.day);

                                // Check if the selected date is in the allowed days
                                if (widget.service.availability!['dayOfWeek']
                                    .contains(_getWeekdayName(
                                        selectedDate.weekday))) {
                                  // Clear previously selected dates and weekdays
                                  _selectedDates.clear();

                                  // Add the newly selected date and update weekdays
                                  _selectedDates.add(selectedDate);

                                  // Set _startDate to the selected date
                                  _startDate = selectedDate;
                                } else {
                                  showSnackbar(
                                    message: 'Please select a valid day.',
                                    error: true,
                                  );
                                }
                              });
                            }
                          },
                        ),
                      ),
                    ]),
                  if (widget.service.repeat == 'Yes (Regular Service)')
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: SfCalendar(
                        view: CalendarView.month,
                        initialSelectedDate: _startDate ??
                            (_selectedDates.isNotEmpty
                                ? _selectedDates[0]
                                : DateTime.now()),
                        initialDisplayDate: _startDate ??
                            (_selectedDates.isNotEmpty
                                ? _selectedDates[0]
                                : DateTime.now()),
                        minDate: DateTime.now(),
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.indicator,
                          showAgenda: false,
                        ),
                        selectionDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        todayTextStyle: const TextStyle(color: Colors.black),
                        todayHighlightColor: Colors.transparent,
                        cellBorderColor: Colors.transparent,
                        blackoutDates: _getNonAvailableDates(),
                        blackoutDatesTextStyle: const TextStyle(
                          color: Colors.black12,
                          decoration: TextDecoration.lineThrough,
                        ),
                        onTap: (CalendarTapDetails details) {
                          if (details.targetElement ==
                              CalendarElement.calendarCell) {
                            setState(() {
                              DateTime selectedDate = DateTime(
                                  details.date!.year,
                                  details.date!.month,
                                  details.date!.day);

                              if (widget.service.availability!['dayOfWeek']
                                  .contains(
                                      _getWeekdayName(selectedDate.weekday))) {
                                _selectedDates.clear();
                                _selectedDates.add(selectedDate);
                                _startDate = selectedDate;
                              } else {
                                showSnackbar(
                                  message: 'Please select a valid day.',
                                  error: true,
                                );
                              }
                            });
                          }
                        },
                      ),
                    ),
                  if (widget.service.repeat == 'No (One-time Service)')
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        child: SfCalendar(
                          view: CalendarView.month,
                          initialSelectedDate: _startDate ??
                              (_selectedDates.isNotEmpty
                                  ? _selectedDates[0]
                                  : DateTime.now()),
                          initialDisplayDate: _startDate ??
                              (_selectedDates.isNotEmpty
                                  ? _selectedDates[0]
                                  : DateTime.now()),
                          minDate: DateTime.now(),
                          monthViewSettings: const MonthViewSettings(
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.indicator,
                            showAgenda: false,
                          ),
                          selectionDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          todayTextStyle: const TextStyle(color: Colors.black),
                          todayHighlightColor: Colors.transparent,
                          cellBorderColor: Colors.transparent,
                          blackoutDates: _getAllDatesExceptStart(),
                          blackoutDatesTextStyle: const TextStyle(
                            color: Colors.black12,
                            decoration: TextDecoration.lineThrough,
                          ),
                          onTap: (CalendarTapDetails details) {
                            if (details.targetElement ==
                                CalendarElement.calendarCell) {
                              setState(() {
                                DateTime selectedDate = DateTime(
                                    details.date!.year,
                                    details.date!.month,
                                    details.date!.day);

                                DateTime startDate = DateTime.parse(
                                    widget.service.availability!['startDate']);

                                if (selectedDate.year == startDate.year &&
                                    selectedDate.month == startDate.month &&
                                    selectedDate.day == startDate.day) {
                                  _selectedDates.clear();
                                  _selectedDates.add(selectedDate);
                                  _startDate = selectedDate;
                                } else {
                                  showSnackbar(
                                    message:
                                        'Please select the specific start date.',
                                    error: true,
                                  );
                                }
                              });
                            }
                          },
                        )),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0, // Horizontal spacing between chips
                    children: _generateTimeSlots().map((String slot) {
                      return ChoiceChip(
                        label: Text(
                          slot,
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedSlot == slot
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        selected: selectedSlot == slot,
                        selectedColor: Colors.black,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedSlot = selected ? slot : null;
                            print(selectedSlot);
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Order Preview Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                padding: const EdgeInsets.only(
                    left: 15.0, top: 15, right: 15, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Edit your Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextFormField(
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      controller: fullNameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Full Name',
                        filled: false,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                        filled: false,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    TextFormField(
                      controller: phoneController,
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone Number',
                        filled: false,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    TextFormField(
                      controller: deliveryController,
                      style: const TextStyle(fontSize: 13),
                      maxLength: 300,
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Delivery address',
                        filled: false,
                        fillColor: Colors.grey.shade100,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (widget.shop.payments.isNotEmpty)
              OrderPaymentMethodsWidget(
                paymentMethods: widget.shop.payments,
              ),
            if (widget.shop.payments.isNotEmpty)
              const SizedBox(
                height: 15,
              ),
            if (widget.service.packages.isNotEmpty)
              const SizedBox(
                height: 15,
              ),

            if (widget.service.packages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Additional Packages',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: widget.service.packages
                            .map((dynamic package) => CheckboxListTile(
                                  title: Text(package['name']),
                                  subtitle: Text(
                                      '${widget.shop.currency}${package['price']}'),
                                  value: selectedItems.any(
                                      (Map<String, dynamic> item) =>
                                          item['id'] == package['id']),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        selectedItems.add(package);
                                        selectedpackagesprice +=
                                            (package['price'] as num)
                                                .toDouble();
                                      } else {
                                        selectedItems.removeWhere(
                                            (Map<String, dynamic> item) =>
                                                item['id'] == package['id']);
                                        selectedpackagesprice -=
                                            (package['price'] as num)
                                                .toDouble();
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 15),

            const ServicetypeSectionWidget(),

            const SizedBox(height: 15),

            // Order Summary Section
            OrderSummaryWidget(
              quantity: int.parse(quantityController.text),
              price: widget.service.price,
              discount: widget.service.discount,
              total:
                  (int.parse(quantityController.text) * widget.service.price) *
                          (1 - (widget.service.discount / 100)) +
                      selectedpackagesprice,
              currency: widget.shop.currency,
              isservice: true,
              packagesprice: selectedpackagesprice,
            ),

            // Customer Details Section

            const SizedBox(height: 25),

            // Submit Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ProCustomButton(
                  color: Colors.black,
                  loading: isSubmit,
                  onPressed: () async {
                    if (_startDate == null) {
                      showSnackbar(
                        message: 'Please select a date!',
                        error: true,
                      );
                      return;
                    }
                    if (selectedSlot == null) {
                      showSnackbar(
                        message: 'Please select your  time!',
                        error: true,
                      );
                      return;
                    }

                    setState(() {
                      isSubmit = true;
                    });

                    List<String> times = selectedSlot.toString().split(' - ');
                    String startTimeString = times[0];
                    String endTimeString = times[1];

                    DateFormat timeFormat = DateFormat('hh:mm a');

                    DateTime parsedStartTime =
                        timeFormat.parse(startTimeString);
                    DateTime parsedEndTime = timeFormat.parse(endTimeString);

                    String startFormattedTime =
                        DateFormat('HH:mm:ss').format(parsedStartTime);
                    String endFormattedTime =
                        DateFormat('HH:mm:ss').format(parsedEndTime);

                    final Map<String, dynamic> orderData = <String, dynamic>{
                      'userId': profileController.myProfile.uid,
                      'shopId': widget.shop.id,
                      'items': selectedItems,
                      'deliveryMethod': widget.service.deliveryMethod != null &&
                              widget.service.deliveryMethod!.isNotEmpty
                          ? widget.service.deliveryMethod!.toLowerCase()
                          : 'online',
                      'deliveryDate': '$_startDate',
                      'startTime': startFormattedTime,
                      'endTime': endFormattedTime,
                      'paymentMethod': widget.service.paymentMethod != null &&
                              widget.service.paymentMethod!.isNotEmpty
                          ? widget.service.paymentMethod!
                          : 'cash',
                      'orderDetails':
                          'Name: ${fullNameController.text} \n Email: ${emailController.text} \n Phone: ${phoneController.text} \n Delivery Details: ${deliveryController.text}',
                      'invoiceOption': 'send_with_payment_link',
                      'status': 'pending'
                    };

                    bool response = await orderController.addOrder(orderData);
                    if (response) {
                      setState(() {
                        isSubmit = false;
                      });
                      Get.defaultDialog(
                        title: '',
                        barrierDismissible: false,
                        content: Column(
                          children: <Widget>[
                            const Text(
                              'Service booked successfully',
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            LottieBuilder.asset(
                              'assets/anim/done.json',
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ProCustomButton(
                                  text: 'Done',
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Get.back();
                                  }),
                            ),
                          ],
                        ),
                      );
                    } else {
                      showSnackbar(
                        message: 'Error creating order!',
                        error: true,
                      );
                      setState(() {
                        isSubmit = false;
                      });
                    }
                  },
                  text: 'Book Service',
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  List<String> _generateTimeSlots() {
    List<String> slots = <String>[];
    if (duration != null && widget.service.availability != null) {
      // Parse the start time and end time
      List<String> startTimeParts =
          widget.service.availability!['startTime'].split(':');
      List<String> endTimeParts =
          widget.service.availability!['endTime'].split(':');

      // Parse the start date (assumes startDate and endDate are the same day for this example)
      DateTime startDate =
          DateTime.parse(widget.service.availability!['startDate']);
      DateTime endDate =
          DateTime.parse(widget.service.availability!['endDate']);

      // Construct DateTime objects for the start and end of the time slots
      DateTime startDateTime = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
        int.parse(startTimeParts[0]), // Hour
        int.parse(startTimeParts[1]), // Minute
      );

      DateTime endDateTime = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        int.parse(endTimeParts[0]), // Hour
        int.parse(endTimeParts[1]), // Minute
      );

      // Generate slots
      while (startDateTime.isBefore(endDateTime)) {
        DateTime slotEndTime = startDateTime.add(Duration(minutes: duration!));
        if (slotEndTime.isAfter(endDateTime)) break;

        slots.add(
            '${TimeOfDay.fromDateTime(startDateTime).format(context)} - ${TimeOfDay.fromDateTime(slotEndTime).format(context)}');

        startDateTime = slotEndTime;
      }
    }
    return slots;
  }

  String getDeliveryMethod(String method) {
    if (method == 'Online') {
      return 'online';
    } else if (method == 'Courier') {
      return 'in_person';
    } else {
      return 'pickup';
    }
  }

  String _formatTime(String? time) {
    if (time == null) return '';

    // Split the time into hours and minutes
    List<String> timeParts = time.split(':');
    if (timeParts.length < 2) return time;

    int hour = int.parse(timeParts[0]);
    String minute = timeParts[1];
    String period = 'AM';

    // Convert to 12-hour format
    if (hour >= 12) {
      period = 'PM';
      if (hour > 12) {
        hour -= 12;
      }
    }

    // Handle midnight (0:00)
    if (hour == 0) {
      hour = 12;
    }

    // Format as 12-hour time with AM/PM
    return '$hour:$minute $period';
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  List<DateTime> _getNonAvailableDates() {
    final List<DateTime> nonAvailableDates = <DateTime>[];
    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year + 1);

    for (DateTime date = now;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      if (!widget.service.availability!['dayOfWeek']
          .contains(_getWeekdayName(date.weekday))) {
        nonAvailableDates.add(date);
      }
    }

    return nonAvailableDates;
  }

  List<DateTime> _getAllDatesExceptStart() {
    final List<DateTime> blockedDates = <DateTime>[];
    final DateTime now = DateTime.now();
    final DateTime endDate = DateTime(now.year + 1);
    final DateTime startDate =
        DateTime.parse(widget.service.availability!['startDate']);

    for (DateTime date = now;
        date.isBefore(endDate);
        date = date.add(const Duration(days: 1))) {
      if (date.year != startDate.year ||
          date.month != startDate.month ||
          date.day != startDate.day) {
        blockedDates.add(date);
      }
    }

    return blockedDates;
  }
}
