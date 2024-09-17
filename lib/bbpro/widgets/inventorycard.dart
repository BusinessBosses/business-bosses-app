// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';

class InventoryCard extends StatefulWidget {
  final Product product;
  final bool? isProduct;

  const InventoryCard({
    Key? key,
    required this.product,
    this.isProduct,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 120.0,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetworkImageWithPlaceHolder(
                imageUrl: widget.product.images?[0],
                radius: radius,
                placeHolder: Icons.person,
                iconSize: 0.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
          Row(
            children: <Widget>[
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(
                widget.product.price,
                style: const TextStyle(
                  color: proprimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (widget.isProduct == true)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    const CircleAvatar(
                      radius: 5,
                      backgroundColor: Colors.green,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.product.quantity > 0
                          ? '${widget.product.quantity.toString()} in Stock'
                          : 'Out of stock',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                OptionsButton(
                  item: widget.product,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
