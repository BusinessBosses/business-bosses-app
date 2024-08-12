import 'package:business_bosses_v2/bbpro/common/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/textfield.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/theme/theme.dart';

class ExpandedProduct extends StatefulWidget {
  const ExpandedProduct({super.key});

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
                Navigator.pop(context);
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
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0, bottom: 10),
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
            children: [
              Container(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      height: 250,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: GenericSlider(
                        images: ['', '', ''],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Product name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green.withAlpha(50),
                              borderRadius: BorderRadius.circular(30)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Text(
                            'Active',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Product price',
                          style: TextStyle(
                            color: proprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Delivery',
                          style: TextStyle(
                            color: proprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Location',
                          style: TextStyle(
                            color: proprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          'Description',
                          style: const TextStyle(
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
                        text: "akwkwlwlkwkljwk wlknwl wl,nwlwnw" ?? '',
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
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextWidget(
                      caption: 'Product number',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextWidget(
                      caption: 'Quantity',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextWidget(
                      caption: 'Colors',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextWidget(
                      caption: 'Sizes',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextWidget(
                      caption: 'Storage Location',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    CustomTextWidget(
                      isSupplier: true,
                      caption: 'Supplier',
                      iconName: '',
                      text: 'Supplier name',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                      buttontext: 'Contact Supplier',
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
