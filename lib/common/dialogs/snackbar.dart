import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackbar({String? message, String? title}) {
  Get.showSnackbar(GetSnackBar(
    snackPosition: SnackPosition.TOP,
    dismissDirection: DismissDirection.horizontal,
    backgroundColor: primaryColorLT,
    message: message,
    title: title,
  ));
}
