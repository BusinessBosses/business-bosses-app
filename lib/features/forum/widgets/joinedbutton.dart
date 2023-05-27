import 'package:flutter/material.dart';

Widget JoinedButton(bool joined, VoidCallback onTap) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(joined ? 'Leave' : 'Join',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ),
    ),
  );
}
