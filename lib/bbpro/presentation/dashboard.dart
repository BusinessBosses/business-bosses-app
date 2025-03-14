import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_client.dart';
import 'package:business_bosses_v2/bbpro/presentation/bottom_nav_screen.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_custom_listing.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_product.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_service.dart';
import 'package:business_bosses_v2/bbpro/presentation/create_order.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/bbpro/presentation/todo_tasks_view.dart';
import 'package:business_bosses_v2/bbpro/widgets/financial_analysis_card.dart';
import 'package:business_bosses_v2/bbpro/widgets/gotoshopwidget.dart';
import 'package:business_bosses_v2/bbpro/widgets/infocard.dart';
import 'package:business_bosses_v2/bbpro/widgets/notificationbutton.dart';
import 'package:business_bosses_v2/bbpro/widgets/orderscard.dart';
import 'package:business_bosses_v2/bbpro/widgets/quickactioncard.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  final bool noBack;
  const Dashboard({
    super.key,
    this.noBack = true,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<String> titles = <String>[
    'Customers',
    'Visitors',
    'To-do tasks',
  ];

  final List<String> quickactions = <String>[
    'Add Listing',
    'Create Orders',
    'Add Customers',
  ];
  final ShopController shopController =
      Get.put(ShopController(), permanent: true);
  final ClientsController clientsController = Get.put(ClientsController());
  final ProfileController profileController = Get.find();
  String _selectedfilteritem = 'All Time';
  String _selectedDateFilter = 'all_time';

  @override
  void initState() {
    if (!profileController.myProfile.hasShop) {
      Get.to(() => const Setupshop(
            backToHome: true,
          ));
    }
    shopController.loadStatistics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        // titleSpacing: 0,
        // // centerTitle: true,
        // automaticallyImplyLeading: false,
        // leading: const GotoshopWidget(),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Expanded(child: GotoshopWidget()),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ChatScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 10.0,
                          ),
                          child: CircleAvatar(
                              radius: 20,
                              backgroundColor: prosemibackColor,
                              child: SvgPicture.asset(
                                'assets/svgs/prochat.svg',
                                height: 15,
                              )),
                        ),
                      ),
                      NotificationButton(
                        hasUnreadNotification:
                            shopController.shop!.user!.unReadCount != null &&
                                shopController.shop!.user!.unReadCount! > 0,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => shopController.loadingData.value
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SafetyModel(),
                  Text('Loading Statistics..'),
                ],
              )
            : SingleChildScrollView(
                child: Container(
                  color: probackgroundColor,
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          if (!widget.noBack)
                            GestureDetector(
                              onTap: () {
                                Get.off(() => const HomeScreen());
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.only(top: 10, left: 15),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: primaryColorLT.withAlpha(20),
                                    borderRadius: BorderRadius.circular(100)),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.chevron_left,
                                      color: primaryColorLT,
                                      size: 24,
                                    ),
                                    Image.asset(
                                      'assets/images/app_logo_2.png',
                                      height: 25,
                                    ),
                                    const Text(
                                      '  Go back to BB',
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                final RenderBox button =
                                    context.findRenderObject() as RenderBox;
                                final RenderBox overlay = Overlay.of(context)
                                    .context
                                    .findRenderObject() as RenderBox;
                                final RelativeRect position =
                                    RelativeRect.fromRect(
                                  Rect.fromPoints(
                                    button.localToGlobal(
                                        button.size
                                            .topRight(const Offset(0, 110)),
                                        ancestor: overlay),
                                    button.localToGlobal(
                                        button.size
                                            .bottomLeft(const Offset(0, 0)),
                                        ancestor: overlay),
                                  ),
                                  Offset.zero & overlay.size,
                                );

                                showMenu(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  context: context,
                                  shadowColor: Colors.black,
                                  position: position,
                                  items: <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: null,
                                      enabled: false,
                                      child: Text(
                                        'Filter Data By',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const PopupMenuDivider(),
                                    ...<String>[
                                      'Today',
                                      'Last 7 Days',
                                      'Last 30 Days',
                                      'All Time',
                                    ].map((String option) {
                                      return PopupMenuItem<String>(
                                        value: option,
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      );
                                    }).toList(),
                                  ],
                                ).then((String? selected) async {
                                  if (selected != null) {
                                    setState(() {
                                      if (selected == 'Today') {
                                        _selectedDateFilter = 'today';
                                      } else if (selected == 'Last 7 Days') {
                                        _selectedDateFilter = 'last_7_days';
                                      } else if (selected == 'Last 30 Days') {
                                        _selectedDateFilter = 'last_30_days';
                                      } else if (selected == 'All Time') {
                                        _selectedDateFilter = 'all_time';
                                      }
                                      _selectedfilteritem = selected;
                                    });
                                    await shopController
                                        .filterData(_selectedDateFilter);
                                    // Implement filter logic here
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                        'assets/svgs/filterprosections.svg'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _selectedfilteritem,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SvgPicture.asset(
                                      'assets/svgs/dropdown.svg',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const OrdersWidget(),
                      const FinancialanalysisWidget(),
                      StaggeredGridView.countBuilder(
                        physics: const NeverScrollableScrollPhysics(),
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        crossAxisCount: 3,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        // controller: _controller,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  Bottomnavscreen.of(context)?.onTabTapped(3);
                                } else if (index == 1) {
                                  // Add navigation for Expenses
                                } else if (index == 2) {
                                  Get.to(() => const TodoTaskView());
                                } else if (index == 3) {
                                  Get.to(() => const CreateOrder());
                                }
                              },
                              child: InfoCard(
                                cardName: titles[index],
                                value: index == 0
                                    ? shopController.shopStats!.clientCount
                                        .toString()
                                    : index == 1
                                        ? shopController.shopStats!.views
                                            .toString()
                                        : index == 2
                                            ? shopController
                                                .shopStats!.projectCount
                                                .toString()
                                            : '0',
                              ));
                        },
                      ),
                      StaggeredGridView.countBuilder(
                        physics: const NeverScrollableScrollPhysics(),
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        crossAxisCount: 3,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15.0,
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              if (index == 0) {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (BuildContext context) {
                                    return SizedBox(
                                      height: 270,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.all(10),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0) {
                                            return ListTile(
                                              leading: SvgPicture.asset(
                                                'assets/svgs/addproduct.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.black,
                                                  BlendMode.srcIn,
                                                ),
                                                height: 24,
                                              ),
                                              title: const Text(
                                                'Add Product',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              subtitle: const Text(
                                                  'To showcase your products in biz-centre & marketplace'),
                                              horizontalTitleGap: 0.0,
                                              onTap: () {
                                                Navigator.pop(context);
                                                Get.to(() =>
                                                    const CreateProductListing());
                                              },
                                            );
                                          } else if (index == 1) {
                                            return ListTile(
                                              leading: SvgPicture.asset(
                                                'assets/svgs/addservice.svg',
                                                colorFilter:
                                                    const ColorFilter.mode(
                                                  Colors.black,
                                                  BlendMode.srcIn,
                                                ),
                                                height: 24,
                                              ),
                                              subtitle: const Text(
                                                  'To showcase your services in biz-centre & marketplace'),
                                              title: const Text(
                                                'Add Service',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              horizontalTitleGap: 0.0,
                                              onTap: () {
                                                Navigator.pop(context);
                                                Get.to(() =>
                                                    const CreateServiceListing());
                                              },
                                            );
                                          } else {
                                            return ListTile(
                                              subtitle: const Text(
                                                  'To showcase your portfolio, demo or affiliate links '),
                                              leading: const Icon(
                                                Icons.add,
                                                color: Colors.black,
                                                size: 24,
                                              ),
                                              title: const Text(
                                                'Add Custom Item',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              horizontalTitleGap: 0.0,
                                              onTap: () {
                                                Navigator.pop(context);
                                                Get.to(() =>
                                                    const CreateCustomListing());
                                              },
                                            );
                                          }
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                        itemCount: 3,
                                      ),
                                    );
                                  },
                                );
                              } else if (index == 1) {
                                Get.to(() => const CreateOrder());
                              } else if (index == 2) {
                                Get.to(() => const Addclient());
                              }
                            },
                            child: QuickActionCard(
                                cardName: quickactions[index],
                                value: index == 0
                                    ? clientsController.allclients.length
                                        .toString()
                                    : '0',
                                color: index == 0
                                    ? Colors.black
                                    : index == 1
                                        ? Colors.orange
                                        : Colors.purple,
                                assetlocation: index == 0
                                    ? 'assets/svgs/plus.svg'
                                    : index == 1
                                        ? 'assets/svgs/addorder.svg'
                                        : index == 2
                                            ? 'assets/svgs/addclient.svg'
                                            : ''),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
