import 'package:business_bosses_v2/bbpro/common/widgets/button.dart';
import 'package:business_bosses_v2/bbpro/common/widgets/progresstabbar.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProSetup(),
    );
  }
}

class ProSetup extends StatefulWidget {
  @override
  _ProSetupState createState() => _ProSetupState();
}

class _ProSetupState extends State<ProSetup>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = [
    '1. Shop Profile',
    '2. Contact Details',
    '3. Payments'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  void _nextPage() {
    if (_tabController.index < _tabs.length - 1) {
      setState(() {
        _tabController.index += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: probackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Set Up Shop'),
      ),
      body: Stack(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ProgressTabBar(
                tabs: _tabs,
                currentIndex: _tabController.index,
              ),
            ),
            Expanded(
              child: TabBarView(controller: _tabController, children: [
                Text('data'),
                Text('data'),
                Text('data'),
              ]),
            ),
          ],
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 30,
            child: ProCustomButton(
              text: 'Next',
              onPressed: () {
                _nextPage();
              },
              icon: Icon(Icons.navigate_next, size: 20,),
            ))
      ]),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
