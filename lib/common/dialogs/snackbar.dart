import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackbar({String? message, String? title, bool error = false}) {
  Get.showSnackbar(
    GetSnackBar(
      snackPosition: SnackPosition.TOP,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: error ? Colors.red : Colors.green,
      message: message,
      title: title,
      margin: EdgeInsets.symmetric(horizontal: 20),
      borderRadius: 10,
      duration: Duration(seconds: 3),
      // padding: EdgeInsets.symmetric(vertical: 5),
    ),
  );
}
