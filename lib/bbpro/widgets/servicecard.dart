import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';

class ServiceCard extends StatefulWidget {
  final Service? service;
  final bool? myShop;

  const ServiceCard({
    Key? key,
    this.service,
    this.myShop,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  final ShopController shopController = Get.find();
  void _onEdit() {
    Get.to(() => CreateServiceListing(
          service: widget.service,
        ));
  }

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
                imageUrl: (widget.service?.images == null ||
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
          const SizedBox(height: 5),
          const Divider(),
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
                    ),
                    Text(
                      '${shopController.shop!.currency}${widget.service?.price.toString()}',
                      style: const TextStyle(
                        color: proprimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      widget.service?.description ?? 'Service description',
                      style: const TextStyle(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              widget.myShop == false
                  ? GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: proprimaryColor,
                          ),
                        ),
                        child: const Text(
                          'Book',
                          style: TextStyle(
                            color: proprimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    )
                  : OptionsButton(
                      item: widget.service,
                      onEdit: _onEdit,
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
          'Delete Service',
          style: bodyText1,
        ),
        content: const Text('Are you sure you want to delete this service?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final bool delete =
                  await shopController.deleteService(widget.service!.id);
              if (delete) {
                showSnackbar(message: 'Service deleted successfully!');
              } else {
                showSnackbar(message: 'Error deleting service!', error: true);
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
