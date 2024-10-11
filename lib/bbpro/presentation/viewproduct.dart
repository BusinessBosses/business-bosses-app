import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/textfield.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../utils/theme/theme.dart';

class ExpandedProduct extends StatefulWidget {
  final Product product;
  const ExpandedProduct({super.key, required this.product});

  @override
  State<ExpandedProduct> createState() => _ExpandedProductState();
}

class _ExpandedProductState extends State<ExpandedProduct> {
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
            'View Product',
            style: TextStyle(
              color: proprimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0, bottom: 10),
              child: CircleAvatar(
                  backgroundColor: backgroundColor,
                  radius: 30, // This sets the circle's radius
                  child: Icon(
                    Icons.more_vert,
                    color: textColor,
                  )),
            )
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              color: Colors.white,
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
                            color: widget.product.isActive
                                ? Colors.green.withAlpha(50)
                                : Colors.red,
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: Text(
                          widget.product.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            color: widget.product.isActive
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.product.price.toString(),
                        style: const TextStyle(
                          color: proprimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.product.deliveryMethod,
                        style: const TextStyle(
                          color: proprimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.product.location,
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
                      text: widget.product.description,
                      detectionRegExp: detectionRegExp(hashtag: false)!,
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
                      basicStyle: bodyText2.copyWith(color: textColor),
                      onTap: (_) {},
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextWidget(
                    caption: 'Product number',
                    iconName: '',
                    text: widget.product.productNumber.toString(),
                    backgroundColor: probackgroundColor,
                    padding: 0.0,
                    textpadding: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextWidget(
                    caption: 'Quantity',
                    iconName: '',
                    text: widget.product.quantity.toString(),
                    backgroundColor: probackgroundColor,
                    padding: 0.0,
                    textpadding: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextWidget(
                    caption: 'Colors',
                    iconName: '',
                    text: widget.product.color,
                    backgroundColor: probackgroundColor,
                    padding: 0.0,
                    textpadding: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextWidget(
                    caption: 'Sizes',
                    iconName: '',
                    text: widget.product.size,
                    backgroundColor: probackgroundColor,
                    padding: 0.0,
                    textpadding: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomTextWidget(
                    caption: 'Storage Location',
                    iconName: '',
                    text: widget.product.storageLocation,
                    backgroundColor: probackgroundColor,
                    padding: 0.0,
                    textpadding: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const CustomTextWidget(
                    isSupplier: true,
                    caption: 'Supplier',
                    iconName: '',
                    text: 'Supplier name',
                    backgroundColor: probackgroundColor,
                    padding: 0.0,
                    textpadding: 15,
                    buttontext: 'Contact Supplier',
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
