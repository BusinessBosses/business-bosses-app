import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/shop_screen.dart';
import 'package:business_bosses_v2/bbpro/presentation/user_shop_screen.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderpaymentcard.dart';
import 'package:business_bosses_v2/bbpro/widgets/ordersummarycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/paymentoptioncard.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class OrderProductScreen extends StatefulWidget {
  final Product product;
  final Shop shop;
  const OrderProductScreen(
      {super.key, required this.product, required this.shop});

  @override
  State<OrderProductScreen> createState() => _OrderProductScreenState();
}

class _OrderProductScreenState extends State<OrderProductScreen> {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  final OrderController orderController = Get.put(OrderController());
  final TextEditingController deliveryController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  List<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[];

  List<String> clientsName = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];
  String? clientId;
  String? selectedClient;

  List<dynamic>? paymentMethods;
  String paymentMethod = '';
  String activePaymentMethod = '';

  bool isSubmit = false;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    paymentMethods = widget.shop.payments;
    if (paymentMethods!.isNotEmpty) {
      activePaymentMethod = paymentMethods![0]['paymentMethod'] ?? '';
    }
    quantityController.text = '1';
    fullNameController.text = profileController.myProfile.name!;
    emailController.text = profileController.myProfile.email;
    // selectedItems.add(
    //   <String, dynamic>{
    //     'type': 'product',
    //     'id': widget.product.id,
    //     'name': widget.product.name
    //   },
    // );
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
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          titleSpacing: 0,
          title: GestureDetector(
            onTap: () {
              Get.to(UserShopScreen(
                user: widget.product.user!,
              ));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.product.shop!.name,
                  style: const TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
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
            Column(
              children: <Widget>[
                if (widget.product.images?[0] != null &&
                    widget.product.images![0].isNotEmpty)
                  SizedBox(
                    height: 250,
                    child: GenericSlider(
                      iconcolor: textColor,
                      radius: 0,
                      images: widget.product.images!,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: <Widget>[
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
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              if (widget.product.discount != null &&
                                  widget.product.discount! > 0)
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${widget.shop.currency}${((widget.product.price * (1 - widget.product.discount! / 100)) * 100).round() / 100}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.shop.currency}${widget.product.price.toStringAsFixed(2)}',
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
                                  '${widget.shop.currency}${widget.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: DetectableText(
                              text: widget.product.description,
                              detectionRegExp: detectionRegExp(hashtag: false)!,
                              detectedStyle: bodyText2.copyWith(
                                color: Colors.blue,
                              ),
                              moreStyle: bodyText2.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                              lessStyle: bodyText2.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                              trimLength: 100,
                              trimExpandedText: '  show less',
                              basicStyle: bodyText2.copyWith(color: textColor),
                              onTap: (_) {},
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (widget.product.notes != null)
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
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
                            widget.product.notes!,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: backgroundColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/svgs/shopchat.svg',
                                  height: 12,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Text('Reply'),
                              ],
                            ),
                          ),
                        ),
                        CustomEditText(
                          padding: 0,
                          hintText: 'Enter Note to Seller',
                          controller: noteController,
                          caption: '',
                        ),
                      ],
                    ),
                  ),
                if (widget.product.notes != null)
                  const SizedBox(
                    height: 16,
                  ),
                Container(
                  margin: const EdgeInsets.only(left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 15),
                        child: Text(
                          'Customise Order',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: textColor,
                          ),
                        ),
                      ),
                      CustomEditText(
                        isorder: true,
                        maxLength: 30,
                        padding: 0,
                        caption: 'Select Quantity',
                        hintText: '1',
                        controller: quantityController,
                        inputType: TextInputType.number,
                        onChanged: (String value) {
                          quantityController.text = value;
                          setState(() {});
                        },
                      ),
                      if (widget.product.size![0].isNotEmpty)
                        CustomDropdownWidget(
                          padding: 0,
                          isorder: true,
                          iconcolor: textColor,
                          caption: 'Choose Color',
                          items: widget.product.color!
                              .map((String e) => e)
                              .toList(),
                          iconName: 'assets/svgs/dropdown.svg',
                          onChanged: (String? value) => setState(() {
                            // category = value!;
                          }),
                        ),
                      if (widget.product.size![0].isNotEmpty)
                        CustomDropdownWidget(
                          padding: 0,
                          iconcolor: textColor,
                          isorder: true,
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (widget.shop.payments.isNotEmpty)
                  const SizedBox(
                    height: 15,
                  ),
                OrderSummaryWidget(
                  quantity: int.tryParse(quantityController.text) ?? 0,
                  price: widget.product.price,
                  discount: widget.product.discount ?? 0,
                  total: calculateTotal(
                    quantity: int.tryParse(quantityController.text) ?? 0,
                    price: widget.product.price,
                    discount: widget.product.discount ?? 0,
                  ),
                  currency: widget.shop.currency,
                ),
                const SizedBox(
                  height: 15,
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
                                      .map((payment) => ProPaymentOptionCard(
                                            option:
                                                payment['paymentMethod'] ?? '',
                                            subtext:
                                                'Details: ${payment['details'] ?? 'N/A'}',
                                            activeoption: activePaymentMethod,
                                            onTap: (String newOption) {
                                              setState(() {
                                                activePaymentMethod = newOption;
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ProCustomButton(
                    color: Colors.black,
                    loading: isSubmit,
                    onPressed: () async {
                      setState(() {
                        isSubmit = true;
                      });
                      final Map<String, dynamic> orderData = <String, dynamic>{
                        'userId': profileController.myProfile.uid,
                        'shopId': widget.shop.id,
                        'items': selectedItems,
                        'deliveryMethod': widget.product.deliveryMethod !=
                                    null &&
                                widget.product.deliveryMethod!.isNotEmpty
                            ? getDeliveryMethod(widget.product.deliveryMethod!)
                            : 'online',
                        'deliveryDate': DateTime.now().toString(),
                        'paymentMethod': activePaymentMethod,
                        'orderDetails': '',
                        'invoiceOption': 'send_with_payment_link',
                        'status': 'pending',
                        'notes': noteController.text,
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
                                'Order placed successfully',
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
                    text: 'Place Order',
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
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

  double calculateTotal({
    required int quantity,
    required double price,
    required double discount,
  }) {
    // Ensure positive values
    if (quantity <= 0) return 0;

    // Calculate base total
    final double baseTotal = quantity * price;

    // Calculate discount amount
    final double discountAmount =
        baseTotal * (discount / 100); // Assuming discount is in percentage

    // Final total after discount
    return baseTotal - discountAmount;
  }
}
