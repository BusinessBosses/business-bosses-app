import 'package:business_bosses_v2/navigation/navigation.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/firebase_analytics.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
  await dotenv.load();
  await Firebase.initializeApp();
  AnalyticsServices();
  Stripe.publishableKey =
      'pk_test_51MAcspEGsMsi6baUQ14KJlYZVcpaKiRtC5wnN42Jq3vOl68JwSahkzoiUOrOh9zGyG9nDj1bML8jOlfwMDai51Rm00vWZoIAgE';

  FirebaseMessaging.instance.getToken().then((String? value) {
    print(value);
  });

  /// BACKGROUND HANDLER
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    Navigator.pushNamed(
      navigatorKey.currentState!.context,
      Routes.notifications,
    );
  });

  /// TERMINATED HANDLER
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) async {
    if (message != null) {
      Navigator.pushNamed(
        navigatorKey.currentState!.context,
        Routes.notifications,
      );
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// MAIN APP CLASS
class MyApp extends StatelessWidget {
  /// MAIN APP CONSTRUCTOR
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    // ignore: always_specify_types
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        final SharedPreferences? data = snapshot.data;
        if (snapshot.hasData) {
          final String? userId = data!.getString(Constants.USER_ID);

          return GetMaterialApp(
            navigatorObservers: <NavigatorObserver>[
              AnalyticsServices.getAnalyticObserver()
            ],
            navigatorKey: navigatorKey,
            initialRoute: userId == '' || userId == null
                ? Routes.login
                : Routes.bottomNavigation,

            // initialRoute: Routes.updateProfile,
            getPages: Nav.routes,
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            title: 'Business Bosses',
          );
        } else {
          return Container();
        }
      },
    );
  }
}
