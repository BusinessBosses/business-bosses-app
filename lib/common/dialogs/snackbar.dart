import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar({String? message, String? title, bool error = false}) {
  // Get.showSnackbar pushes onto the root navigator via `Get.key.currentState!`.
  // Called before GetMaterialApp is mounted or after it is torn down — a
  // background fetch finishing during app exit, a failed request on a screen
  // the user already left — that `!` throws "Null check operator used on a
  // null value" or the contextless-navigation error. Neither is worth
  // crashing over: drop the toast instead.
  if (Get.key.currentState == null || Get.overlayContext == null) {
    debugPrint('Snackbar suppressed (no overlay): $title - $message');
    return;
  }

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
