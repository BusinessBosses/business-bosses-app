// ignore_for_file: public_member_api_docs

class Routes {
  ///  INITIAL ROUTE SETTER
  static Future<String> get initialRoute async {
    return login;
  }

  static const String home = '/homeScreen';
  static const String login = '/loginScreen';
  static const String registration = '/registerScreen';
  static const String codeVerification = '/codeVerificationScreen';
  static const String otpScreen = '/otpScreen';
  static const String restPassword = '/resetPasswordScreen';
  static const String bottomNavigation = '/bottomNavScreen';
  static const String myProfile = '/myProfileScreen';
  static const String updateProfile = '/updateProfileScreen';
  static const String publicProfile = '/publicProfileScreen';
  static const String createPost = '/createPostScreen';
  static const String postDetails = '/postDetailsScreen';
  static const String chatRoom = '/chatRoomScreen';
  static const String chat = '/chatsScreen';
  static const String marketPlace = '/marketPlaceScreen';
  static const String createForum = '/createForumScreen';
  static const String settings = '/settingsScreen';
  static const String notifications = '/notificationsScreen';
  static const String onboarding = '/onboardingScreen';
  static const String bossuppartner = '/bossuppartner';
  static const String promotionscreen = '/promotionScreen';
  static const String analysescreen = '/analyseScreen';
  static const String referscreen = '/referScreen';
  static const String allconnectionsscreen = '/allconnectionsScreen';
}
