import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';

/// VERIFY CODE AFTER SIGNUP
class CodeVerificationScreen extends StatefulWidget {
  /// KEY CONSTRUCTOR
  const CodeVerificationScreen(
      {super.key,
      required this.otp,
      required this.userName,
      required this.emailAddress,
      required this.password,
      this.inviteId});
  // ignore: public_member_api_docs
  final String otp;
  // ignore: public_member_api_docs
  final String userName;
  final String? inviteId;
  // ignore: public_member_api_docs
  final String password;
  // ignore: public_member_api_docs
  final String emailAddress;
  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  String currentText = '';
  bool _isProcessing = false;

  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isProcessing,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text('Code Verification'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Text(
                  'Business\nBosses',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 28.0,
                        color: Colors.red,
                      ),
                ),
              ),

              const SizedBox(height: 36.0),
              Text(
                'Enter the 6 digits code that you received on your email so you can continue your account creation. ',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: textColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.normal,
                    ),
              ),

              const SizedBox(height: 36.0),
              MaterialPinField(
                length: 6,
                mainAxisAlignment: MainAxisAlignment.center,
                theme: MaterialPinTheme(
                  shape: MaterialPinShape.outlined,
                  borderRadius: BorderRadius.circular(10),
                  // cellSize: Size(60, 50),
                  // fieldWidth: 50,
                  fillColor: Colors.white,
                  focusedFillColor: Colors.white,
                  filledFillColor: Colors.white,
                  disabledColor: Colors.red,
                  borderColor: Colors.black12,
                  focusedBorderColor: Colors.black,
                  borderWidth: 1.0,
                  spacing: 6,
                  textStyle: const TextStyle(fontSize: 20, height: 1.6),
                ),

                onCompleted: (String v) {},
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (String value) {
                  setState(() {
                    currentText = value;
                  });
                },
              ),
              //field user name or email

              const SizedBox(height: 48.0),
              SizedBox(
                width: double.infinity,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isProcessing) return;
                    setState(() {
                      _isProcessing = true;
                    });
                    if (widget.otp.isNotEmpty && widget.otp != currentText) {
                      Get.snackbar('Error', 'Incorrect OTP');
                      setState(() {
                        _isProcessing = false;
                      });
                      return;
                    }
                    dynamic user = await _handleRegister();
                    if (user['success'] == false) {
                      Get.snackbar('Error', user['error']);
                    } else {
                      Get.snackbar(
                          'Success', 'You have registered succesfully!');
                      await logEvents('signup', 'email');
                      Get.off(() => UpdateProfileScreen(
                              user: UserModel(
                            username: widget.userName,
                            email: widget.emailAddress,
                          )));
                    }
                    // } else {
                    //   Get.snackbar('Error', 'Incorrect OTP');
                    // }

                    setState(() {
                      _isProcessing = false;
                    });
                  },
                  child: Text(
                    _isProcessing ? 'Verifying...' : 'Verify',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _handleRegister() async {
    dynamic user = await _apiService.register(
        widget.emailAddress, widget.password, widget.userName, widget.inviteId);
    return user;
  }

  Future<void> logEvents(dynamic event, dynamic method) async {
    await FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: <String, Object>{'method': method},
    );
  }
}

enum VerififationType { email, phone }
