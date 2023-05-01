import 'package:business_bosses_v2/navigation/navigation.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/services/firebase_analytics.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await dotenv.load();
  await Firebase.initializeApp();
  AnalyticsServices();
  Stripe.publishableKey =
      'pk_test_51MAcspEGsMsi6baUQ14KJlYZVcpaKiRtC5wnN42Jq3vOl68JwSahkzoiUOrOh9zGyG9nDj1bML8jOlfwMDai51Rm00vWZoIAgE';
  runApp(const MyApp());
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
    final GetStorage sandBox = GetStorage();
    sandBox.writeIfNull(Constants.USER_ID, '');
    return SimpleBuilder(
      builder: (_) {
        final String userId = sandBox.read(Constants.USER_ID);
        return GetMaterialApp(
          navigatorObservers: <NavigatorObserver>[
            AnalyticsServices.getAnalyticObserver()
          ],
          initialRoute:
              userId.isEmpty ? Routes.settings : Routes.bottomNavigation,
          getPages: Nav.routes,
          debugShowCheckedModeBanner: false,
          theme: appTheme,
          title: 'Business Bosses',
        );
      },
    );
  }
}
