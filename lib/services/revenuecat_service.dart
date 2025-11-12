import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  /// Call this right after user logs in
  static Future<void> login(String appUserId) async {
    try {
      await Purchases.logIn(appUserId);
      debugPrint('RevenueCat login successful for user: $appUserId');
    } catch (e) {
      debugPrint('RevenueCat login error: $e');
    }
  }

  /// Call this when user logs out
  static Future<void> logout() async {
    try {
      await Purchases.logOut();
      debugPrint('RevenueCat logout successful');
    } catch (e, st) {
      log('RevenueCat logout error: $e', stackTrace: st);
    }
  }
}
