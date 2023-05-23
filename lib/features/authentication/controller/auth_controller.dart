import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dartdeveloper;
import 'package:async/async.dart';
import 'package:business_bosses_v2/features/authentication/presentation/code_verification_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/forgot_password_screen.dart';
import 'package:business_bosses_v2/features/authentication/presentation/forgot_password_verification.dart';
import 'package:business_bosses_v2/features/authentication/repository/auth_repository.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Initalize Auth controller
class AuthController extends GetxController {
  /// AUTH LOADING STATE
  RxBool isLoading = RxBool(false);

  /// SEND OTP TO USER EMAIL FOR VERIFICATION
  void sendOtp({
    required String emailAddress,
    required String userName,
    required String password,
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
      customArgs: {'username': userName, 'otp': code.toString()},
    );
    mailer.send(email).then((result) {
      if (result.isError) {
        onError();
      } else {
        Get.to(() => CodeVerificationScreen(
              otp: code.toString(),
              userName: userName,
              emailAddress: emailAddress,
              password: password,
            ));
      }
    }).catchError((dynamic e) {
      onError();
    });
  }

  /// SEND OTP TO USER EMAIL FOR FORGOT PASSWORD
  void sendOtpPassword({
    required String emailAddress,
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
        'username': emailAddress,
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
      customArgs: {'username': emailAddress, 'otp': code.toString()},
    );
    mailer.send(email).then((Result<void> result) {
      if (result.isError) {
        onError();
      } else {
        Get.to(() => ForgotPasswordVerificationScreen(
              otp: code.toString(),
              emailAddress: emailAddress,
            ));
      }
    }).catchError((dynamic e) {
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
  Future<void> appleAuthentication() async {
    final String rawNonce = generateNonce();
    final String nonce = sha256ofString(rawNonce);

    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      dartdeveloper.log(
          'email: ${appleCredential.email}, name: ${appleCredential.familyName}');

      // print(appleCredential.email);
    } catch (e) {
      throw e;
    }
  }

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
    }
  }
}
