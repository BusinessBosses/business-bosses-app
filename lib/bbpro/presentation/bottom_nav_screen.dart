// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Bottomnavscreen extends StatefulWidget {
  final int? initialindex;
  final void Function(int)? onTabChanged;
  final bool noBack;
  const Bottomnavscreen({
    super.key,
    this.initialindex,
    this.onTabChanged,
    this.noBack = true,
  });

  // ignore: library_private_types_in_public_api
  static _BottomnavscreenState? of(BuildContext context) =>
      context.findAncestorStateOfType<_BottomnavscreenState>();

  @override
  // ignore: library_private_types_in_public_api
  _BottomnavscreenState createState() => _BottomnavscreenState();
}

class _BottomnavscreenState extends State<Bottomnavscreen> {
  final ShopController shopController = Get.find();
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
      if (!profileController.myProfile.hasShop) {
        Get.off(() => const Setupshop(
              backToHome: true,
            ));
      } else {
        if (value) {
          shopController.loading(false);
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
        : PopScope(
            canPop: true, // Set false to block back navigation
            onPopInvokedWithResult: (bool didPop, dynamic result) async {
              if (!didPop) {
                await _onWillPop(); // Custom logic on back press
              }
            },
            child: Scaffold(
              body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
              bottomNavigationBar: Container(
                height: 83.0,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      spreadRadius: 10,
                      blurRadius: 50,
                      offset: const Offset(0, 7), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 83.0,
                      padding: const EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 10,
                              child: BottomTabButton(
                                icon: _selectedIndex == 7
                                    ? 'assets/svgs/dashboard.svg'
                                    : 'assets/svgs/dashboard.svg',
                                label: 'Home',
                                onTap: () {
                                  Get.offAllNamed(Routes.marketPlace);
                                },
                                isActive: _selectedIndex == 7,
                              )),
                          Expanded(
                              flex: 10,
                              child: BottomTabButton(
                                icon: _selectedIndex == 0
                                    ? 'assets/svgs/dashboard.svg'
                                    : 'assets/svgs/dashboard.svg',
                                label: 'Dashboard',
                                onTap: () => _onItemTapped(0),
                                isActive: _selectedIndex == 0,
                              )),
                          // Expanded(
                          //   flex: 10,
                          //   child: BottomTabButton(
                          //     icon: _selectedIndex == 2
                          //         ? 'assets/svgs/projects.svg'
                          //         : 'assets/svgs/projects.svg',
                          //     label: 'Tasks',
                          //     onTap: () => _onItemTapped(2),
                          //     isActive: _selectedIndex == 2,
                          //   ),
                          // ),
                          Expanded(
                            flex: 10,
                            child: BottomTabButton(
                              icon: _selectedIndex == 2
                                  ? 'assets/svgs/ordersinvoices.svg'
                                  : 'assets/svgs/ordersinvoices.svg',
                              label: 'Leads',
                              onTap: () => _onItemTapped(2),
                              isActive: _selectedIndex == 2,
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: BottomTabButton(
                              icon: _selectedIndex == 3
                                  ? 'assets/svgs/clients.svg'
                                  : 'assets/svgs/clients.svg',
                              label: 'Customers',
                              onTap: () => _onItemTapped(3),
                              isActive: _selectedIndex == 3,
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: BottomTabButton(
                              icon: _selectedIndex == 4
                                  ? 'assets/svgs/setupshop.svg'
                                  : 'assets/svgs/setupshop.svg',
                              label: 'Set Up',
                              onTap: () => _onItemTapped(4),
                              isActive: _selectedIndex == 4,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class BottomTabButton extends StatelessWidget {
  const BottomTabButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.isActive,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          label == 'Home'
              ? Container(
                  width: 35.0,
                  height: 25.0,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/app_logo_2.png',
                  ),
                )
              : SvgPicture.asset(
                  icon,
                  height: 21,
                  colorFilter: ColorFilter.mode(
                    isActive ? proprimaryColor : textColor,
                    BlendMode.srcIn,
                  ),
                ),
          const SizedBox(height: 4),
          Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                if (label == 'Home')
                  Icon(
                    LucideIcons.chevronLeft,
                    size: 15,
                  ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                    color: isActive ? proprimaryColor : textColor,
                  ),
                ),
              ]),
        ],
      ),
    );
  }
}
