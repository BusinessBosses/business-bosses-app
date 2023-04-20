import 'package:firebase_analytics/firebase_analytics.dart';

/// FIREBASE ANALYTICS CLASS
class AnalyticsServices {
  /// FIREBASE ANALYTICS INSTANCE
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  /// GET FITEBASE ANALYTICS OBSERVER
  static FirebaseAnalyticsObserver getAnalyticObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);
}
