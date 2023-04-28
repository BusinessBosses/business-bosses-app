import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../utils/theme/theme.dart';

/// VERIFY CODE AFTER SIGNUP
class CodeVerificationScreen extends StatefulWidget {
  /// KEY CONSTRUCTOR
  const CodeVerificationScreen({Key? key, required this.otp}) : super(key: key);
  final String otp;
  @override
  State<CodeVerificationScreen> createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  String currentText = "";
  bool _isProcessing = false;

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
                        color: Theme.of(context).primaryColor,
                      ),
                ),
              ),

              const SizedBox(height: 36.0),
              Text(
                'Enter the 6 digits code that you received on your email so you can continue to reset your account password. ',
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

                onCompleted: (v) {},
                // onTap: () {
                //   print("Pressed");
                // },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
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
                    if (widget.otp.isNotEmpty && widget.otp == currentText) {
                      Get.snackbar('Success', 'verified');
                    } else {
                      Get.snackbar('Error', 'Incorrect OTP');
                    }
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
}

enum VerififationType { email, phone }
