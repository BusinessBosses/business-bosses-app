// ignore_for_file: always_specify_types

import 'package:business_bosses_v2/analytics/presentation/explorebusinessbosses_screen.dart';
import 'package:business_bosses_v2/features/bottomnavigationscreen.dart';
import 'package:business_bosses_v2/features/connects/controller/referrals_controller.dart';
import 'package:business_bosses_v2/features/connects/presentation/referals_screen.dart';
import 'package:business_bosses_v2/features/courses/presentation/course_history.dart';
import 'package:business_bosses_v2/features/donations/presentation/create_donations.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations.dart';
import 'package:business_bosses_v2/features/donations/presentation/donations_history.dart';
import 'package:business_bosses_v2/features/donations/presentation/expandeddonationsscren.dart';
import 'package:business_bosses_v2/features/home/all_communities_screen.dart';
import 'package:business_bosses_v2/features/home/controller/commumities_controller.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/home/home_screen.dart';
import 'package:business_bosses_v2/features/home/marketplace_screen.dart';
import 'package:business_bosses_v2/features/live_event/presentation/confirm_create_event.dart';
import 'package:business_bosses_v2/features/live_event/presentation/create_event.dart';
import 'package:business_bosses_v2/features/live_event/presentation/live_event.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/renewconfirmation.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/sell_screen.dart';
import 'package:business_bosses_v2/features/marketplace/presentation/subscription_confirmation.dart';
import 'package:business_bosses_v2/features/posts/presentation/confirmation.dart';
import 'package:business_bosses_v2/features/settings/community_rules_screen.dart';
import 'package:business_bosses_v2/analytics/presentation/my_ranking_screen.dart';
import 'package:business_bosses_v2/analytics/presentation/profile_analyse_screen.dart';
import 'package:business_bosses_v2/analytics/presentation/relevant_users_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/forgot_password_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/login_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/register_screen.dart';
import 'package:business_bosses_v2/features/chat/chat_screen.dart';
import 'package:business_bosses_v2/features/connects/presentation/all_connections_screen.dart';
import 'package:business_bosses_v2/features/forum/controller/create_bossup_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/create_forum_controller.dart';
import 'package:business_bosses_v2/features/forum/controller/forum_controller.dart';
import 'package:business_bosses_v2/features/forum/presentation/all_forum_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/create_forum_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/specific_user_list_screen.dart';
import 'package:business_bosses_v2/features/moreinfoscreens/bossuppartner.dart';
import 'package:business_bosses_v2/features/notifications/controller/notification_controller.dart';
import 'package:business_bosses_v2/features/notifications/notificationsscreen.dart';
import 'package:business_bosses_v2/features/posts/presentation/create_post_screen.dart';
import 'package:business_bosses_v2/features/posts/presentation/post_details_screen.dart';
import 'package:business_bosses_v2/analytics/presentation/analysescreen.dart';
import 'package:business_bosses_v2/features/profile/change_password_screen.dart';
import 'package:business_bosses_v2/features/profile/presentation/myprofilescreen.dart';
import 'package:business_bosses_v2/features/promotions/presentation/promotionscreen.dart';
import 'package:business_bosses_v2/features/profile/presentation/publicprofilescreen.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:business_bosses_v2/features/referrals/refer_screen.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';
import 'package:business_bosses_v2/features/search/presentation/complete_searching_screen.dart';
import 'package:business_bosses_v2/features/settings/invite_a_friendscreen.dart';
import 'package:business_bosses_v2/features/settings/settingsscreen.dart';
import 'package:business_bosses_v2/features/withdrawal/coinhistoryscreen.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/features/premium/premiumscreen.dart';
import 'package:business_bosses_v2/features/premium/reviewpayment.dart';
import 'package:get/get.dart';

import '../features/forum/presentation/create_bossup_screen.dart';
import '../features/settings/delete_account_screen.dart';

