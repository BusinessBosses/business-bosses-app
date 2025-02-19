import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/ordersummarycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/paymentoptioncard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicetypesection.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

String formatServiceDuration(int? duration) {
  if (duration == null || duration == 2000000) return '';
  if (duration < 60) return '$duration mins @';
  if (duration < 1440) {
    int hours = duration ~/ 60;
    int minutes = duration % 60;
    String formattedDuration = '${hours}hr(s)';
    if (minutes > 0) {
      formattedDuration += ' ${minutes}mins';
    }
    return '$formattedDuration @ ';
  } else {
    int days = duration ~/ 1440;
    int remainingMinutes = duration % 1440;
    int hours = remainingMinutes ~/ 60;
    int minutes = remainingMinutes % 60;
    String formattedDuration = '${days}days';
    if (hours > 0) {
      formattedDuration += ' ${hours}hr(s)';
    }
    if (minutes > 0) {
      formattedDuration += ' ${minutes}mins';
    }
    return '$formattedDuration @ ';
  }
}

class BookServiceScreen extends StatefulWidget {
  final bool? isMarketplace;
  final Service service;
  final Shop shop;
  const BookServiceScreen(
      {super.key,
      required this.service,
      required this.shop,
      this.isMarketplace});

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
  final TextEditingController noteController = TextEditingController();
  bool isSubmit = false;

  List<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[];
  DateTime? deliveryDate = DateTime.now();
  String? clientId;
  String? selectedClient;
  double selectedpackagesprice = 0;

