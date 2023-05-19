import 'package:flutter/material.dart';

Widget JoinedButton() {
  return GestureDetector(
    onTap: () {},
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
            '_industry?.joinedUsers?.contains(_firebase.uid)' == 'true'
                ? 'Leave'
                : 'Join',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      ),
    ),
  );
}
