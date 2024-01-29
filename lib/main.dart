import 'dart:async';
import 'dart:developer';

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
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

final _configuration =
    PurchasesConfiguration('appl_fpKOUqIrKWZpOCQbxcYdfiIMgjj');

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Purchases.configure(_configuration);
  await GetStorage.init();
  await dotenv.load();
  await Firebase.initializeApp();
  await initUniLinks();
  // await firebaseInitUniLinks();
  AnalyticsServices();
  Stripe.publishableKey =
      'pk_live_51MAcspEGsMsi6baUVnDR3Vlfh14vm73Oz9Z4LwYcvzOTdd6AvRRHrGCkpIoYmTfe2iSXm7ju2RQtO4UYJTvodFPR008RO7V1j3';
  Stripe.merchantIdentifier = 'merchant.businessbosses';

  Stripe.publishableKey =
      'pk_live_51MAcspEGsMsi6baUVnDR3Vlfh14vm73Oz9Z4LwYcvzOTdd6AvRRHrGCkpIoYmTfe2iSXm7ju2RQtO4UYJTvodFPR008RO7V1j3';

  FirebaseMessaging.instance.getToken().then((String? value) {
    // print(value);
  });

  FirebaseMessaging.instance.requestPermission();

  /// BACKGROUND HANDLER
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) async {
    if (message != null && message.notification != null) {
      String? title = message.notification!.title?.toLowerCase();
      if (title != null && title.contains('new message')) {
        Get.toNamed(
          Routes.chat,
        );
      } else {
        Get.toNamed(
          Routes.notifications,
        );
      }
    }
  });

  /// TERMINATED HANDLER
  FirebaseMessaging.instance
      .getInitialMessage()
      .then((RemoteMessage? message) async {
    if (message != null && message.notification != null) {
      String? title = message.notification!.title?.toLowerCase();
      if (title != null && title.contains('new message')) {
        Get.toNamed(
          Routes.chat,
        );
      } else {
        Get.toNamed(
          Routes.notifications,
        );
      }
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

// / INITIALIZE DEEP LINKING
Future<void> initUniLinks() async {
  try {
    final String? initialLink = await getInitialLink();
    if (initialLink != null) {
      processDeepLink(Uri.parse(initialLink));
      processPostDeeplink(Uri.parse(initialLink));
    }
  } on PlatformException {}

  uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      processDeepLink(uri);
      processPostDeeplink(uri);
    } else {
      // print('sdfsadfa');
    }
  }, onError: (err) {
    print(err);
  });
}

// Future<void> initUniLinks() async {
//   try {
//     final String? initialLink = await getInitialLink();
//     if (initialLink != null) {
//       processPostDeeplink(Uri.parse(initialLink));
//     }
//   } on PlatformException {}

//   uriLinkStream.listen((Uri? uri) {
//     if (uri != null) {
//       processPostDeeplink(uri);
//     }
//   }, onError: (err) {
//     print(err);
//   });
// }

/// PROCESS DEEPLINK
void processDeepLink(Uri uri) {
  log(uri.toString());
  if (uri.scheme == 'myapp' && uri.host == 'app.subscription') {
    String? successParam = uri.queryParameters['success'];
    String? cancelParam = uri.queryParameters['cancel'];

    if (successParam != null) {
      bool success = successParam.toLowerCase() == 'true';
      if (success) {
        Get.toNamed(
          Routes.subscriptionconfirmation,
        );
      } else {
        Get.snackbar('Canceled', 'Transaction Canceled');
      }
    }

    if (cancelParam != null) {
      Get.toNamed(
        Routes.settings,
      );
    }
  } else if (uri.scheme == 'myapp' && uri.host == 'app.notification') {
    String? notificationParam = uri.queryParameters['type'];

    if (notificationParam != null) {
      bool success = notificationParam.toLowerCase() == 'message';
      if (success) {
        Get.toNamed(
          Routes.bottomnavscreen,
        );
      }
    }
  } else if (uri.scheme == 'https' && uri.host == 'app.main') {
    String? notificationParam = uri.queryParameters['type'];
    if (notificationParam != null) {
      bool success = notificationParam.toLowerCase() == 'message';
      if (success) {
        // showAboutDialog(context: Get.context!);
        // Get.toNamed(Routes.login);
      }
    }
  }
}

/// PROCESS DEEPLINK
void processPostDeeplink(Uri uri) {
  log(uri.toString());
  if (uri.scheme == 'myapp' && uri.host == 'app.post') {
    Get.toNamed(
      Routes.home,
    );
  } else if (uri.scheme == 'myapp' && uri.host == 'app.refer') {
    Get.toNamed(
      Routes.referalsscreen,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// / MAIN APP CLASS
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
            // navigatorKey: navigatorKey,
            initialRoute: userId == '' || userId == null
                ? Routes.login
                : Routes.bottomnavscreen,

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
