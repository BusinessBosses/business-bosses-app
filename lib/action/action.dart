// ignore_for_file: public_member_api_docs

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_share/social_share.dart';

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
  var arguments,
  bool isRemoveUntil = false,
}) async {
  // print("=====>>>> $routeName");
  if (routeName == null) {
    // print('+++++++ pop');
    Navigator.of(context).pop(arguments);
  } else if (isRemoveUntil) {
    return await Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (Route route) => false,
        arguments: arguments);
  } else {
    return await Get.toNamed(routeName, arguments: arguments);
  }
}

Future<dynamic> navigateWithReplaceTo(BuildContext context,
    {required String routeName, var arguments}) async {
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
        showSnackBar(context, message: res.message);
      }
    }
  }
  // showSnackBar(context, message: val);
}

Future<void> socialShare(String message) async {
  // debugPrint('socialShare: $message');
  try {
    await SocialShare.shareOptions(message);
    // debugPrint('socialShare: $data');
    // if (data == null || !data) {
    //   return MyResponse(success: false);
    // } else {
    //   return MyResponse(success: true);
    // }
  } catch (e) {
    // debugPrint('socialShare: $e');
    // return MyResponse(success: false, message: e.toString());
  }
}

logEvent(dynamic id, dynamic type) async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'share',
    parameters: <String, dynamic>{
      'content_id': id,
      'content_type': type,
    },
  );
}