  List<String> clientsName = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];

  late FocusNode _focusNode;

  int? duration;

  DateTime? _startDate;
  final List<DateTime> _selectedDates = <DateTime>[];

  bool timeslotselected = false;
  String? selectedSlot;
  String serviceduration = '';
  List<dynamic>? paymentMethods;
  String paymentMethod = '';
  String activePaymentMethod = '';
  bool isAppointment = false;
  bool blocked = false;

  @override
  void initState() {
    super.initState();

    paymentMethods = widget.shop.payments;
    if (paymentMethods!.isNotEmpty) {
      activePaymentMethod = paymentMethods![0]['paymentMethod'] ?? '';
    }
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
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              onTap: () {
                                navigateTo(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const TextWidget(
                                      text: 'Do you want to block user?',
                                      centralize: true,
                                      fontWeight: FontWeight.w700,
                                      size: 20,
                                    ),
                                    content: TextWidget(
                                      text: blocked == true
                                          ? 'You will see posts and comments related to user on your feed'
                                          : 'You will no longer see undefined posts and comments on your feed',
                                      centralize: true,
                                      color: Colors.black.withOpacity(.6),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => navigateTo(context),
                                        child: const TextWidget(
                                          text: 'Cancel',
                                          fontWeight: FontWeight.w700,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          navigateTo(context);
                                          // print(_post.user.uid);

                                          // widget
                                          //     .onBlock(_post.user.uid);
                                          showSnackBar(context,
                                              message: blocked == true
                                                  ? 'User has been blocked'
                                                  : 'User has been unblocked');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 7,
                                            horizontal: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColorLT,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: TextWidget(
                                            text: blocked == true
                                                ? 'Unblock'
                                                : 'Block',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              title: widget.service.user!.isSubscribed
                                  ? Row(
                                      children: <Widget>[
                                        TextWidget(
                                          text: blocked == true
                                              ? 'Unblock @${widget.service.user!.name ?? widget.service.user!.username}'
                                              : 'Block @${widget.service.user!.name ?? widget.service.user!.username}',
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 5),
                                        SvgPicture.asset(
                                          'assets/svgs/premiumbadge.svg',
                                          height: 9,
                                          color: primaryColorLT,
                                        )
                                      ],
                                    )
                                  : TextWidget(
                                      text: blocked == true
                                          ? 'Unblock @${widget.service.user!.name ?? widget.service.user!.username}'
                                          : 'Block @${widget.service.user!.name ?? widget.service.user!.username}',
                                      color: Colors.blue,
                                    ),
                            ),
                            ListTile(
                              onTap: () {
                                navigateTo(context);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const TextWidget(
                                      text: 'Do you want to report user?',
                                      centralize: true,
                                      fontWeight: FontWeight.w700,
                                      size: 20,
                                    ),
                                    content: TextWidget(
                                      text:
                                          'The user will be reported to admin to evaluate if it violates any community policy',
                                      centralize: true,
                                      color: Colors.black.withOpacity(.6),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => navigateTo(context),
                                        child: const TextWidget(
                                          text: 'Cancel',
                                          fontWeight: FontWeight.w700,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          navigateTo(context);
                                          await _reportUser(
                                              context,
                                              'accountReport',
                                              widget.service.user!.uid,
                                              widget.service.user!.username);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 7,
                                            horizontal: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColorLT,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: const TextWidget(
                                            text: 'Report',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              },
                              contentPadding: EdgeInsets.zero,
                              title: const TextWidget(
                                text: 'Report this user',
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                      backgroundColor: backgroundColor,
                      child: SvgPicture.asset('assets/svgs/more.svg'))),
            )
          ],
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: GestureDetector(
            onTap: () {
              if (Get.previousRoute == Routes.publicProfile) {
                Get.back();
              } else {
                Get.to(
                  () => PublicProfileScreen(
                    currentIndex: 1,
                  ),
                  arguments: widget.service.user,
                );
              }
            },
            // Get.to(UserShopScreen(
            //   user: widget.service.user!,
            // ));

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
                      color: probackgroundColor,
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
                          color: proprimaryColor,
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
                              '${formatServiceDuration(widget.service.serviceDuration)}${widget.shop.currency}${((widget.service.price * (1 - widget.service.discount / 100)) * 100).round() / 100}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.shop.currency}${widget.service.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.red,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          '${formatServiceDuration(widget.service.serviceDuration)}${widget.shop.currency}${widget.service.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                  Text('Category: ${widget.service.category}'),
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
                ],
              ),
            ),

            // Calendar Section
            if (widget.service.isAppointment == true)
              if (widget.service.availability!['startDate'] != null)
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
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
                              todayTextStyle:
                                  const TextStyle(color: Colors.black),
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
                                    if (widget
                                        .service.availability!['dayOfWeek']
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
                            monthCellBuilder: (BuildContext context,
                                MonthCellDetails details) {
                              DateTime minDate = DateTime
                                  .now(); // Define your minimum date here
                              List<DateTime> blackoutDates =
                                  _getNonAvailableDates();

                              // Combine blackoutDates with days before the minDate
                              bool isBlackoutDate = blackoutDates.any(
                                      (DateTime date) =>
                                          date.year == details.date.year &&
                                          date.month == details.date.month &&
                                          date.day == details.date.day) ||
                                  details.date.isBefore(minDate);

                              // Define the text style based on the date condition
                              TextStyle textStyle;
                              if (isBlackoutDate) {
                                textStyle = TextStyle(
                                  color: Colors.grey.withOpacity(0.2),
                                  decoration: TextDecoration.lineThrough,
                                  fontStyle: FontStyle.italic,
                                );
                              } else {
                                textStyle = const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold);
                              }

                              // Return the styled container
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  details.date.day.toString(),
                                  style: textStyle,
                                ),
                              );
                            },
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
                            todayTextStyle:
                                const TextStyle(color: Colors.black),
                            todayHighlightColor: Colors.transparent,
                            cellBorderColor: Colors.transparent,
                            blackoutDates: _getNonAvailableDates(),
                            blackoutDatesTextStyle: TextStyle(
                              color: Colors.black12.withOpacity(0.08),
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
                                      .contains(_getWeekdayName(
                                          selectedDate.weekday))) {
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
                              monthCellBuilder: (BuildContext context,
                                  MonthCellDetails details) {
                                DateTime minDate = DateTime
                                    .now(); // Define your minimum date here
                                List<DateTime> blackoutDates =
                                    _getAllDatesExceptStart();

                                // Combine blackoutDates with days before the minDate
                                bool isBlackoutDate = blackoutDates.any(
                                        (DateTime date) =>
                                            date.year == details.date.year &&
                                            date.month == details.date.month &&
                                            date.day == details.date.day) ||
                                    details.date.isBefore(minDate);

                                // Define the text style based on the date condition
                                TextStyle textStyle;
                                if (isBlackoutDate) {
                                  textStyle = TextStyle(
                                    color: Colors.grey.withOpacity(0.2),
                                    decoration: TextDecoration.lineThrough,
                                    fontStyle: FontStyle.italic,
                                  );
                                } else {
                                  textStyle = const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold);
                                }

                                // Return the styled container
                                return Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    details.date.day.toString(),
                                    style: textStyle,
                                  ),
                                );
                              },
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
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.green.withOpacity(0.2),
                              ),
                              todayTextStyle:
                                  const TextStyle(color: Colors.black),
                              todayHighlightColor: Colors.transparent,
                              cellBorderColor: Colors.transparent,
                              blackoutDates: _getAllDatesExceptStart(),
                              blackoutDatesTextStyle: TextStyle(
                                color: Colors.black12.withOpacity(0.08),
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

                                    DateTime startDate = DateTime.parse(widget
                                        .service.availability!['startDate']);

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
                      if (_startDate != null)
                        const Text(
                          'Time slots',
                          style: TextStyle(fontSize: 13),
                        ),
                      if (_startDate != null)
                        Wrap(
                          spacing: 8.0,
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
                                });
                              },
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 10),
                    ],
                  ),
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
                                  activeColor: Colors.black,
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
            if (widget.service.packages.isNotEmpty) const SizedBox(height: 15),

            if (widget.service.deliveryMethod != null &&
                widget.service.deliveryMethod != '')
              ServicetypeSectionWidget(
                isOnline:
                    widget.service.deliveryMethod == 'Online' ? true : false,
                service: widget.service,
              ),

            if (widget.service.deliveryMethod != null &&
                widget.service.deliveryMethod != '')
              const SizedBox(height: 15),

            OrderSummaryWidget(
              serviceDuration: widget.service.serviceDuration,
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
              timeofservice: _startDate != null && selectedSlot != null
                  ? '${DateFormat('d MMMM yyyy').format(_startDate!)} ${selectedSlot!}'
                  : null,
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Select a Payment Option',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    widget.shop.payments.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: paymentMethods!
                                  .map((dynamic payment) =>
                                      ProPaymentOptionCard(
                                        option: payment['paymentMethod'] ?? '',
                                        subtext:
                                            'Details: ${payment['details'].toString()}',
                                        activeoption: activePaymentMethod,
                                        onTap: (String newOption) {
                                          setState(() {
                                            if (activePaymentMethod !=
                                                newOption) {
                                              activePaymentMethod = newOption;
                                            } else {
                                              activePaymentMethod = '';
                                            }
                                          });
                                        },
                                      ))
                                  .toList(),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Center(
                              child: Text(
                                'User has not added a payment method yet',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            if (widget.service.notes != null)
              Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                      child: Text(
                        'Seller\'s Note',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: textColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        widget.service.notes!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    CustomEditText(
                      padding: 0,
                      hintText: 'Enter Note to Seller here',
                      controller: noteController,
                      caption: '',
                    ),
                  ],
                ),
              ),
            if (widget.service.notes != null)
              const SizedBox(
                height: 16,
              ),

            // Customer Details Section
            const SizedBox(
              height: 25,
            ),
            // Submit Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ProCustomButton(
                  color: Colors.black,
                  loading: isSubmit,
                  onPressed: () async {
                    if (widget.service.availability!['startDate'] == null) {
                      _startDate = DateTime.now();
                    }
                    if (_startDate == null) {
                      showSnackbar(
                        message: 'Please select a date!',
                        error: true,
                      );
                      return;
                    }
                    if (widget.service.availability!['startDate'] != null &&
                        selectedSlot == null) {
                      showSnackbar(
                        message: 'Please select a time slot!',
                        error: true,
                      );
                      return;
                    }
                    if (activePaymentMethod.isEmpty) {
                      showSnackbar(
                        message: 'Please select a payment method',
                        error: true,
                      );
                      return;
                    }

                    setState(() {
                      isSubmit = true;
                    });

                    selectedSlot ??= '9:00 AM - 5:00 PM';

                    List<String> times = selectedSlot.toString().split(' - ');
                    String startTimeString = times[0];
                    String endTimeString = times[1];

                    DateFormat timeFormat = DateFormat('hh:mm a');
                    DateTime parsedStartTime =
                        timeFormat.parse(startTimeString);
                    DateTime parsedEndTime = timeFormat.parse(endTimeString);

                    String startFormattedTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime(
                            0000,
                            00,
                            00,
                            parsedStartTime.hour,
                            parsedStartTime.minute,
                            parsedStartTime.second));
                    String endFormattedTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime(
                            0000,
                            00,
                            00,
                            parsedEndTime.hour,
                            parsedEndTime.minute,
                            parsedEndTime.second));

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
                      'paymentMethod': activePaymentMethod,
                      'orderDetails': '',
                      'invoiceOption': 'send_with_payment_link',
                      'status': 'pending',
                      'notes': noteController.text,
                    };
                    print(orderData);
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

            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, bottom: 200, right: 20, top: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Colors.grey.shade200,
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Safety tips \n\n• Check seller offers buyer protection before making payment \n• On delivery, check that the item delivered is what you ordered \n• Report any seller you have any concerns about',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reportUser(BuildContext context, String reportType,
      String userId, String username) async {}

  List<String> _generateTimeSlots() {
    // Default time values if data is invalid or null
    TimeOfDay defaultStartTime = const TimeOfDay(hour: 9, minute: 0); // 9:00 AM
    TimeOfDay defaultEndTime = const TimeOfDay(hour: 17, minute: 0); // 5:00 PM

    // Return default formatted times if duration or availability data is null
    if (duration == null || widget.service.availability == null) {
      return <String>[
        '${defaultStartTime.format(context)} - ${defaultEndTime.format(context)}'
      ];
    }

    List<String> slots = <String>[];

    // Parse the start time and end time
    String? rawStartTime = widget.service.availability!['startTime'];
    String? rawEndTime = widget.service.availability!['endTime'];

    List<String> startTimeParts = rawStartTime?.split(':') ?? <String>[];
    List<String> endTimeParts = rawEndTime?.split(':') ?? <String>[];

    // Validate and fallback to default times
    int startHour =
        int.tryParse(startTimeParts.isNotEmpty ? startTimeParts[0] : '') ??
            defaultStartTime.hour;
    int startMinute =
        int.tryParse(startTimeParts.length > 1 ? startTimeParts[1] : '') ??
            defaultStartTime.minute;

    int endHour =
        int.tryParse(endTimeParts.isNotEmpty ? endTimeParts[0] : '') ??
            defaultEndTime.hour;
    int endMinute =
        int.tryParse(endTimeParts.length > 1 ? endTimeParts[1] : '') ??
            defaultEndTime.minute;

    // Parse the start and end dates
    String? rawStartDate = widget.service.availability!['startDate'];
    String? rawEndDate = widget.service.availability!['endDate'];

    if (rawStartDate == null || rawEndDate == null) {
      return <String>[
        '${TimeOfDay(hour: startHour, minute: startMinute).format(context)} - ${TimeOfDay(hour: endHour, minute: endMinute).format(context)}'
      ]; // Missing date information
    }

    DateTime startDate;
    DateTime endDate;

    try {
      startDate = DateTime.parse(rawStartDate);
      endDate = DateTime.parse(rawEndDate);
    } catch (e) {
      return <String>[
        '${TimeOfDay(hour: startHour, minute: startMinute).format(context)} - ${TimeOfDay(hour: endHour, minute: endMinute).format(context)}'
      ]; // Invalid date format
    }

    // Construct DateTime objects for the start and end of the time slots
    DateTime startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startHour,
      startMinute,
    );

    DateTime endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endHour,
      endMinute,
    );

    // Generate slots
    while (startDateTime.isBefore(endDateTime)) {
      DateTime slotEndTime = startDateTime.add(Duration(minutes: duration!));
      if (slotEndTime.isAfter(endDateTime)) break;

      slots.add(
          '${TimeOfDay.fromDateTime(startDateTime).format(context)} - ${TimeOfDay.fromDateTime(slotEndTime).format(context)}');

      startDateTime = slotEndTime;
    }

    // Return startTime to endTime if no slots could be generated
    return slots.isEmpty
        ? <String>[
            '${TimeOfDay(hour: startHour, minute: startMinute).format(context)} - ${TimeOfDay(hour: endHour, minute: endMinute).format(context)}'
          ]
        : slots;
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
