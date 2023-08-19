/// CONSTANTS
// ignore_for_file: constant_identifier_names, public_member_api_docs

class Constants {
  ///email
  static const String EMAILREGEX =
      "^[a-zA-Z0-9.a-zA-Z0-9.!#\$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+";

  static const String E_MAIL = 'email';
  static const String PASSWORD = 'password';

  // AUTH
  static const String STGW = 'Something gone wrong';
  static const String USER_EXIST = 'User already exist';

  // urls
  static const String TWITTER_BASE_URL = 'https://twitter.com/';
  static const String INSTAGRAM_BASE_URL = 'https://instagram.com/';
  static const String PRIVACY_POLICY_LINK =
      'https://businessbosses.co.uk/privacy/';
  static const String HTTPS = 'https://';
  static const String HTTPS_WWW = 'https://www.';

  // static const String socketUrl = 'https://orca-app-5dg8w.ondigitalocean.app';
  // static const String baseUrl =
  //     'https://orca-app-5dg8w.ondigitalocean.app/api/v1';

  //victor url
  static const String socketUrl = 'http://192.168.0.178:5000';
  static const String baseUrl = 'http://192.168.0.178:5000/api/v1';

  //stephen url
  // static const String baseUrl = 'http://192.168.0.193:3000/api/v1';
  // static const String socketUrl = 'http://192.168.0.193:3000';

  // nodes
  static const String POSTS = 'posts';
  static const String COMMENTS = 'comments';
  static const String CONNECTS = 'connects';
  static const String QUOTE_INDEX = 'quoteIndex';

  static const String LEARNINGID = '-Mos1VMnV53H7AZa0W8p';
  static const String BOSS_UP_CHALLENGE_CATEGORY_ID = '-Mos1VMlx3oxZFRaw_BH';
  // static const String BOSS_UP_CHALLENGE_ID =
  //     '840396d6-8563-4cb4-811c-e4ddc81e170c';
  static const String OPPORTUNITIESID = '-Mos1VMnV53H7AZa0W8q';
  static const String BOSSUPINDUSTRYID = '-MsUOGcOT9oRXGakCcJv';

  static const String USERS = 'users';
  static const String INDUSTRIES = 'industries';
  static const String INDUSTRY = 'industry';
  static const String ADMIN = 'adminNotification';
  static const String CATEGORIES = 'categories';
  static const String TITLES = 'titles';
  static const String RANKED_USERS = 'rankedUsers';
  static const String WEEKLY_RANKING = 'weeklyRanking';
  static const String MONTHLY_RANKING = 'monthRanking';
  static const String EXTRAS = 'extras';

  static const String TOP_10_WEEKLY = 'top10Weekly';
  static const String TOP_25_WEEKLY = 'top25Weekly';
  static const String TOP_10_MONTHLY = 'top10Monthly';
  static const String TOP_25_MONTHLY = 'top25Monthly';
  static String homeSelectedCategory = 'forYou';
  static const String FORUMS = 'forums';
  static const String CHAT_ROOMS = 'chatRooms';
  static const String USERS_CHATS = 'userChats';
  static const String NOTIFICATIONS = 'notifications';
  static const String USED_BY = 'usedBy';

  static const String CONNECTIONS = 'connections';

  static const String INVITES = 'invites';
  static const String REFERS = 'refers';
  static const String TODAYS_QUOTE = '';

  static const String SETTINGS = 'settings';

  static const String REPORTS = 'reports';

  // NOTIFICATION CONSTANTS
  static const String NOTI_POST = 'post';
  static const String NOTI_FORUM = 'forum';
  static const String NOTI_INDUSTRY = 'industry';
  static const String NOTI_REFER = 'refer';
  static const String NOTI_JOIN_BY_CODE = 'join_by_code';
  static const String NOTI_RECOMMEND = 'recommend';
  static const String NOTI_FORUM_JOIN = 'forum_join';
  static const String NOTI_CHAT = 'chat';
  static const String NOTI_CONNECTION = 'connection';

  static const String TODAY_QUOTE = 'today_quote';
  static const String ALL_QUOTE = 'all_quote';

  static const String CONNECTION = 'connection';
  static const String CONNECTED = 'connected';
  static const String CONNECT = 'connect';
  static const String CONNECT_BACK = 'connect_back';

  static const String INTRO_ID = '-MsUPNEHnp8-An5VLI_v';

  static const String LAUNCH_PRO_ID = '-MsUOGcOT9oRXGakCcJv';
  // static const BOSS_UP_CHALLENGE_ID = '-MsUOGcOT9oRXGakCcJv';

  /// STORAGE CONSTANTS
  static const String ACCESS_TOKEN = 'accessToken';
  static const String USER_ID = 'uid';
}

enum PasswordField { password, confirmPassword }

enum EditProfileMode { complete, edit }

enum PostForumStatus { like, comment, delete, update }
