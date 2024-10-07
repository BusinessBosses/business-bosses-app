import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/addtoorderwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderpreviewcard.dart';
import 'package:business_bosses_v2/bbpro/widgets/ordersummarycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/progresstabbar.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicetypesection.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class BookServiceScreen extends StatefulWidget {
  final Service? service;
  const BookServiceScreen({super.key, this.service});

  @override
  State<BookServiceScreen> createState() => _BookServiceScreenState();
}

class _BookServiceScreenState extends State<BookServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: probackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          title: const Text(
            'Book Service',
            style: TextStyle(
              color: proprimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: ProgressTabBar(currentIndex: 0, tabs: <String>[
                '1. Customise Order',
                '2. Order Summary',
                '3. Complete Order'
              ]),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 250,
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: GenericSlider(
                                  images: widget.service?.images ??
                                      <String>['', '', ''],
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.service?.name ?? 'Service Name',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.green.withAlpha(50),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    child: const Text(
                                      'Active',
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    widget.service?.price.toString() ?? 'Price',
                                    style: const TextStyle(
                                      color: proprimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.service?.deliveryMethod ??
                                        'Delivery Method',
                                    style: const TextStyle(
                                      color: proprimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    widget.service?.location ?? 'Location',
                                    style: const TextStyle(
                                      color: proprimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Row(
                                children: <Widget>[
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: DetectableText(
                                  text: widget.service?.description ??
                                      'Description text',
                                  detectionRegExp:
                                      detectionRegExp(hashtag: false)!,
                                  detectedStyle: bodyText2.copyWith(
                                    color: Colors.blue,
                                  ),
                                  moreStyle: bodyText2.copyWith(
                                    color: proprimaryColor,
                                  ),
                                  lessStyle: bodyText2.copyWith(
                                    color: proprimaryColor,
                                  ),
                                  trimLength: 10,
                                  trimExpandedText: '  show less',
                                  basicStyle:
                                      bodyText2.copyWith(color: textColor),
                                  onTap: (_) {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(radius)),
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Select Date'),
                              SfCalendar(
                                view: CalendarView.month,
                                initialDisplayDate: DateTime.now(),
                                monthViewSettings: const MonthViewSettings(
                                  appointmentDisplayMode:
                                      MonthAppointmentDisplayMode.indicator,
                                ),
                                // dataSource: _getCalendarDataSource(),
                                // onTap: _handleCalendarTap,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ProCustomButton(
                            onPressed: () {},
                            text: 'Next ',
                            icon: SvgPicture.asset(
                              'assets/svgs/nexticon.svg',
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ]),
                  Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const OrderPreviewCard(
                            title: 'AI Robot with Intel Iris',
                            size: 'Medium 24',
                            color: 'Black',
                            price: 10000,
                            deliveryDays: 5,
                            deliveryLocation: 'In Person, London',
                            imageUrl: '',
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const ServicetypeSectionWidget(),
                          const SizedBox(
                            height: 15,
                          ),
                          const AddToOrderWidget(),
                          const SizedBox(
                            height: 15,
                          ),
                          const OrderSummaryWidget(),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ProCustomButton(
                              onPressed: () {},
                              text: 'Next ',
                              icon: SvgPicture.asset(
                                'assets/svgs/nexticon.svg',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
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
                              Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Edit your Details',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 13),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Full Name',
                                        filled: false,
                                        fillColor: Colors.grey.shade100,
                                      ),
                                    ),
                                    TextFormField(
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
                                      style: const TextStyle(fontSize: 13),
                                      maxLines: 1,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Phone Number',
                                        filled: false,
                                        fillColor: Colors.grey.shade100,
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomEditText(
                        maxLength: 300,
                        caption: 'Delivery Address',
                        hintText: 'Enter your delivery address',
                        controller: quantityController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ProCustomButton(
                          onPressed: () {},
                          text: 'Done ',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
