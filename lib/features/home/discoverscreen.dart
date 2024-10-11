import 'package:business_bosses_v2/features/home/widgets/discoversection.dart';
import 'package:business_bosses_v2/features/home/widgets/searchsection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: const Text(
          'Discover',
          textAlign: TextAlign.center,
        ),
      ),
      body: const Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: SearchSection(),
          ),
          Expanded(child: DiscoverSection()),
        ],
      ),
    );
  }
}
