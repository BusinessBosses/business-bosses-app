import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
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

  List<String> clientsName = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    fullNameController.text = profileController.myProfile.name!;
    emailController.text = profileController.myProfile.email;
    _focusNode = FocusNode();
    quantityController.text = '1';
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
                      Wrap(
                        children: <Widget>[
                          Text(
                            widget.shop.currency,
                            style: const TextStyle(
                              color: proprimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.service.price.toString(),
                            style: const TextStyle(
                              color: proprimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      if (widget.service.deliveryMethod != null)
                        Text(
                          widget.service.deliveryMethod!,
                          style: const TextStyle(
                            color: proprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  DetectableText(
                    text: widget.service.description,
                    detectionRegExp: detectionRegExp(hashtag: false)!,
                    detectedStyle: bodyText2.copyWith(color: Colors.blue),
                    moreStyle: bodyText2.copyWith(color: proprimaryColor),
                    lessStyle: bodyText2.copyWith(color: proprimaryColor),
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
                  const Text('Select Delivery Date'),
                  SfCalendar(
                    view: CalendarView.month,
                    initialDisplayDate: DateTime.now(),
                    monthViewSettings: const MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.indicator,
                    ),
                    onTap: (CalendarTapDetails details) {
                      if (details.date != null) {
                        setState(() {
                          deliveryDate = details.date!;
                        });
                      }
                    },
                  ),
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
            OrderPaymentMethodsWidget(
              paymentMethods: widget.shop.payments,
            ),
            const SizedBox(
              height: 15,
            ),

            const ServicetypeSectionWidget(),
            const SizedBox(height: 15),

            // Order Summary Section
            OrderSummaryWidget(
              quantity: int.parse(quantityController.text),
              price: widget.service.price,
              discount: widget.service.discount,
              total: (1 - widget.service.discount) *
                  (int.parse(quantityController.text) * widget.service.price),
              currency: widget.shop.currency,
            ),

            // Customer Details Section

            const SizedBox(height: 25),

            // Submit Button
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ProCustomButton(
                  loading: isSubmit,
                  onPressed: () async {
                    if (deliveryDate == null) {
                      showSnackbar(
                        message: 'Delivery Date is required!',
                        error: true,
                      );
                      return;
                    }

                    setState(() {
                      isSubmit = true;
                    });

                    final Map<String, dynamic> orderData = <String, dynamic>{
                      'userId': profileController.myProfile.uid,
                      'shopId': widget.shop.id,
                      'items': selectedItems,
                      'deliveryMethod': widget.service.deliveryMethod != null &&
                              widget.service.deliveryMethod!.isNotEmpty
                          ? widget.service.deliveryMethod!.toLowerCase()
                          : 'online',
                      'deliveryDate': deliveryDate.toString(),
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
                      showSnackbar(message: 'Order Added Successfully!');
                      Navigator.pop(context);
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

  String getDeliveryMethod(String method) {
    if (method == 'Online') {
      return 'online';
    } else if (method == 'Courier') {
      return 'in_person';
    } else {
      return 'pickup';
    }
  }
}
