// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:flutter/material.dart';

import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:get/get.dart';

class InventoryCard extends StatefulWidget {
  final Product? product;
  final bool? myShop;
  final Shop? shop;
  final bool? isProduct;

  const InventoryCard({
    Key? key,
    this.product,
    this.isProduct,
    this.myShop,
    this.shop,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.black12,
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.product?.images?[0] != null &&
              widget.product!.images![0].isNotEmpty)
            SizedBox(
              height: 120.0,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: NetworkImageWithPlaceHolder(
                  imageUrl: widget.product?.images?[0],
                  radius: radius,
                  placeHolder: Icons.person,
                  iconSize: 0.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (widget.product?.images?[0] != null &&
              widget.product!.images![0].isNotEmpty)
            const SizedBox(height: 5),
          if (widget.product?.images?[0] != null &&
              widget.product!.images![0].isNotEmpty)
            const Divider(),
          if (widget.product?.images?[0] != null &&
              widget.product!.images![0].isNotEmpty)
            const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.product?.name ?? 'Product Name',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.product?.discount != null &&
                        widget.product!.discount! > 0)
                      Row(
                        children: <Widget>[
                          Text(
                            '${widget.shop?.currency ?? shopController.shop!.currency}${((widget.product!.price * (1 - widget.product!.discount! / 100)) * 100).round() / 100}',
                            style: const TextStyle(
                              color: proprimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.shop?.currency ?? shopController.shop!.currency}${widget.product!.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        '${widget.shop?.currency ?? shopController.shop!.currency}${widget.product!.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: proprimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    if (widget.myShop == false)
                      Text(
                        widget.product?.description ?? 'Product description',
                        style: const TextStyle(fontSize: 11),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    // if (widget.myShop == false)
                    //   Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Wrap(
                    //         crossAxisAlignment: WrapCrossAlignment.center,
                    //         children: <Widget>[
                    //           CircleAvatar(
                    //             radius: 3,
                    //             backgroundColor: widget.product!.quantity! > 0
                    //                 ? Colors.green
                    //                 : Colors.red,
                    //           ),
                    //           // const SizedBox(width: 3),
                    //           // Text(
                    //           //   widget.product!.quantity! > 0
                    //           //       ? '${widget.product?.quantity.toString()} in Stock'
                    //           //       : 'Out of stock',
                    //           //   style: const TextStyle(fontSize: 10),
                    //           // ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          widget.myShop == false
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: const Text(
                    'Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.product?.description ?? 'Product description',
                          style: const TextStyle(fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     Wrap(
                        //       crossAxisAlignment: WrapCrossAlignment.center,
                        //       children: <Widget>[
                        //         CircleAvatar(
                        //           radius: 3,
                        //           backgroundColor: widget.product!.quantity! > 0
                        //               ? Colors.green
                        //               : Colors.red,
                        //         ),
                        //         const SizedBox(width: 3),
                        //         Text(
                        //           widget.product!.quantity! > 0
                        //               ? '${widget.product?.quantity.toString()} in Stock'
                        //               : 'Out of stock',
                        //           style: const TextStyle(fontSize: 10),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    OptionsButton(
                      item: widget.product,
                      onEdit: () => Get.to(
                        () => CreateProductListing(
                          product: widget.product,
                        ),
                      ),
                      onDelete: onDelete,
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void onDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Delete Product',
          style: bodyText1,
        ),
        content: const Text('Are you sure you want to delete this product?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final bool delete =
                  await shopController.deleteProduct(widget.product!.id);
              if (delete) {
                showSnackbar(message: 'Product deleted successfully!');
              } else {
                showSnackbar(message: 'Error deleting product!', error: true);
              }
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
