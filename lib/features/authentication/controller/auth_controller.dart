import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dartDeveloper;
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/authentication/presentation/code_verification_screen.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Initalize Auth controller
class AuthController extends GetxController {
  /// SEND OTP TO USER EMAIL FOR VERIFICATION
  void sendOtp({
    required String emailAddress,
    required String userName,
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
        Get.to(() => CodeVerificationScreen(otp: code.toString()));
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

      dartDeveloper.log(
          'email: ${appleCredential.email}, name: ${appleCredential.familyName}');

      // print(appleCredential.email);
    } catch (e) {
      throw e;
    }
  }
}
