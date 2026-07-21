import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/countrycodes.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/common/widgets/coin_price.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';

String formatServiceDuration(int? duration) {
  if (duration == null || duration == 2000000) return '';
  if (duration < 60) return '$duration mins @';
  if (duration < 1440) {
    int hours = duration ~/ 60;
    int minutes = duration % 60;
    String formattedDuration = '${hours}hr(s)';
    if (minutes > 0) {
      formattedDuration += ' ${minutes}mins';
    }
    return '$formattedDuration @ ';
  } else {
    int days = duration ~/ 1440;
    int remainingMinutes = duration % 1440;
    int hours = remainingMinutes ~/ 60;
    int minutes = remainingMinutes % 60;
    String formattedDuration = '${days}days';
    if (hours > 0) {
      formattedDuration += ' ${hours}hr(s)';
    }
    if (minutes > 0) {
      formattedDuration += ' ${minutes}mins';
    }
    return '$formattedDuration @ ';
  }
}

class ServiceCard extends StatefulWidget {
  final Service? service;
  final bool? myShop;
  final Shop? shop;
  final bool? marketplace;

  const ServiceCard({
    super.key,
    this.service,
    this.myShop,
    this.shop,
    this.marketplace,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String formatPrice(double price) {
    double absPrice = price.abs();
    if (absPrice >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}m';
    } else if (absPrice >= 1000) {
      return '${(price / 1000).toStringAsFixed(1)}k';
    } else {
      return price.toStringAsFixed(2);
    }
  }

  final ShopController shopController = Get.find();
  void _onEdit() {
    Get.to(() => CreateServiceListing(
          service: widget.service,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // PostTag(
          //     label: 'Service',
          //     textColor: textColor,
          //     backgroundColor: backgroundColor),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                if (widget.service?.images != null &&
                    widget.service!.images!.isNotEmpty)
                  SizedBox(
                    height: 120.0,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: NetworkImageWithPlaceHolder(
                        imageUrl: (widget.service?.images == null &&
                                widget.service!.images!.isEmpty)
                            ? ''
                            : widget.service?.images![0],
                        radius: radius,
                        placeHolder: Icons.person,
                        iconSize: 0.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (widget.service?.images != null &&
                    widget.service!.images!.isNotEmpty)
                  const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.service?.name ?? 'Service Name',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          CoinPriceLabel(
                            price: (widget.service?.discount != null &&
                                    widget.service!.discount > 0)
                                ? widget.service!.price *
                                    (1 - widget.service!.discount / 100)
                                : widget.service!.price,
                            originalPrice: (widget.service?.discount != null &&
                                    widget.service!.discount > 0)
                                ? widget.service!.price
                                : null,
                            currencyCode: currencyValues[
                                widget.service!.location.toString()],
                          ),
                          if (widget.myShop == false)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    widget.service?.description ??
                                        'Service description',
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
                                      'Book',
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
                if (widget.marketplace != null) const SizedBox(height: 5),
                widget.myShop == false
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          if (widget.marketplace == true)
                            Row(
                              children: <Widget>[
                                const Icon(Icons.place,
                                    color: Colors.grey, size: 15),
                                const SizedBox(width: 4),
                                Text(
                                  CountryCodes.nameToCode[
                                          widget.service?.location.trim()] ??
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
                                  (widget.service?.user?.averageRating != null)
                                      ? widget.service!.user!.averageRating!
                                          .toStringAsFixed(1)
                                      : 'N/A',
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
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: primaryColorLT,
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'Book',
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.service?.description ??
                                      'Service description',
                                  style: const TextStyle(fontSize: 11),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          OptionsButton(
                            item: widget.service,
                            onEdit: _onEdit,
                            onDelete: onDelete,
                            // onBoost: () {
                            //   Get.to(() => BoostItem(
                            //         service: widget.service,
                            //       ));
                            // },
                            // isBoost: true,
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

  void onDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Delete Service',
          style: bodyText1,
        ),
        content: const Text('Are you sure you want to delete this service?'),
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
                  await shopController.deleteService(widget.service!.id);
              if (delete) {
                showSnackbar(message: 'Service deleted successfully!');
              } else {
                showSnackbar(message: 'Error deleting service!', error: true);
              }
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
