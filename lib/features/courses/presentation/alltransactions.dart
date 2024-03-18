import 'package:flutter/material.dart';

class AllTransactions extends StatefulWidget {
  const AllTransactions({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
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
