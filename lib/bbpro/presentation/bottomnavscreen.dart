import 'package:business_bosses_v2/bbpro/controllers/clients_controller.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/presentation/clients.dart';
import 'package:business_bosses_v2/bbpro/presentation/dashboard.dart';
import 'package:business_bosses_v2/bbpro/presentation/ordersandinvoices.dart';
import 'package:business_bosses_v2/bbpro/presentation/projects.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup.dart';
import 'package:business_bosses_v2/bbpro/presentation/setupshop.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Bottomnavscreen extends StatefulWidget {
  final int? initialindex;
  const Bottomnavscreen({super.key, this.initialindex});

  @override
  // ignore: library_private_types_in_public_api
  _BottomnavscreenState createState() => _BottomnavscreenState();
}

class _BottomnavscreenState extends State<Bottomnavscreen> {
  final ShopController shopController = Get.put(ShopController());
  final ClientsController clientsController = Get.put(ClientsController());
  final ProfileController profileController = Get.put(ProfileController());
  late int _selectedIndex;

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Projects(),
    OrdersScreen(),
    ClientsScreen(),
    Setup(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialindex ?? 0;
    shopController.initShop().then((bool value) {
      if (value) {
        shopController.loading(false);
      } else {
        Get.to(const Setupshop());
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/svgs/dashboard.svg',
                      height: 20,
                      color: _selectedIndex == 0
                          ? proprimaryColor
                          : const Color(0xffBDBEC0),
                    ),
                    label: 'Dashboard',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/svgs/projects.svg',
                        height: 20,
                        color: _selectedIndex == 1
                            ? proprimaryColor
                            : const Color(0xffBDBEC0)),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/svgs/ordersinvoices.svg',
                        height: 20,
                        color: _selectedIndex == 2
                            ? proprimaryColor
                            : const Color(0xffBDBEC0)),
                    label: 'Orders',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/svgs/clients.svg',
                        height: 20,
                        color: _selectedIndex == 3
                            ? proprimaryColor
                            : const Color(0xffBDBEC0)),
                    label: 'Clients',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset('assets/svgs/setupshop.svg',
                        height: 20,
                        color: _selectedIndex == 4
                            ? proprimaryColor
                            : const Color(0xffBDBEC0)),
                    label: 'Set Up',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: proprimaryColor,
                unselectedItemColor: Colors.grey,
                onTap: _onItemTapped,
              ),
            ),
          ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
