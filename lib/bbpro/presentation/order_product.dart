import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'dart:developer';

import 'package:business_bosses_v2/bbpro/controllers/order_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/dropdown.dart';
import 'package:business_bosses_v2/bbpro/widgets/edit_text.dart';
import 'package:business_bosses_v2/bbpro/widgets/ordersummarycard.dart';
import 'package:business_bosses_v2/bbpro/widgets/paymentoptioncard.dart';
import 'package:business_bosses_v2/bbpro/widgets/countrycodes.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
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
import '../../common/widgets/coin_price.dart';
import '../../utils/currency_format.dart';

class OrderProductScreen extends StatefulWidget {
  final bool? ismarketplace;
  final Product product;
  final Shop shop;
  const OrderProductScreen({
    super.key,
    required this.product,
    required this.shop,
    this.ismarketplace,
  });

  @override
  State<OrderProductScreen> createState() => _OrderProductScreenState();
}

class _OrderProductScreenState extends State<OrderProductScreen>
    with WidgetsBindingObserver {
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
  List<Map<String, dynamic>> selectedDetails = <Map<String, dynamic>>[];
  final MarketController marketController = Get.find();

  List<String> clientsName = <String>[];
  List<Map<String, dynamic>> clients = <Map<String, dynamic>>[];
  String? clientId;
  String? selectedClient;

  List<dynamic>? paymentMethods;
  String paymentMethod = '';
  String activePaymentMethod = '';
  String? selectedColor;
  String? selectedSize;

  bool isSubmit = false;

  late FocusNode _focusNode;
  bool blocked = false;
  bool isProProduct = false;
  bool earn = false;

  String shareErrorMessage = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode = FocusNode();
    paymentMethods = List<dynamic>.from(widget.shop.payments);

    // Check if item has a valid price and we have enough coins, optionally we could
    // do the check on the backend, but we can do a UI pre-check here to enable/disable it.
    // For now we just add the "Pay with coins" option if they have coins.
    paymentMethods!.add(<String, String>{
      'paymentMethod': 'Pay with Coins',
      'details': 'Deducted directly from your wallet balance'
    });

    log(widget.shop.toMap().toString());
    if (paymentMethods!.isNotEmpty) {
      activePaymentMethod = paymentMethods![0]['paymentMethod'] ?? '';
    }
    quantityController.text = '1';
    fullNameController.text = profileController.myProfile.name ??
        profileController.myProfile.username;
    emailController.text = profileController.myProfile.email;
    selectedItems.add(
      <String, dynamic>{
        'type': 'product',
        'id': widget.product.id,
        'name': widget.product.name
      },
    );
    isProProduct = marketController.proProducts.any((Product product) =>
        product.id == widget.product.id && product.user!.isSubscribed);
    if ((widget.product.color != null &&
            widget.product.color!.isNotEmpty &&
            widget.product.color!.first.isNotEmpty) ||
        (widget.product.size != null &&
            widget.product.size!.isNotEmpty &&
            widget.product.size!.first.isNotEmpty)) {
      selectedDetails.add(<String, dynamic>{'color': '', 'size': ''});
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && earn) {
      // Show the coin earned dialog when the app resumes
      Get.dialog(
        AlertDialog(
          title: const Text('Shared Successfully!'),
          content:
              const Text('You have earned 2 coins for sharing this listing'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Get.back(); // Dismiss dialog
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
      setState(() {
        earn = false; // Reset the flag after showing the dialog
      });
    }
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
            if (isProProduct)
              GestureDetector(
                onTap: () async {
                  Get.dialog(
                    const AlertDialog(
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text('Sharing...'),
                        ],
                      ),
                    ),
                    barrierDismissible: false,
                  );
                  await shopController
                      .shareEarn(widget.product.id, 'goods')
                      .then((ApiResponseModel value) {
                    if (value.success) {
                      profileController.updateCoinCount(2);
                      setState(() {
                        earn = true;
                      });
                    } else {
                      setState(() {
                        shareErrorMessage = value.errorMessage ?? '';
                      });
                    }
                  });
                  Get.back();
                  await _shareProduct();
                  if (shareErrorMessage ==
                      'User has gained coin from sharing the listings') {
                    Get.dialog(
                      AlertDialog(
                        content: const Text(
                            'You have already earned from sharing this listing before!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back(); // Dismiss dialog
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  } else if (shareErrorMessage ==
                      'Post owner does not have enough listing coins') {
                    Get.dialog(
                      AlertDialog(
                        content: const Text(
                            'All Coins for this listings have been claimed!'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Get.back(); // Dismiss dialog
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/coin.svg',
                          height: 18,
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          'Share & Earn',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                  onTap: () {
                    if (profileController.myProfile.uid ==
                        widget.product.shop!.userId) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              /// ---------------- EDIT ----------------
                              ListTile(
                                onTap: () {
                                  navigateTo(context);
                                  Get.to(
                                    () => CreateProductListing(
                                      product: widget.product,
                                    ),
                                  );
                                },
                                contentPadding: EdgeInsets.zero,
                                title: const TextWidget(
                                  text: 'Edit',
                                  color: Colors.blue,
                                ),
                              ),

                              /// ---------------- DELETE ----------------
                              ListTile(
                                onTap: () {
                                  navigateTo(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const TextWidget(
                                        text: 'Delete this listing?',
                                        centralize: true,
                                        fontWeight: FontWeight.w700,
                                        size: 20,
                                      ),
                                      content: TextWidget(
                                        text:
                                            'This action cannot be undone. Are you sure you want to delete it?',
                                        centralize: true,
                                        color:
                                            Colors.black.withValues(alpha: .6),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => navigateTo(context),
                                          child: const TextWidget(
                                            text: 'Cancel',
                                            fontWeight: FontWeight.w700,
                                            size: 18,
                                            color: Color(0xFF616161),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            navigateTo(context);
                                            shopController.deleteProduct(
                                                widget.product.id);
                                            showSnackBar(context,
                                                message: 'Product deleted');
                                            Get.back();
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
                                              text: 'Delete',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                contentPadding: EdgeInsets.zero,
                                title: const TextWidget(
                                  text: 'Delete',
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      return;
                    }
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
                                      color: Colors.black.withValues(alpha: .6),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => navigateTo(context),
                                        child: const TextWidget(
                                          text: 'Cancel',
                                          fontWeight: FontWeight.w700,
                                          size: 18,
                                          color: Color(0xFF616161),
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
                                          colorFilter: const ColorFilter.mode(
                                              primaryColorLT, BlendMode.srcIn),
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
                                _shareProduct();
                              },
                              contentPadding: EdgeInsets.zero,
                              title: const TextWidget(
                                text: 'Share this listing',
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
                                      color: Colors.black.withValues(alpha: .6),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => navigateTo(context),
                                        child: const TextWidget(
                                          text: 'Cancel',
                                          fontWeight: FontWeight.w700,
                                          size: 18,
                                          color: Color(0xFF616161),
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
                            ),
                            ListTile(
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
                              contentPadding: EdgeInsets.zero,
                              title: const TextWidget(
                                text: 'View Biz-Center',
                                color: Colors.blue,
                              ),
                            ),
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
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Visit Biz-Center',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    // Icon(
                    //   Icons.chevron_right,
                    //   color: textColor,
                    //   size: 10,
                    // ),
                  ],
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              CoinPriceLabel(
                                price: (widget.product.discount != null &&
                                        widget.product.discount! > 0)
                                    ? widget.product.price *
                                        (1 - widget.product.discount! / 100)
                                    : widget.product.price,
                                originalPrice:
                                    (widget.product.discount != null &&
                                            widget.product.discount! > 0)
                                        ? widget.product.price
                                        : null,
                                currencyCode: widget.shop.currency,
                                priceStyle: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  const Icon(Icons.place,
                                      color: Color(0xFF616161), size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                    CountryCodes.nameToCode[
                                            widget.product.location?.trim()] ??
                                        'N/A',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Row(
                                children: <Widget>[
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                    (widget.product.user?.averageRating != null)
                                        ? widget.product.user!.averageRating!
                                            .toStringAsFixed(1)
                                        : '0.0',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 15),
                              Flexible(
                                child: Text(
                                  widget.product.category,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
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
                          setState(() {
                            selectedDetails
                                .clear(); // Clear previous selections
                            int quantity = int.tryParse(value) ?? 1;

                            selectedDetails =
                                List<Map<String, dynamic>>.generate(
                                    quantity,
                                    (int index) => <String, dynamic>{
                                          'color': '',
                                          'size': ''
                                        });
                          });
                        },
                      ),
                      if (widget.product.notes == null)
                        CustomEditText(
                          padding: 0,
                          hintText: 'Enter Note to Seller here',
                          controller: noteController,
                          caption: '',
                        ),

                      Column(
                        children: selectedDetails
                            .asMap()
                            .entries
                            .map((MapEntry<int, Map<String, dynamic>> entry) {
                          int index = entry.key;
                          // ignore: unused_local_variable
                          Map<String, dynamic> item = entry.value;
                          return Column(
                            children: <Widget>[
                              if (widget.product.color != null &&
                                  widget.product.color!.isNotEmpty &&
                                  widget.product.color!.first.isNotEmpty)
                                CustomDropdownWidget(
                                  padding: 0,
                                  isorder: true,
                                  iconcolor: textColor,
                                  caption: 'Choose Color ${index + 1}',
                                  items: widget.product.color!
                                      .map((String e) => e)
                                      .toList(),
                                  iconName: 'assets/svgs/dropdown.svg',
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedDetails[index]['color'] = value!;
                                    });
                                  },
                                ),
                              if (widget.product.size != null &&
                                  widget.product.size!.isNotEmpty &&
                                  widget.product.size!.first.isNotEmpty)
                                CustomDropdownWidget(
                                  padding: 0,
                                  iconcolor: textColor,
                                  isorder: true,
                                  caption: 'Choose Size ${index + 1}',
                                  items: widget.product.size!
                                      .map((String e) => e)
                                      .toList(),
                                  iconName: 'assets/svgs/dropdown.svg',
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedDetails[index]['size'] = value!;
                                    });
                                  },
                                ),
                            ],
                          );
                        }).toList(),
                      ),
                      // if (selectedItems.isNotEmpty)
                      //   Padding(
                      //     padding: const EdgeInsets.only(
                      //         bottom: 15.0, left: 15, right: 15),
                      //     child: Text(
                      //       selectedItems
                      //           .map((Map<String, dynamic> item) =>
                      //               '${item['color']} - ${item['size']}')
                      //           .join(', '),
                      //       style: const TextStyle(fontSize: 12),
                      //     ),
                      //   ),
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
                        paymentMethods!.isNotEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  children: paymentMethods!
                                      .map((dynamic payment) {

                                        String detailsText = 'Details: ${payment['details'] ?? 'N/A'}';
                                        if (payment['paymentMethod'] == 'Pay with Coins') {
                                          detailsText = payment['details'] ?? '';
                                        }

                                        return ProPaymentOptionCard(
                                            option:
                                                payment['paymentMethod'] ?? '',
                                            subtext: detailsText,
                                            activeoption: activePaymentMethod,
                                            onTap: (String newOption) {
                                              setState(() {
                                                if (activePaymentMethod !=
                                                    newOption) {
                                                  activePaymentMethod =
                                                      newOption;
                                                } else {
                                                  activePaymentMethod = '';
                                                }
                                              });
                                            },
                                          );
                                      })
                                      .toList(),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Center(
                                  child: Text(
                                    'User has not added a payment method yet',
                                    style: TextStyle(
                                        color: Color(0xFF616161), fontSize: 14),
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
                if (activePaymentMethod == 'Pay with Coins') ...<Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('You will pay',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          Row(
                            children: <Widget>[
                              SvgPicture.asset('assets/svgs/coin.svg',
                                  height: 24, width: 24),
                              const SizedBox(width: 6),
                              Text(
                                '${CurrencyFormatter.formatCoins(_coinTotal())} coins',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.coinEquivalent(_coinTotal()),
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: proprimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: !isSubmit ? () async {
                        setState(() {
                          isSubmit = true;
                        });
                        if (activePaymentMethod.isEmpty) {
                          showSnackbar(
                            message: 'Please select a payment method',
                            error: true,
                          );
                          setState(() {
                            isSubmit = false;
                          });
                          return;
                        }
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
                          'orderDetails': selectedDetails.isNotEmpty
                              ? selectedDetails.toString()
                              : '',
                          'invoiceOption': 'send_with_payment_link',
                          'status': 'pending',
                          'notes': noteController.text,
                          'quantity': int.tryParse(quantityController.text) ?? 1,
                        };
                        final String? newOrderId =
                            await orderController.addOrder(orderData);
                        if (newOrderId == null) {
                          showSnackbar(
                              message: 'Error creating order!', error: true);
                          setState(() {
                            isSubmit = false;
                          });
                          return;
                        }
                        // Coin settlement (escrow-held until delivery) ONLY when the
                        // buyer chose to pay with coins.
                        if (activePaymentMethod == 'Pay with Coins') {
                          final ApiResponseModel payRes = await orderController
                              .payOrderWithCoins(newOrderId);
                          if (!payRes.success) {
                            showSnackbar(
                                message: payRes.message.isNotEmpty
                                    ? payRes.message
                                    : 'Coin payment failed. Please check your balance.',
                                error: true);
                            setState(() {
                              isSubmit = false;
                            });
                            return;
                          }
                          final int paid = int.tryParse(
                                  '${payRes.data?['coinAmount'] ?? 0}') ??
                              0;
                          if (paid > 0) {
                            profileController.updateCoinCount(-paid);
                          }
                        }
                        {
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
                        }
                      } : null,
                      child: isSubmit
                          ? const CircularProgressIndicator(color: Colors.white)
                          : (activePaymentMethod == 'Pay with Coins'
                              ? Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    const Text('Pay ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    SvgPicture.asset('assets/svgs/coin.svg', width: 20, height: 20),
                                    const SizedBox(width: 4),
                                    Text(CurrencyFormatter.formatCoins(_coinTotal()), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                  ],
                                )
                              : const Text('Place Order', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
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

  /// This order's total converted to coins (for the Pay-with-Coins flow).
  int _coinTotal() => CurrencyFormatter.coinsForPrice(
        calculateTotal(
          quantity: int.tryParse(quantityController.text) ?? 0,
          price: widget.product.price,
          discount: widget.product.discount ?? 0,
        ),
        currencyCode: widget.shop.currency,
      );

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

  Future<void> _shareProduct() async {
    String message = '${widget.product.name}:\n'
        '${widget.product.description}\n'
        '$bizCenterBaseUrl/${widget.shop.name.toLowerCase().replaceAll(' ', '-')}';
    socialShare(message);
  }
}
