import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../navigation/routes.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';

/// VERIFY CODE AFTER SIGNUP
class CodeVerificationScreen extends StatefulWidget {
  /// KEY CONSTRUCTOR
  const CodeVerificationScreen({
    Key? key,
    required this.otp,
    required this.userName,
    required this.emailAddress,
    required this.password,
  }) : super(key: key);
  // ignore: public_member_api_docs
  final String otp;
  // ignore: public_member_api_docs
  final String userName;
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
            children: [
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
                      color: textColor.withOpacity(0.8),
                      fontWeight: FontWeight.normal,
                    ),
              ),

              const SizedBox(height: 36.0),
              PinCodeTextField(
                appContext: context,
                length: 6,
                mainAxisAlignment: MainAxisAlignment.center,

                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  // fieldHeight: 60,
                  // fieldWidth: 50,
                  inactiveFillColor: Colors.white,
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  disabledColor: Colors.red,
                  inactiveColor: Colors.black12,
                  selectedColor: Colors.black,
                  borderWidth: 1.0,
                  fieldOuterPadding: const EdgeInsets.all(6.0),
                ),
                textStyle: const TextStyle(fontSize: 20, height: 1.6),

                onCompleted: (String v) {},
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (String value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (String? text) {
                  return true;
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
                    // if (widget.otp.isNotEmpty && widget.otp == currentText) {
                    dynamic user = await _handleRegister();
                    if (user['success'] == false) {
                      Get.snackbar('Error', user['error']);
                    } else {
                      Get.snackbar(
                          'Success', 'You have registered succesfully!');
                      Get.toNamed(
                        Routes.updateProfile,
                        arguments: UserModel(
                          username: widget.userName,
                          email: widget.emailAddress,
                        ),
                      );
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
      widget.emailAddress,
      widget.password,
      widget.userName,
    );
    return user;
  }
}

enum VerififationType { email, phone }
