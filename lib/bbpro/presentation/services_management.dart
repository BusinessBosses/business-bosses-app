import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/service_model.dart';
import 'package:business_bosses_v2/bbpro/presentation/book_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/widgets/myservicecard.dart';
import 'package:business_bosses_v2/bbpro/widgets/servicecard.dart';
import 'package:business_bosses_v2/bbpro/widgets/proseardwidget.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<ManageServices> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  final ShopController shopController = Get.find();
  String? _selectedItem;
  String searchQuery = '';
  List<Service> filteredServices = <Service>[];

  @override
  void initState() {
    super.initState();
    filteredServices = shopController.services;
  }

  void _showFilterMenu(BuildContext context, Offset position) {
    showMenu(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      context: context,
      shadowColor: Colors.black,
      position: RelativeRect.fromLTRB(position.dx, position.dy,
          MediaQuery.of(context).size.width - position.dx, 0),
      items: <String>[
        'All Services',
        'Most Popular',
        'Newest First',
      ].map((String option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    ).then((String? selected) {
      if (selected != null) {
        setState(() {
          _selectedItem = selected;
        });
        // Implement filter logic here
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Text(
          'My Services (${filteredServices.length})',
          style: const TextStyle(
            color: proprimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Get.to(() => const CreateServiceListing());
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: proprimaryColor,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              // Search Bar
              SizedBox(
                height: 55,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/svgs/search.svg',
                                  height: 20,
                                  color: hintColor,
                                ),
                                Expanded(
                                  child: ProSearchbar(
                                    contentPadding: 10,
                                    hasSearchIcon: false,
                                    hintText: 'Search Services',
                                    autofocus: false,
                                    onChange: (String query) {
                                      setState(() {
                                        searchQuery = query;
                                        filteredServices = shopController
                                            .services
                                            .where((Service service) => service
                                                .name
                                                .toLowerCase()
                                                .contains(
                                                    searchQuery.toLowerCase()))
                                            .toList();
                                      });
                                    },
                                    onSubmit: (String query) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          onTap: () {
                            _showFilterMenu(
                              context,
                              Offset(
                                MediaQuery.of(context).size.width,
                                120,
                              ),
                            );
                          },
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(7),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: backgroundColor.withOpacity(0.6),
                                  offset: const Offset(-5, 0),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SvgPicture.asset(
                                  'assets/svgs/filterprosections.svg'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Product List
          Expanded(
            child: filteredServices.isNotEmpty
                ? ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredServices.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Service service = filteredServices[index];

                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => CreateServiceListing(
                              service: service,
                            ),
                          );
                          // Get.to(
                          //   () => BookServiceScreen(
                          //       service: service, shop: shopController.shop!),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MyServiceCard(
                            service: service,
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No Services found')),
          )
        ],
      ),
    );
  }
}
