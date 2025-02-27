import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/clients.dart';
import 'package:business_bosses_v2/bbpro/presentation/dashboard.dart';
import 'package:business_bosses_v2/bbpro/presentation/orders_and_invoices.dart';
import 'package:business_bosses_v2/bbpro/presentation/projects.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Bottomnavscreen extends StatefulWidget {
  final int? initialindex;
  final void Function(int)? onTabChanged;
  final bool noBack;
  const Bottomnavscreen({
    super.key,
    bottomNavScreenKey,
    this.initialindex,
    this.onTabChanged,
    this.noBack = true,
  });

  static _BottomnavscreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BottomnavscreenState>();

  @override
  // ignore: library_private_types_in_public_api
  _BottomnavscreenState createState() => _BottomnavscreenState();
}

class _BottomnavscreenState extends State<Bottomnavscreen> {
  final ShopController shopController =
      Get.put(ShopController(), permanent: true);
  final ClientsController clientsController = Get.put(ClientsController());
  final ProfileController profileController = Get.put(ProfileController());
  late int _selectedIndex;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (widget.onTabChanged != null) {
      widget.onTabChanged!(index);
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _onItemTapped(index);
    });
  }

  static List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialindex ?? 0;
    _widgetOptions = <Widget>[
      Dashboard(noBack: widget.noBack),
      const Projects(),
      const OrdersScreen(),
      const ClientsScreen(),
      const Setup(),
    ];
    shopController.initShopData().then((bool value) {
      if (value) {
        shopController.loading(false);
      } else {
        if (!profileController.myProfile.hasShop) {
          Get.to(() => const Setupshop(
                backToHome: true,
              ));
        }
      }
    });
  }

  Future<bool> _onWillPop() async {
    final dynamic newIndex = Get.arguments;
    if (newIndex != null && newIndex is int) {
      setState(() {
        _selectedIndex = newIndex;
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => shopController.loading.value
        ? const SafetyModel(isLoading: true)
        : WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              body: Center(
                child: _widgetOptions.elementAt(_selectedIndex),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      spreadRadius: 10,
                      blurRadius: 50,
                      offset: const Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 5,
                      color: Colors.white,
                    ),
                    BottomNavigationBar(
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                      selectedLabelStyle: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                        color: proprimaryColor,
                      ),
                      elevation: 0,
                      backgroundColor: Colors.white,
                      type: BottomNavigationBarType.fixed,
                      unselectedItemColor: textColor,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: SvgPicture.asset(
                              'assets/svgs/dashboard.svg',
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 0
                                    ? proprimaryColor
                                    : textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          label: 'Dashboard',
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: SvgPicture.asset(
                              'assets/svgs/projects.svg',
                              height: 23,
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 1
                                    ? proprimaryColor
                                    : textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          label: 'Tasks',
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: SvgPicture.asset(
                              'assets/svgs/ordersinvoices.svg',
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 2
                                    ? proprimaryColor
                                    : textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          label: 'Orders',
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: SvgPicture.asset(
                              'assets/svgs/clients.svg',
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 3
                                    ? proprimaryColor
                                    : textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          label: 'Customers',
                        ),
                        BottomNavigationBarItem(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: SvgPicture.asset(
                              'assets/svgs/setupshop.svg',
                              height: 25,
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 4
                                    ? proprimaryColor
                                    : textColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          label: 'Set Up',
                        ),
                      ],
                      currentIndex: _selectedIndex,
                      selectedItemColor: proprimaryColor,
                      onTap: _onItemTapped,
                    ),
                    Container(
                      height: 18,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
