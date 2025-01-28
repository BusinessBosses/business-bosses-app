import 'package:business_bosses_v2/action/action.dart';
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
  bool blocked = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    paymentMethods = widget.shop.payments;
    if (paymentMethods!.isNotEmpty) {
      activePaymentMethod = paymentMethods![0]['paymentMethod'] ?? '';
    }
    quantityController.text = '1';
    fullNameController.text = profileController.myProfile.name ??
        profileController.myProfile.username;
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
                              title: widget.product.user!.isSubscribed
                                  ? Row(
                                      children: <Widget>[
                                        TextWidget(
                                          text: blocked == true
                                              ? 'Unblock @${widget.product.user!.name ?? widget.product.user!.username}'
                                              : 'Block @${widget.product.user!.name ?? widget.product.user!.username}',
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
                                          ? 'Unblock @${widget.product.user!.name ?? widget.product.user!.username}'
                                          : 'Block @${widget.product.user!.name ?? widget.product.user!.username}',
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
                                              widget.product.user!.uid,
                                              widget.product.user!.username);
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
          titleSpacing: 0,
          title: GestureDetector(
            onTap: () {
              if (Get.previousRoute == Routes.publicProfile) {
                Get.back();
              } else {
                Get.to(
                  () => PublicProfileScreen(
                    currentIndex: 1,
                  ),
                  arguments: widget.product.user,
                );
              }
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
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${widget.shop.currency}${widget.product.price.toStringAsFixed(2)}',
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
                if (widget.product.notes != null)
                  const SizedBox(
                    height: 16,
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
                        CustomEditText(
                          padding: 0,
                          hintText: 'Enter Note to Seller here',
                          controller: noteController,
                          caption: '',
                        ),
                      ],
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

  Future<void> _reportUser(BuildContext context, String reportType,
      String userId, String username) async {}
}
