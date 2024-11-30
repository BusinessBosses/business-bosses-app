import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProshopdealsScreen extends StatefulWidget {
  const ProshopdealsScreen({super.key});

  @override
  State<ProshopdealsScreen> createState() => _ProshopdealsScreenState();
}

class _ProshopdealsScreenState extends State<ProshopdealsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text('Pro Users\' Shop'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'All'),
            Tab(text: 'Products'),
            Tab(text: 'Services'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(child: Text('All Deals')),
          Center(child: Text('Product Deals')),
          Center(child: Text('Service Deals')),
        ],
      ),
    );
  }
}
