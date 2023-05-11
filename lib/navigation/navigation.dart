// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/features/authentication/presentation/forgot_password_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/login_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/register_screen.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/notifications/notificationsscreen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/code_verification_screen.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/profile/analysescreen.dart';
import 'package:business_bosses_v2/features/profile/myprofilescreen.dart';
import 'package:business_bosses_v2/features/profile/promotionscreen.dart';
import 'package:business_bosses_v2/features/profile/update_profile_screen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';

import 'package:business_bosses_v2/navigation/routes.dart';

import 'package:get/get.dart';

///NAV INITIALIZATIONS
class Nav {
  /// ROUTE LISTS
  static List<GetPage> routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.registration,
      page: () => RegisterScreen(),
    ),
    GetPage(
      name: Routes.createPost,
      page: () => const CreatePostScreen(),
    ),
    GetPage(
      name: Routes.myProfile,
      page: () => const MyProfileScreen(),
    ),
    GetPage(
      name: Routes.bossuppartner,
      page: () => const Bossuppartner(),
    ),
    GetPage(
      name: Routes.bottomNavigation,
      page: () => const BottomNavScreen(),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => NotificationsScreen(),
    ),
    GetPage(
      name: Routes.promotionscreen,
      page: () => const PromotionScreen(),
    ),
    GetPage(
      name: Routes.analysescreen,
      page: () => const AnalyserScreen(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: Routes.updateProfile,
      page: () => const UpdateProfileScreen(),
    ),
    GetPage(
      name: Routes.resetPassword,
      page: () => const ForgotPasswordScreen(),
    ),
  ];
}
