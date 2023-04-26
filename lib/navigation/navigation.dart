// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/features/authentication/presentation/login_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/register_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
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
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: Routes.createPost,
      page: () => const CreatePostScreen(),
    ),
  ];
}
