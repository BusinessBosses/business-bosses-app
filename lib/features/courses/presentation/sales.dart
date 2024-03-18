import 'package:flutter/material.dart';

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
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
