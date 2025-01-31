import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/customitem_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_custom_listing.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomItemCard extends StatefulWidget {
  final Customitem? customitem;
  final bool? myShop;
  final Shop? shop;

  const CustomItemCard({
    Key? key,
    this.customitem,
    this.myShop,
    this.shop,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomItemCardState createState() => _CustomItemCardState();
}

class _CustomItemCardState extends State<CustomItemCard> {
  final ShopController shopController = Get.find();
  void _onEdit() {
    Get.to(() => CreateCustomListing(
          customItem: widget.customitem,
        ));
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          (
                  // ignore: always_specify_types
                  widget.customitem!.images![0] == '')
              ? Container()
              : SizedBox(
                  height: 120.0,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: NetworkImageWithPlaceHolder(
                      imageUrl: (widget.customitem?.images == null &&
                              widget.customitem!.images!.isEmpty)
                          ? ''
                          : widget.customitem?.images![0],
                      radius: radius,
                      placeHolder: Icons.link,
                      iconSize: 25.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          if (widget.customitem!.images![0] != '') const SizedBox(height: 5),
          if (widget.customitem!.images![0] != '') const Divider(),
          if (widget.customitem!.images![0] != '') const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.customitem?.title ?? 'Title',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.myShop == false)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.customitem?.description ??
                                  'Item description',
                              style: const TextStyle(fontSize: 11),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 5,
                              ),
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
                                child: const Row(
                                  children: <Widget>[
                                    Text(
                                      'Open',
                                      style: TextStyle(
                                        color: primaryColorLT,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.link,
                                      size: 15,
                                      color: primaryColorLT,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.myShop == false) const SizedBox(height: 5),
          widget.myShop == false
              ? Container()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.customitem?.description ??
                                'Service description',
                            style: const TextStyle(fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: backgroundColor,
                            ),
                            child: const Icon(
                              Icons.link,
                              size: 15,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    OptionsButton(
                      item: widget.customitem,
                      onEdit: _onEdit,
                      onDelete: () {},
                      onBoost: () {},
                      isBoost: true,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
