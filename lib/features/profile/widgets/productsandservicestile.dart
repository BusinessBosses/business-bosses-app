import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../presentation/my_profile_screen.dart';

class ProductsandServicesExpansionTile extends StatefulWidget {
  const ProductsandServicesExpansionTile({super.key});

  @override
  _ProductsandServicessExpansionTileState createState() =>
      _ProductsandServicessExpansionTileState();
}

class _ProductsandServicessExpansionTileState
    extends State<ProductsandServicesExpansionTile> {
  TextEditingController productsController = TextEditingController();

  List<String> productsandservices = <String>[];
  String? _productsandservices;

  void addItemToproductList() {
    if (_productsandservices == null) {
      setState(() {
        productsandservices.insert(0, productsController.text);
        _productsandservices = productsandservices.join('+');
      });
    } else if (productsController.text.isNotEmpty &&
        productsController.text.trim().isNotEmpty &&
        productsandservices.length <= 6) {
      setState(() {
        productsandservices.insert(0, productsController.text);
        _productsandservices = productsandservices.join('+');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.black;
    const MaterialColor hintColor = Colors.grey;
    final Color subtextColor = Colors.grey[700]!;
    final Color backgroundcolorinterface = Colors.grey[200]!;

    return ExpansionTile(
      trailing: isExpanded
          ? SvgPicture.asset(
              'assets/svgs/dropdownexpansionup.svg',
            )
          : SvgPicture.asset(
              'assets/svgs/dropdownexpansion.svg',
            ),
      title: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: 'Add Products & Services',
                style: TextStyle(color: textColor)),
            const TextSpan(
                text: ' (Optional)', style: TextStyle(color: hintColor)),
          ],
        ),
      ),
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'You can add up to 7 products and services',
                            style: TextStyle(color: subtextColor),
                          )
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 20, bottom: 5),
                    child: TextField(
                      controller: productsController,
                      maxLength: 30,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Add Products & Services',
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: productsandservices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: double.infinity,
                                height: 1.5,
                                child:
                                    ColoredBox(color: backgroundcolorinterface),
                              ),
                              ListTile(
                                title: Text(productsandservices[index]),
                                leading: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child: SvgPicture.asset(
                                      'assets/svgs/product.svg'),
                                ),
                                trailing: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child:
                                      SvgPicture.asset('assets/svgs/close.svg'),
                                ),
                                onTap: () {
                                  setState(() {
                                    productsandservices
                                        .remove(productsandservices[index]);
                                  });
                                },
                              )
                            ],
                          ));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Add Product',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      onPressed: () {
                        addItemToproductList();
                        productsController.clear();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ])),
      ],
    );
  }
}
