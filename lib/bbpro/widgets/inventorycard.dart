// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
// import 'package:business_bosses_v2/bbpro/presentation/boost_items.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/widgets/countrycodes.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/coin_price.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
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
  final bool? marketplace;

  const InventoryCard({
    super.key,
    this.product,
    this.isProduct,
    this.myShop,
    this.shop,
    this.marketplace,
  });

  @override
  // ignore: library_private_types_in_public_api
  _InventoryCardState createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  final ShopController shopController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // PostTag(
          //   label: 'Product',
          //   textColor: textColor,
          //   backgroundColor: backgroundColor,
          // ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                if (widget.product?.images != null &&
                    widget.product!.images!.isNotEmpty &&
                    widget.product?.images?[0] != null &&
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
                if (widget.product?.images != null &&
                    widget.product!.images!.isNotEmpty &&
                    widget.product?.images?[0] != null &&
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
                              color: textColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          CoinPriceLabel(
                            price: (widget.product?.discount != null &&
                                    widget.product!.discount! > 0)
                                ? (widget.product!.price *
                                        (1 - widget.product!.discount! / 100))
                                    .clamp(0.0, double.infinity)
                                : widget.product!.price,
                            originalPrice: (widget.product?.discount != null &&
                                    widget.product!.discount! > 0)
                                ? widget.product!.price
                                : null,
                            currencyCode: currencyValues[
                                widget.product!.location.toString()],
                          ),
                          if (widget.myShop == false)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    widget.product?.description ??
                                        'Product description',
                                    style: const TextStyle(fontSize: 11),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (widget.marketplace == null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: primaryColorLT,
                                      ),
                                    ),
                                    child: const Text(
                                      'Order',
                                      style: TextStyle(
                                        color: primaryColorLT,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.marketplace != null)
                  const SizedBox(
                    height: 5,
                  ),
                widget.myShop == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (widget.marketplace == true)
                            Row(
                              children: <Widget>[
                                const Icon(Icons.place,
                                    color: Color(0xFF616161), size: 15),
                                const SizedBox(width: 4),
                                Text(
                                  CountryCodes.nameToCode[
                                          widget.product?.location?.trim()] ??
                                      'N/A',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          if (widget.marketplace == true)
                            Row(
                              children: <Widget>[
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 15),
                                const SizedBox(width: 4),
                                Text(
                                  (widget.product?.user?.averageRating != null)
                                      ? widget.product!.user!.averageRating!
                                          .toStringAsFixed(1)
                                      : '0.0',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          if (widget.marketplace == null) Container(width: 5),
                          if (widget.marketplace != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: primaryColorLT,
                                ),
                              ),
                              child: const Text(
                                'Order',
                                style: TextStyle(
                                  color: primaryColorLT,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.product?.description ??
                                  'Product description',
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          OptionsButton(
                            // isBoost: true,
                            item: widget.product,
                            onEdit: () => Get.to(
                              () => CreateProductListing(
                                product: widget.product,
                              ),
                            ),
                            // onBoost: () {
                            //   Get.to(() => BoostItem(
                            //         product: widget.product,
                            //       ));
                            // },
                            onDelete: onDelete,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatPrice(double price) {
    double absPrice = price.abs();
    if (absPrice >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (absPrice >= 1000) {
      return '${(price / 1000).toStringAsFixed(1)}K';
    } else {
      return price.toStringAsFixed(2);
    }
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
              Get.back();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Close dialog immediately
              final bool delete =
                  await shopController.deleteProduct(widget.product!.id);

              if (delete) {
                showSnackbar(message: 'Product deleted successfully!');
              } else {
                showSnackbar(message: 'Error deleting product!', error: true);
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
