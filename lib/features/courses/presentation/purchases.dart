import 'package:flutter/material.dart';

class Purchases extends StatefulWidget {
  const Purchases({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: 5,
          itemBuilder: (BuildContext context, int i) {
            return Text('data');
          },
        ),
      ]),
    );
  }
}
