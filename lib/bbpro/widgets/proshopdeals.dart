import 'package:business_bosses_v2/bbpro/models/product_model.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/order_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/proshopdealsscreen.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProshopdealsWidget extends StatefulWidget {
  final String? title;
  final String? caption;
  final List<Service>? services;
  final List<Product>? products;
  final List<Object>? combinedList;
  final bool? isHome;
  final int? initialIndex; // Added initialIndex
  const ProshopdealsWidget({
    Key? key,
    this.title,
    this.caption,
    this.services,
    this.products,
    this.combinedList,
    this.isHome,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<ProshopdealsWidget> createState() => _ProshopdealsWidgetState();
}

class _ProshopdealsWidgetState extends State<ProshopdealsWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Object>? items;
    if (widget.combinedList != null) {
      items = widget.combinedList!.where((Object object) {
        if (object is Product) {
          if (object.user!.isSubscribed) return true;
        } else if (object is Service) {
          if (object.user!.isSubscribed) {
            return true;
          }
        }
        return false;
      }).toList();
    } else {
      items = widget.products
              ?.where((Product product) => product.user!.isSubscribed)
              .take(10)
              .toList() ??
          widget.services
              ?.where((Service service) => service.user!.isSubscribed)
              .take(10)
              .toList();
    }
    return GestureDetector(
      onTap: () {
        Get.to(() => ProshopdealsScreen(
              initialIndex: widget.initialIndex,
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: widget.isHome != null && widget.isHome == true
              ? backgroundColor
              : Colors.white,
          borderRadius: BorderRadius.circular(
              widget.isHome != null && widget.isHome! ? 0 : 15),
        ),
        margin: EdgeInsets.symmetric(
            horizontal: widget.isHome != null && widget.isHome! ? 0 : 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.caption ?? 'Featured Listing',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  if (widget.title != null && widget.title != '')
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        widget.title ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  const Icon(Icons.chevron_right, color: textColor, size: 16),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Container(
              child: items!.isNotEmpty
                  ? SizedBox(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: items.map((Object item) {
                            if (item is Product) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => OrderProductScreen(
                                      product: item,
                                      shop: item.shop!,
                                    ),
                                  );
                                },
                                child: _buildDealItem(
                                  item.images!.isNotEmpty
                                      ? item.images![0]
                                      : 'assets/placeholder.png',
                                  item.name,
                                  '${item.price}',
                                  item.shop!.currency,
                                ),
                              );
                            } else if (item is Service) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(BookServiceScreen(
                                      shop: item.shop!, service: item));
                                },
                                child: _buildDealItem(
                                  item.images!.isNotEmpty
                                      ? item.images![0]
                                      : 'assets/placeholder.png',
                                  item.name,
                                  '${item.price}',
                                  item.shop!.currency,
                                ),
                              );
                            }
                            return const SizedBox();
                          }).toList(),
                        ),
                      ),
                    )
                  : const Center(child: Text('No deals available')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDealItem(
    String imagePath,
    String title,
    String originalPrice,
    String? currency,
  ) {
    return Container(
      width: 100, // Fixed width for each item
      margin:
          const EdgeInsets.symmetric(horizontal: 8.0), // Add margin for spacing
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Center content horizontally
        mainAxisSize:
            MainAxisSize.min, // Ensure the column takes minimum height
        children: <Widget>[
          // Image
          SizedBox(
            height: 80,
            width: 80,
            child: NetworkImageWithPlaceHolder(
              imageUrl: imagePath,
              fit: BoxFit.cover, // Ensure the image fits within the container
            ),
          ),
          const SizedBox(height: 8.0),
          // Title
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3.0),
          // Price
          Text(
            '$currency${(double.parse(originalPrice))}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
