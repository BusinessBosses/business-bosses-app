import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edittext.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderpaymentcard.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderpreviewcard.dart';
import 'package:business_bosses_v2/bbpro/widgets/ordersummarycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/progresstabbar.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class OrderProductScreen extends StatefulWidget {
  final Product product;
  const OrderProductScreen({super.key, required this.product});

  @override
  State<OrderProductScreen> createState() => _OrderProductScreenState();
}

class _OrderProductScreenState extends State<OrderProductScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  final OrderController orderController = Get.put(OrderController());
  final ClientsController clientsController = Get.find();
  final TextEditingController deliveryController = TextEditingController();
  int selectedIndex = 0;
  List<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[];

  List<String> clientsName = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];
  String? clientId;
  String? selectedClient;

  bool isSubmit = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _focusNode = FocusNode();
    quantityController.text = '1';
    fullNameController.text = profileController.myProfile.name!;
    emailController.text = profileController.myProfile.email;
    selectedItems.add(
      <String, dynamic>{
        'type': 'product',
        'id': widget.product.id,
        'name': widget.product.name
      },
    );
    for (Client client in clientsController.clients) {
      clientsName.add(client.name);
      clients.add(<String, dynamic>{'name': client.name, 'id': client.id});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
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
            'Place Order',
            style: TextStyle(
              color: proprimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: ProgressTabBar(
                  currentIndex: selectedIndex,
                  tabs: const <String>[
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
                              if (widget.product.images?[0] != null &&
                                  widget.product.images![0].isNotEmpty)
                                Container(
                                  height: 250,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: GenericSlider(
                                    images: widget.product.images!,
                                  ),
                                ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.product.name,
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
                                  Wrap(
                                    children: <Widget>[
                                      Text(
                                        shopController.shop!.currency,
                                        style: const TextStyle(
                                          color: proprimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        widget.product.price.toString(),
                                        style: const TextStyle(
                                          color: proprimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (widget.product.deliveryMethod != null)
                                    Text(
                                      widget.product.deliveryMethod!,
                                      style: const TextStyle(
                                        color: proprimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  if (widget.product.location != null)
                                    Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.location_on,
                                          color: proprimaryColor,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.product.location!,
                                          style: const TextStyle(
                                            color: proprimaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
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
                                  text: widget.product.description,
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
                        CustomEditText(
                          caption: 'Enter Quantity',
                          hintText: '1',
                          controller: quantityController,
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (widget.product.size![0].isNotEmpty)
                          CustomDropdownWidget(
                            caption: 'Choose Color',
                            items: widget.product.color!
                                .map((String e) => e)
                                .toList(),
                            iconName: 'assets/svgs/dropdown.svg',
                            onChanged: (String? value) => setState(() {
                              // category = value!;
                            }),
                          ),
                        if (widget.product.color![0].isNotEmpty)
                          const SizedBox(
                            height: 15,
                          ),
                        if (widget.product.size![0].isNotEmpty)
                          CustomDropdownWidget(
                            caption: 'Choose Size',
                            items: widget.product.size!
                                .map((String e) => e)
                                .toList(),
                            iconName: 'assets/svgs/dropdown.svg',
                            onChanged: (String? value) => setState(() {
                              // category = value!;
                            }),
                          ),
                        if (widget.product.size![0].isNotEmpty)
                          const SizedBox(
                            height: 15,
                          ),
                        SizedBox(
                          width: double.infinity,
                          child: ProCustomButton(
                            onPressed: () {
                              // Check if the current index is less than the total tabs - 1
                              if (_tabController.index <
                                  _tabController.length - 1) {
                                // Move to the next tab
                                setState(() {
                                  _tabController.index +=
                                      1; // Go to the next tab
                                  selectedIndex++;
                                });
                              }
                            },
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
                  ListView(
                    children: <Widget>[
                      OrderPreviewCard(
                        title: widget.product.name,
                        size: widget.product.size![0],
                        color: widget.product.color![0],
                        price: widget.product.price,
                        deliveryDays: widget.product.deliveryDuration!,
                        deliveryLocation: widget.product.location!,
                        imageUrl: widget.product.images![0],
                        OnTap: () {
                          // Get.to(() => OrderProductScreen(
                          //     product: widget.product,
                          //     isEdit: true));
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      OrderPaymentMethodsWidget(
                        paymentMethods: shopController.shop!.payments,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      OrderSummaryWidget(
                        quantity: int.parse(quantityController.text),
                        price: widget.product.price,
                        discount: widget.product.discount!,
                        total: (1 - widget.product.discount!) *
                            (int.parse(quantityController.text) *
                                widget.product.price),
                        currency: shopController.shop!.currency,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ProCustomButton(
                          onPressed: () {
                            // Check if the current index is less than the total tabs - 1
                            if (_tabController.index <
                                _tabController.length - 1) {
                              // Move to the next tab
                              setState(() {
                                _tabController.index += 1; // Go to the next tab
                                selectedIndex++;
                              });
                            }
                          },
                          text: 'Next ',
                          icon: SvgPicture.asset(
                            'assets/svgs/nexticon.svg',
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
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
                                    style: const TextStyle(fontSize: 13),
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Phone Number',
                                      filled: false,
                                      fillColor: Colors.grey.shade100,
                                    ),
                                  ),
                                ],
                              ),
                              // Expanded(
                              //   child: CustomDropdownWidget(
                              //     caption: 'Select Client',
                              //     items: clientsName,
                              //     iconName: 'assets/svgs/dropdown.svg',
                              //     initialValue: selectedClient,
                              //     onChanged: (String? value) {
                              //       setState(() {
                              //         selectedClient = value!;
                              //         _onClientSelect(value);
                              //       });
                              //     },
                              //   ),
                              // ),
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
                        controller: deliveryController,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: 200,
                        child: ProCustomButton(
                          onPressed: () async {
                            setState(() {
                              isSubmit = true;
                            });
                            final Map<String, dynamic> orderData =
                                <String, dynamic>{
                              'userId': profileController.myProfile.uid,
                              'shopId': shopController.shop?.id,
                              'clientId': clientId,
                              'items': selectedItems,
                              'deliveryMethod': widget.product.deliveryMethod,
                              'deliveryDate': DateTime.now(),
                              'paymentMethod': widget.product.deliveryMethod,
                              'orderDetails': deliveryController.text,
                              'invoiceOption': 'send_with_payment_link'
                            };
                            bool response =
                                await orderController.addOrders(orderData);
                            if (response) {
                              showSnackbar(
                                  message: 'Order Added Successfully!');
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
                          text: 'Done ',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onClientSelect(String name) {
    final dynamic clientName = clients
        .firstWhere((Map<String, dynamic> element) => element['name'] == name);
    setState(() {
      clientId = clientName['id'];
    });
  }
}
