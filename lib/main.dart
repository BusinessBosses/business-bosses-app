import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/features/chat/presentation/call_page.dart';
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
import 'package:uni_links/uni_links.dart';

final PurchasesConfiguration _configuration = Platform.isIOS
    ? PurchasesConfiguration('appl_fpKOUqIrKWZpOCQbxcYdfiIMgjj')
    : PurchasesConfiguration('goog_qVanRlWurUpdIwIedERNnNDBVaE');
bool _initialURILinkHandled = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Purchases.configure(_configuration);
  await GetStorage.init();
  await dotenv.load();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();

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
      } else if (title != null && title.contains('Incoming Call')) {
        // Extract custom data payload
        String type = message.data['type'];
        String callID = message.data['callId'];
        String userId = message.data['userId'];
        String username = message.data['username'];

        // Check the type of message
        if (type == 'incoming_call') {
          // Display incoming call UI and join Zegocloud room using callId
          Get.to(() =>
              CallPage(callID: callID, userId: userId, username: username));
        }
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
      } else if (title != null && title.contains('Incoming Call')) {
        // Extract custom data payload
        String type = message.data['type'];
        String callID = message.data['callId'];
        String userId = message.data['userId'];
        String username = message.data['username'];

        // Check the type of message
        if (type == 'incoming_call') {
          // Display incoming call UI and join Zegocloud room using callId
          Get.to(() =>
              CallPage(callID: callID, userId: userId, username: username));
        }
      } else {
        Get.toNamed(
          Routes.notifications,
        );
      }
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
  await initUniLinks();
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
    } else {}
  }, onError: (err) {
    print(err);
  });
}

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
          Routes.home,
        );
      }
    }
  }
}

void processPostDeeplink(Uri uri) {
  log(uri.toString());
  Fluttertoast.showToast(
    msg: 'Welcome back to BusinessBosses',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
  );
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

    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder:
          (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        final SharedPreferences? data = snapshot.data;
        if (snapshot.hasData) {
          final String? userId = data!.getString(Constants.USER_ID);

          String initialRoute =
              userId == '' || userId == null ? Routes.login : Routes.home;

          return GetMaterialApp(
            key: navigatorKey, // Set the GlobalKey
            navigatorObservers: <NavigatorObserver>[
              AnalyticsServices.getAnalyticObserver(),
            ],
            debugShowCheckedModeBanner: false,
            theme: appTheme,
            title: 'Business Bosses',
            initialRoute: initialRoute,
            getPages: routes,
          );
        } else {
          return Container();
        }
      },
    );
  }
}
