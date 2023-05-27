// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/features/authentication/presentation/forgot_password_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/login_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/register_screen.dart';
import 'package:business_bosses_v2/features/chat/chat_room_screen.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/connects/presentation/all_connections_screen.dart';
import 'package:business_bosses_v2/features/forum/controller/create_forum_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_forum_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_forum_screen.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/notifications/notificationsscreen.dart';
import 'package:business_bosses_v2/features/home/bottom_nav.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/post_details_screen.dart';
import 'package:business_bosses_v2/features/profile/analysescreen.dart';
import 'package:business_bosses_v2/features/profile/change_password_screen.dart';
import 'package:business_bosses_v2/features/profile/presentation/myprofilescreen.dart';
import 'package:business_bosses_v2/features/promotions/presentation/promotionscreen.dart';
import 'package:business_bosses_v2/features/profile/presentation/publicprofilescreen.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:business_bosses_v2/features/referrals/refer_screen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:get/get.dart';

import '../features/settings/delete_account_screen.dart';

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
      page: () => const BottomNavScreen(0, true),
      // binding: BindingsBuilder(
      //   () {
      //     Get.put(ProfileController());
      //     Get.put(ChatController());
      //     Get.put(PostsController());
      //     Get.put(HomeController());
      //   },
      // ),
    ),
    GetPage(
      name: Routes.notifications,
      page: () => const NotificationsScreen(),
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
    GetPage(
      name: Routes.chat,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: Routes.chatRoom,
      page: () => const ChatRoomScreen(),
    ),
    GetPage(
      name: Routes.publicProfile,
      page: () => const PublicProfileScreen(),
    ),
    GetPage(
      name: Routes.referscreen,
      page: () => const ReferScreen(),
    ),
    GetPage(
      name: Routes.allconnectionsscreen,
      page: () => AllConnectionsScreen(),
    ),
    GetPage(
        name: Routes.allforumscreen,
        page: () => const AllForumScreen(),
        binding: BindingsBuilder.put(() => ForumController())),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: Routes.deleteAccount,
      page: () => const DeleteAccountScreen(),
    ),
    GetPage(
      name: Routes.createForum,
      page: () => const CreateForumScreen(),
      binding: BindingsBuilder.put(() => CreateForumController()),
    ),
    GetPage(
      name: Routes.postDetails,
      page: () => PostDetailsScreen(),
    ),
  ];
}
