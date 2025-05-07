import 'dart:async';
import 'dart:developer';
import 'dart:io';

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
import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';

final PurchasesConfiguration _configuration = Platform.isIOS
    ? PurchasesConfiguration('appl_fpKOUqIrKWZpOCQbxcYdfiIMgjj')
    : PurchasesConfiguration('goog_qVanRlWurUpdIwIedERNnNDBVaE');

final AppLinks _appLinks = AppLinks();
bool _initialAppLinkHandled = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Purchases.configure(_configuration);
  await GetStorage.init();
  await dotenv.load();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();

  AnalyticsServices();
  Stripe.publishableKey = dotenv.env['STRIPE_PUB_KEY']!;
  Stripe.merchantIdentifier = 'merchant.businessbosses';

  FirebaseMessaging.instance.getToken();
  FirebaseMessaging.instance.requestPermission();

  FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
  FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
  await initAppLinks();
  FlutterNativeSplash.remove();
}

/// INITIALIZE DEEP LINKING VIA app_links
Future<void> initAppLinks() async {
  // handle initial link only once
  if (!_initialAppLinkHandled) {
    _initialAppLinkHandled = true;
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        processDeepLink(initialUri);
        processPostDeeplink(initialUri);
      }
    } on PlatformException {
      // ignore errors
    }
  }

  // listen for subsequent links
  _appLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      log('Received deep link: $uri');
      processDeepLink(uri);
      processPostDeeplink(uri);
    }
  }, onError: (dynamic err) {
    log('Error listening for deep links: $err');
  });
}

void _handleMessageOpenedApp(RemoteMessage? message) {
  if (message?.notification == null) return;
  final String? title = message!.notification!.title?.toLowerCase();
  if (title != null && title.contains('new message')) {
    Get.toNamed(Routes.chat);
  } else {
    Get.toNamed(Routes.notifications);
  }
}

void _handleInitialMessage(RemoteMessage? message) {
  _handleMessageOpenedApp(message);
}

/// PROCESS DEEPLINK
void processDeepLink(Uri uri) {
  log('processDeepLink: $uri');
  if (uri.scheme == 'myapp' && uri.host == 'app.subscription') {
    final String? successParam = uri.queryParameters['success'];
    final String? cancelParam = uri.queryParameters['cancel'];
    if (successParam != null) {
      final bool success = successParam.toLowerCase() == 'true';
      if (success) {
        Get.toNamed(Routes.subscriptionconfirmation);
      } else {
        Get.snackbar('Canceled', 'Transaction Canceled');
      }
    }
    if (cancelParam != null) {
      Get.toNamed(Routes.settings);
    }
  } else if (uri.scheme == 'myapp' && uri.host == 'app.notification') {
    final String? type = uri.queryParameters['type'];
    if (type != null && type.toLowerCase() == 'message') {
      Get.toNamed(Routes.home);
    }
  }
}

void processPostDeeplink(Uri uri) async {
  log('processPostDeeplink: $uri');

  Fluttertoast.showToast(
    msg: 'Welcome back to BusinessBosses',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
  );

  if (uri.queryParameters.isNotEmpty) {
    final String orderId = uri.queryParameters['orderId']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId);
    await prefs.setBool('visited', false);
    return;
  }

  if (uri.scheme == 'myapp' && uri.host == 'app.post') {
    navigatorKey.currentState?.pushNamed(Routes.home);
  } else {
    navigatorKey.currentState?.pushNamed(Routes.referscreen);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) return Container();
        final SharedPreferences prefs = snapshot.data!;
        final String? userId = prefs.getString(Constants.USER_ID);
        final String? token = prefs.getString(Constants.ACCESS_TOKEN);

        final String initialRoute =
            (userId == null || userId.isEmpty || token == null || token.isEmpty)
                ? Routes.login
                : Routes.home;

        return GetMaterialApp(
          key: navigatorKey,
          navigatorObservers: <NavigatorObserver>[
            AnalyticsServices.getAnalyticObserver()
          ],
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          title: 'Business Bosses',
          initialRoute: initialRoute,
          getPages: routes,
        );
      },
    );
  }
}
