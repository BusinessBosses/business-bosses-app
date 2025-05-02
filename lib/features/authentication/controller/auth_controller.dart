import 'dart:convert';
import 'dart:math';
import 'package:async/async.dart';
import 'package:business_bosses_v2/features/authentication/presentation/code_verification_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/forgot_password_verification.dart';
import 'package:business_bosses_v2/features/authentication/repository/auth_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../navigation/routes.dart';
import '../../../services/api_service.dart';

/// Initialize Auth controller
class AuthController extends GetxController {
  /// AUTH LOADING STATE
  RxBool isLoading = RxBool(false);

  // ignore: unused_field
  final GlobalKey<State> _key = GlobalKey<State>();

  final ApiService _apiService = ApiService();

  int randomNumber = Random().nextInt(9000) + 1000;

  String? _authCred, _password, _authusername;

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool emailValidatorExists(String? val, {required bool isUnique}) {
    if (!isValidEmail(val!)) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> saveToSharedPreferences(String value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  /// SEND OTP TO USER EMAIL FOR VERIFICATION
  Future<void> sendOtp({
    required String emailAddress,
    required String userName,
    required String password,
    String? inviteId,
    required VoidCallback onError,
  }) async {
    final int code = Random().nextInt(900000) + 100000;
    final String apiKey = dotenv.env['SENDGRILL_API_KEY']!;
    final String fromEmail = dotenv.env['SENDGRID_EMAIL_ADDRESS']!;
    final String templateId = dotenv.env['SENDGRID_TEMPLATE_ID']!;
    final String subject = 'OTP Verification Code';

    final Uri uri = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, Object>{
        'personalizations': <Map<String, Object>>[
          <String, Object>{
            'to': <Map<String, String>>[
              <String, String>{'email': emailAddress.trim()}
            ],
            'dynamic_template_data': <String, String>{
              'username': userName,
              'otp': code.toString(),
            }
          }
        ],
        'from': <String, String>{'email': fromEmail},
        'template_id': templateId,
        'subject': subject,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Get.to(() => CodeVerificationScreen(
            otp: code.toString(),
            userName: userName,
            emailAddress: emailAddress,
            password: password,
            inviteId: inviteId,
          ));
    } else {
      debugPrint('SendGrid error ${response.statusCode}: ${response.body}');
      onError();
    }
  }

  /// SEND OTP TO USER EMAIL FOR FORGOT PASSWORD
  Future<void> sendOtpPassword({
    required String emailAddress,
    required String username,
    required VoidCallback onError,
  }) async {
    final int code = Random().nextInt(900000) + 100000;
    final String apiKey = dotenv.env['SENDGRILL_API_KEY']!;
    final String fromEmail = dotenv.env['SENDGRID_EMAIL_ADDRESS']!;
    final String templateId = dotenv.env['SENDGRID_FORGOT_TEMPLATE_ID']!;
    final String subject = 'OTP Verification Code';

    final Uri uri = Uri.parse('https://api.sendgrid.com/v3/mail/send');
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, Object>{
        'personalizations': <Map<String, Object>>[
          <String, Object>{
            'to': <Map<String, String>>[
              <String, String>{'email': emailAddress.trim()}
            ],
            'dynamic_template_data': <String, String>{
              'username': username,
              'otp': code.toString(),
            }
          }
        ],
        'from': <String, String>{'email': fromEmail},
        'template_id': templateId,
        'subject': subject,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Get.to(() => ForgotPasswordVerificationScreen(
            otp: code.toString(),
            emailAddress: emailAddress,
          ));
    } else {
      debugPrint('SendGrid error ${response.statusCode}: ${response.body}');
      onError();
    }
  }

  /// CREATE NONCE
  String generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List<String>.generate(
        length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// SIGNING WITH APPLE
  // void _handleAppleSignIn() async {
  //   … (unchanged) …
  // }

  /// VALIDATE LOGIN INPUT
  String? loginValidator(String email, String password) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!email.isEmail) {
      return 'Invalid Email Format';
    } else if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 8) {
      return 'Password too short';
    } else {
      return null;
    }
  }

  /// AUTH CONTROLLER
  Future<void> login(String authCred, String password) async {
    if (loginValidator(authCred, password) != null) {
      /// show popup
    } else {
      isLoading(true);
      await AuthRepository.login(
          <String, dynamic>{'email': authCred, 'password': password});
      isLoading(false);
      Get.toNamed(Routes.home);
    }
  }

  Future<dynamic> _handleLogin() async {
    dynamic user = await _apiService.googleLogin(
      _authCred!,
      _password ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return user;
  }

  Future<dynamic> _handleRegister() async {
    if (emailValidatorExists(_authCred!, isUnique: false)) {
      _handleLogin();
    } else {
      dynamic user = await _apiService.register(
          _authCred!,
          _password ?? DateTime.now().millisecondsSinceEpoch.toString(),
          _authusername!,
          '');
      return user;
    }
  }

  Future<void> logEvents(dynamic event, dynamic method) async {
    await FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: <String, Object>{'method': method},
    );
  }
}
