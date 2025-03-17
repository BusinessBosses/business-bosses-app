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
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../navigation/routes.dart';
import '../../../services/api_service.dart';

/// Initalize Auth controller
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
  void sendOtp({
    required String emailAddress,
    required String userName,
    required String password,
    String? inviteId,
    required VoidCallback onError,
  }) {
    Random rng = Random();
    int code = rng.nextInt(900000) + 100000;
    Mailer mailer = Mailer(dotenv.env['SENDGRILL_API_KEY']!);
    Address toAddress = Address(emailAddress.trim());
    Address fromAddress = Address(dotenv.env['SENDGRID_EMAIL_ADDRESS']!);
    Content content = Content('text/plain', code.toString());
    String subject = 'OTP Verification Code';
    final Personalization personalization = Personalization(
      <Address>[toAddress],
      dynamicTemplateData: <String, dynamic>{
        'username': userName,
        'otp': code.toString()
      },
      subject: subject,
    );

    Email email = Email(
      <Personalization>[personalization],
      fromAddress,
      subject,
      content: <Content>[content],
      templateId: dotenv.env['SENDGRID_TEMPLATE_ID'],
      customArgs: <String, String>{
        'username': userName,
        'otp': code.toString()
      },
    );
    mailer.send(email).then((Result<void> result) {
      if (result.isError) {
        onError();
      } else {
        Get.to(() => CodeVerificationScreen(
              otp: code.toString(),
              userName: userName,
              emailAddress: emailAddress,
              password: password,
              inviteId: inviteId,
            ));
      }
    }).catchError((dynamic e) {
      onError();
    });
  }

  /// SEND OTP TO USER EMAIL FOR FORGOT PASSWORD
  void sendOtpPassword({
    required String emailAddress,
    required String username,
    required VoidCallback onError,
  }) {
    Random rng = Random();
    int code = rng.nextInt(900000) + 100000;
    Mailer mailer = Mailer(dotenv.env['SENDGRILL_API_KEY']!);
    Address toAddress = Address(emailAddress.trim());
    Address fromAddress = Address(dotenv.env['SENDGRID_EMAIL_ADDRESS']!);
    Content content = Content('text/plain', code.toString());
    String subject = 'OTP Verification Code';
    final Personalization personalization = Personalization(
      <Address>[toAddress],
      dynamicTemplateData: <String, dynamic>{
        'username': username,
        'otp': code.toString()
      },
      subject: subject,
    );

    Email email = Email(
      <Personalization>[personalization],
      fromAddress,
      subject,
      content: <Content>[content],
      templateId: dotenv.env['SENDGRID_FORGOT_TEMPLATE_ID'],
      customArgs: <String, String>{
        'username': username,
        'otp': code.toString()
      },
    );
    mailer.send(email).then((Result<void> result) {
      if (result.isError) {
        onError();
        print(result.asError?.error);
      } else {
        print(result);
        Get.to(() => ForgotPasswordVerificationScreen(
              otp: code.toString(),
              emailAddress: emailAddress,
            ));
      }
    }).catchError((dynamic e) {
      print(e);
      onError();
    });
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
  //   final String rawNonce = generateNonce();
  //   final String nonce = sha256ofString(rawNonce);
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   try {
  //     final AuthorizationCredentialAppleID appleCredential =
  //         await SignInWithApple.getAppleIDCredential(
  //       scopes: <AppleIDAuthorizationScopes>[
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //     );

  //     _authCred = appleCredential.email;
  //     _authusername =
  //         '${appleCredential.givenName} ${appleCredential.familyName}';
  //     if (_authCred == null) {
  //       _authCred = prefs.getString('_authCred');
  //       _authusername = prefs.getString('_authusername');
  //       await logEvents('login', 'Apple SignIn');
  //       dynamic user = await _handleLogin();
  //       Get.offAndToNamed(Routes.home);
  //       if (user['success'] == false) {
  //         Get.snackbar('Error', user['error']);
  //       } else {}
  //     } else {
  //       saveToSharedPreferences(_authCred!, '_authCred');
  //       saveToSharedPreferences(_authusername!, '_authusername');
  //       dynamic user = await _handleRegister();
  //       Get.snackbar('Success', 'Authentication completed');
  //       await logEvents('signup', 'email');
  //       Get.toNamed(
  //         Routes.updateProfile,
  //         arguments: UserModel(
  //           username: _authusername!,
  //           email: _authCred!,
  //         ),
  //       );
  //     }

  //     print(_authCred! + ' ' + _authusername!);

  //   } catch (error) {
  //     // Error occurred during sign in
  //     // log('Here ->>>>>> $error');

  //   }

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
      // }
    }
  }

  logEvents(dynamic event, dynamic method) async {
    await FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: <String, dynamic>{'method': method},
    );
  }
}
