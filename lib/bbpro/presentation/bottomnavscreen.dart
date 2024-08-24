import 'package:business_bosses_v2/bbpro/presentation/clients.dart';
import 'package:business_bosses_v2/bbpro/presentation/dashboard.dart';
import 'package:business_bosses_v2/bbpro/presentation/ordersandinvoices.dart';
import 'package:business_bosses_v2/bbpro/presentation/projects.dart';
import 'package:business_bosses_v2/bbpro/presentation/setup.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Bottomnavscreen extends StatefulWidget {
  const Bottomnavscreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BottomnavscreenState createState() => _BottomnavscreenState();
}

class _BottomnavscreenState extends State<Bottomnavscreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Projects(),
    ClientsScreen(),
    OrdersScreen(),
    Setup(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/clients.svg',
                height: 20,
                color: _selectedIndex == 2
                    ? proprimaryColor
                    : const Color(0xffBDBEC0)),
            label: 'Clients',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/svgs/ordersinvoices.svg',
                height: 20,
                color: _selectedIndex == 3
                    ? proprimaryColor
                    : const Color(0xffBDBEC0)),
            label: 'Orders & Invoices',
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
    );
  }
}
