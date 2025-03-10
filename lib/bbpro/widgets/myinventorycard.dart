// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/boost_items.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MyInventoryCard extends StatefulWidget {
  final Product? product;
  final bool? myShop;
  final Shop? shop;
  final bool? isProduct;

  const MyInventoryCard({
    Key? key,
    this.product,
    this.isProduct,
    this.myShop,
    this.shop,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyInventoryCardState createState() => _MyInventoryCardState();
}

class _MyInventoryCardState extends State<MyInventoryCard> {
  final ShopController shopController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12, // Border color
            width: 0.5, // Border width
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: backgroundColor),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/svgs/product.svg',
                        height: 10,
                        colorFilter:
                            const ColorFilter.mode(textColor, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.product?.name ?? 'Product Name',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.myShop == false
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          color: primaryColorLT,
                          // border: Border.all(
                          //   color: proprimaryColor,
                          // ),
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
                    : OptionsButton(
                        item: widget.product,
                        onEdit: () => Get.to(
                          () => CreateProductListing(
                            product: widget.product,
                          ),
                        ),
                        onDelete: onDelete,
                        padding: const EdgeInsets.all(0),
                        borderColor: Colors.white,
                        onBoost: () {
                          Get.to(() => BoostItem(
                                product: widget.product,
                              ));
                        },
                        isBoost: true,
                      ),
              ],
            ),
            // if (widget.product?.images?[0] != null &&
            //     widget.product!.images![0].isNotEmpty)
            //   Padding(
            //     padding: const EdgeInsets.symmetric(vertical: 10.0),
            //     child: SizedBox(
            //       height: 120.0,
            //       width: double.infinity,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(10),
            //         child: NetworkImageWithPlaceHolder(
            //           imageUrl: widget.product?.images?[0],
            //           radius: radius,
            //           placeHolder: Icons.person,
            //           iconSize: 0.0,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text(
                        'Price: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      if (widget.product?.discount != null &&
                          widget.product!.discount! > 0)
                        Row(
                          children: <Widget>[
                            Text(
                              '${currencyValues[widget.product!.location.toString()]}${widget.product!.price * (1 - widget.product!.discount! / 100)}',
                              style: const TextStyle(
                                color: proprimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${currencyValues[widget.product!.location.toString()]}${widget.product?.price.toString()}',
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
                          '${currencyValues[widget.product!.location.toString()]}${widget.product?.price.toString()}',
                          style: const TextStyle(
                            color: proprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Description: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.product?.description ?? 'Product description',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Quantity: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        widget.product?.quantity.toString() ?? '0',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Storage Location: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.product?.storageLocation == null ||
                                  widget.product!.storageLocation!.isEmpty
                              ? 'N/A'
                              : widget.product?.storageLocation ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Product Number: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.product?.productNumber == null ||
                                  widget.product!.productNumber!.isEmpty
                              ? 'N/A'
                              : widget.product?.productNumber ?? 'N/A',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text(
                        'Status: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.product?.isActive == true
                              ? 'Active'
                              : 'Inactive',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final bool delete =
                  await shopController.deleteProduct(widget.product!.id);

              if (delete) {
                showSnackbar(message: 'Product deleted successfully!');
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                showSnackbar(message: 'Error deleting product!', error: true);
                Navigator.pop(context);
              }
              setState(() {});
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
