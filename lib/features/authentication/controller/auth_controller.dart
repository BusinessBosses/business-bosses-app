import 'dart:math';

import 'package:async/src/result/result.dart';
import 'package:business_bosses_v2/features/authentication/presentation/code_verification_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

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
    mailer.send(email).then((Result<void> result) {
      if (result.isError) {
        onError();
      } else {
        Get.to(() => CodeVerificationScreen(otp: code.toString()));
      }
    }).catchError((dynamic e) {
      onError();
    });
  }
}
