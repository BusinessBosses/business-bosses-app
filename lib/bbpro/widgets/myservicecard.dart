// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/optionsbutton.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/currency.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

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

class MyServiceCard extends StatefulWidget {
  final Service service;
  final bool? myShop;
  final Shop? shop;
  final bool? isService;

  const MyServiceCard({
    super.key,
    required this.service,
    this.isService,
    this.myShop,
    this.shop,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyServiceCardState createState() => _MyServiceCardState();
}

class _MyServiceCardState extends State<MyServiceCard> {
  final ShopController shopController = Get.find();
  final String serviceduration = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 0.5,
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
                        'assets/svgs/myservices.svg',
                        height: 10,
                        colorFilter:
                            const ColorFilter.mode(textColor, BlendMode.srcIn),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.service.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                widget.myShop == false
                    ? GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: primaryColorLT,
                          ),
                          child: const Text(
                            'Book',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      )
                    : OptionsButton(
                        item: widget.service,
                        onEdit: () => Get.to(
                          () => CreateServiceListing(
                            service: widget.service,
                          ),
                        ),
                        onDelete: onDelete,
                        padding: const EdgeInsets.all(0),
                        borderColor: Colors.white,
                        // onBoost: () {
                        //   Get.to(() => BoostItem(
                        //         service: widget.service,
                        //       ));
                        // },
                        // isBoost: true,
                      ),
              ],
            ),
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
                      if (widget.service.discount > 0)
                        Row(
                          children: <Widget>[
                            Text(
                              '${formatServiceDuration(widget.service.serviceDuration)}${currencyValues[widget.service.location.toString()]}${((widget.service.price) * (1 - (widget.service.discount) / 100)).toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: proprimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '${currencyValues[widget.service.location.toString()]}${widget.service.price.toStringAsFixed(2)}',
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
                          '${formatServiceDuration(widget.service.serviceDuration)}${currencyValues[widget.service.location.toString()]}${(widget.service.price).toStringAsFixed(2)}',
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
                          widget.service.description,
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
                        'Delivery Method: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.service.deliveryMethod ?? 'N/A',
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
                        'Service Type: ',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 13,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              widget.service.serviceType ??
                                  'Service description',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
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
                          widget.service.isActive == true
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
          'Delete Service',
          style: bodyText1,
        ),
        content: const Text('Are you sure you want to delete this service?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(Get.context!);
              Navigator.pop(Get.context!);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              final bool delete =
                  await shopController.deleteService(widget.service.id);
              if (delete) {
                showSnackbar(message: 'Service deleted successfully!');
                Navigator.pop(Get.context!);
                Navigator.pop(Get.context!);
              } else {
                showSnackbar(message: 'Error deleting service!', error: true);
                Navigator.pop(Get.context!);
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
