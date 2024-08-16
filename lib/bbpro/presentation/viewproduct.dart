import 'package:business_bosses_v2/bbpro/common/widgets/textfield.dart';
import 'package:business_bosses_v2/common/generic_slider.dart';
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      child: const GenericSlider(
                        images: <String>['', '', ''],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        const Text(
                          'Product name',
                          style: TextStyle(
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
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: const Text(
                            'Active',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                        text: 'akwkwlwlkwkljwk wlknwl wl,nwlwnw',
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
                    const CustomTextWidget(
                      caption: 'Product number',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomTextWidget(
                      caption: 'Quantity',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomTextWidget(
                      caption: 'Colors',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomTextWidget(
                      caption: 'Sizes',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
                      backgroundColor: probackgroundColor,
                      padding: 0.0,
                      textpadding: 15,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const CustomTextWidget(
                      caption: 'Storage Location',
                      iconName: '',
                      text: 'Barcode - 934890843284490',
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
        ));
  }
}
