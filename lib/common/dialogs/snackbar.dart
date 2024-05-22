import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar({String? message, String? title, bool error = false}) {
  Get.showSnackbar(
    GetSnackBar(
      snackPosition: SnackPosition.TOP,
      dismissDirection: DismissDirection.horizontal,
      backgroundColor: error ? Colors.red : Colors.green,
      message: message,
      title: title,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      borderRadius: 10,
      duration: const Duration(seconds: 3),
      // padding: EdgeInsets.symmetric(vertical: 5),
    ),
  );
}
