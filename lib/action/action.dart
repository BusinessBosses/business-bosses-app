// ignore_for_file: public_member_api_docs

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../common/models/my_response.dart';
import '../functions/my_native_functions.dart';
import '../utils/constants/constants.dart';

void showSnackBar(BuildContext context, {String message = Constants.STGW}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<dynamic> navigateTo(
  BuildContext context, {
  String? routeName,
  dynamic arguments,
  bool isRemoveUntil = false,
}) async {
  // print("=====>>>> $routeName");
  if (routeName == null) {
    // print('+++++++ pop');
    Navigator.of(context).pop(arguments);
  } else if (isRemoveUntil) {
    return await Navigator.of(context).pushNamedAndRemoveUntil(
        // ignore: always_specify_types
        routeName,
        // ignore: always_specify_types
        (Route route) => false,
        arguments: arguments);
  } else {
    return await Get.toNamed(routeName, arguments: arguments);
  }
}

Future<dynamic> navigateWithReplaceTo(BuildContext context,
    {required String routeName, dynamic arguments}) async {
  return await Navigator.of(context)
      .pushReplacementNamed(routeName, arguments: arguments);
}

void unFocusKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

Future<void> onDetectableTextTap(
  BuildContext context,
  String val,
) async {
  // debugPrint(val);
  if (val.startsWith('#')) {
    showSnackBar(context, message: val);
    // debugPrint('DetectableText >>>>>>> #');
  } else if (val.startsWith('@')) {
    // debugPrint('DetectableText >>>>>>> @');
  } else if (val.startsWith('http')) {
    // debugPrint('DetectableText >>>>>>> http');
    MyResponse res = await MyNativeFunctions.onUrlLaunch(val);
    {
      if (!res.success) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, message: res.message);
      }
    }
  }
  // showSnackBar(context, message: val);
}

Future<void> socialShare(String message) async {
  try {
    // grab the nearest context via GetX
    final BuildContext? ctx = Get.context;
    // on iPads (large screens) Share.share requires an origin rect, so we derive it if we can
    final RenderBox? box = ctx?.findRenderObject() as RenderBox?;

    await Share.share(
      message,
      sharePositionOrigin:
          box != null ? box.localToGlobal(Offset.zero) & box.size : null,
    );
  } catch (e) {
    debugPrint('Error sharing content: $e');
    // optional: surface an error to the user
    if (Get.context != null) {
      showSnackBar(Get.context!, message: 'Couldn’t share content');
    }
  }
}

void logEvent(dynamic id, dynamic type) async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'share',
    parameters: <String, Object>{
      'content_id': id,
      'content_type': type,
    },
  );
}
