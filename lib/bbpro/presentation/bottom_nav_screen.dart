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
        Get.to(() => const Setupshop(
              backToHome: true,
            ));
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
              bottomNavigationBar: SizedBox(
                height: 83,
                child: BottomNavigationBar(
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/svgs/dashboard.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          _selectedIndex == 0
                              ? proprimaryColor
                              : const Color(0xffBDBEC0),
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Dashboard',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/svgs/projects.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          _selectedIndex == 1
                              ? proprimaryColor
                              : const Color(0xffBDBEC0),
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/svgs/ordersinvoices.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          _selectedIndex == 2
                              ? proprimaryColor
                              : const Color(0xffBDBEC0),
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Orders',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/svgs/clients.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          _selectedIndex == 3
                              ? proprimaryColor
                              : const Color(0xffBDBEC0),
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Customers',
                    ),
                    BottomNavigationBarItem(
                      icon: SvgPicture.asset(
                        'assets/svgs/setupshop.svg',
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          _selectedIndex == 4
                              ? proprimaryColor
                              : const Color(0xffBDBEC0),
                          BlendMode.srcIn,
                        ),
                      ),
                      label: 'Set Up',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: proprimaryColor,
                  unselectedItemColor: Colors.grey,
                  onTap: _onItemTapped,
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