///NAV INITIALIZATIONS
var routes = [
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
    name: Routes.home,
    page: () => const HomeScreen(),
    binding: BindingsBuilder.put(() => HomeController()),
  ),
  // GetPage(
  //   name: Routes.bottomNavigation,
  //   page: () => const BottomNavScreen(0, true),
  //   // binding: BindingsBuilder(
  //   //   () {
  //   //     Get.put(ProfileController());
  //   //     Get.put(ChatController());
  //   //     Get.put(PostsController());
  //   //     Get.put(HomeController());
  //   //   },
  //   // ),
  // ),
  GetPage(
    name: Routes.notifications,
    page: () => const NotificationsScreen(),
    binding: BindingsBuilder.put(() => NotificationController()),
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
    name: Routes.publicProfile,
    page: () => PublicProfileScreen(),
  ),
  GetPage(
    name: Routes.referscreen,
    page: () => const ReferScreen(),
  ),
  GetPage(
    name: Routes.transactionConfirmation,
    page: () => const Confirmation(),
  ),
  GetPage(
    name: Routes.allconnectionsscreen,
    page: () => AllConnectionsScreen(),
  ),
  GetPage(
    name: Routes.allforumscreen,
    page: () => const AllForumScreen(),
    binding: BindingsBuilder.put(() => ForumController()),
  ),
  GetPage(
    name: Routes.marketPlace,
    page: () => const MarketplaceScreen(),
    binding: BindingsBuilder.put(() => MarketController()),
  ),
  GetPage(
    name: Routes.allCommunitiesScreen,
    page: () => const AllCommunitiesScreen(),
    bindings: [
      BindingsBuilder.put(() => CommunitiesController()),
    ],
    // binding: BindingsBuilder.put(() => BossUpController()),
  ),
  GetPage(
    name: Routes.referalsscreen,
    page: () => const ReferalsScreen(),
    binding: BindingsBuilder.put(() => ReferralsController()),
  ),
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
  // GetPage(
  //   name: Routes.createBossUp,
  //   page: () => const CreateBossUpScreen(industryModel: null,),
  //   binding: BindingsBuilder.put(() => CreateBossUpController()),
  // ),
  // GetPage(
  //   name: Routes.postDetails,
  //   page: () => PostDetailsScreen(),
  // ),
  GetPage(
    name: Routes.specificuserlistscreen,
    page: () => const SpecificUserListScreen(),
  ),
  GetPage(
    name: Routes.completesearchingscreen,
    page: () => const CompleteSearchingScreen(),
    binding: BindingsBuilder.put(() => CompleteSearchController()),
  ),
  GetPage(
    name: Routes.communityrulesscreen,
    page: () => const CommunityRulesScreen(),
  ),
  GetPage(
    name: Routes.rankingscreen,
    page: () => const MyRankingScreen(),
  ),
  GetPage(
      name: Routes.relevantusersscreen,
      page: () => const RelevantUsersScreen(),
      binding: BindingsBuilder.put(() => CompleteSearchController())),
  GetPage(
    name: Routes.profileanalysescreen,
    page: () => const ProfileAnalyseScreen(),
  ),
  GetPage(
    name: Routes.inviteafriendscreen,
    page: () => const InviteAFriendTermsAndConditions(),
  ),
  GetPage(
    name: Routes.premiumscreen,
    page: () => const PremiumScreen(),
  ),
  GetPage(
    name: Routes.explorebusinessbossesscreen,
    page: () => const ExplorebusinessbossesScreen(),
  ),
  GetPage(
    name: Routes.renewconfirmation,
    page: () => const Renewconfirmation(),
  ),
  GetPage(
    name: Routes.subscriptionconfirmation,
    page: () => const SubscriptionConfirmation(),
  ),
  GetPage(
    name: Routes.reviewpayment,
    page: () => const ReviewPayment(),
  ),
  GetPage(
    name: Routes.liveEvents,
    page: () => const LiveEvent(),
  ),
  GetPage(
    name: Routes.confirmcreateevent,
    page: () => const ConfirmCreateEvent(
      roomID: '',
    ),
  ),
  GetPage(
    name: Routes.createevent,
    page: () => const CreateEvent(),
  ),
  GetPage(
    name: Routes.sellscreen,
    page: () => const CreateSellingitemScreen(
      isUpd: false,
    ),
  ),
  GetPage(
    name: Routes.bottomnavscreen,
    page: () => const BottomNavigationScreen(),
  ),
  GetPage(
    name: Routes.CoinHistoryScreen,
    page: () => const CoinHistoryScreen(),
  ),
  GetPage(
    name: Routes.coursehistoryscreen,
    page: () => const CourseHistory(),
  ),
  GetPage(
    name: Routes.donationsscreen,
    page: () => const DonationsPage(),
  ),
  GetPage(
    name: Routes.createdonationsscreen,
    page: () => const CreateDonationScreen(),
  ),
  GetPage(
    name: Routes.expandeddonationsscreen,
    page: () => const ExpandedDonationScreen(),
  ),
  GetPage(
    name: Routes.donationshistoryscreen,
    page: () => const DonationsHistory(),
  ),
];
