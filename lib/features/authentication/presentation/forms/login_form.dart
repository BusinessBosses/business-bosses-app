import 'dart:io';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart'
    show TextWidget;
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../common/widgets/buttons/icon_text_button.dart';
import '../../../../functions/validators/phone_input.dart';
import '../../../../functions/validators/validator.dart';
import '../../../../utils/theme/theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isProcessing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool isEmailAuth = true;
  String? _authCred, _password;
  bool _invisiblePassword = true;
  String countryCode = '+447';

  onChangeCountry(Country value) {
    List spl = value.displayName.toString().split(' ');
    setState(() {
      countryCode = spl[spl.length - 1].toString().split('[')[1].split(']')[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isProcessing,
      child: Form(
        key: _formKey,
        autovalidateMode: _autoValidateMode,
        child: Column(
          children: [
            const SizedBox(height: 25.0),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: isEmailAuth ? 'Email' : 'Phone',
                  size: 0,
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (isEmailAuth)
                  TextFormField(
                    onChanged: (String val) {
                      _authCred = val;
                      setState(() {});
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Enter your email',
                      hintStyle: const TextStyle(
                        color: iconColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      filled: true,
                      fillColor: const Color(0xffF4F4F4),
                    ),
                    validator: Validator.emailValidator,
                  )
                else
                  PhoneNumberInput(
                    onChangeCountry: onChangeCountry,
                    countryCode: countryCode,
                    onChangeText: (String value) {
                      _authCred = value;
                    },
                  )
              ],
            ),
            //field user name or email
            const SizedBox(height: 25.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (String val) {
                    _password = val;
                    setState(() {});
                  },
                  validator: Validator.passwordValidator,
                  textInputAction: TextInputAction.done,
                  obscureText: _invisiblePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: inputDecoration.copyWith(
                    hintText: 'Enter your password',
                    suffixIcon: showHideIcon(),
                    hintStyle: const TextStyle(
                      color: iconColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    filled: true,
                    fillColor: const Color(0xffF4F4F4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: Text('Forgot Password?',
                    style: headline6.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 30.0),

            CustomButton(
              margin: const EdgeInsets.all(2.0),
              label: 'Login',
              onPressed: () {},
              isProcessing: _isProcessing,
              buttonType: ButtonType.elevated,
              child: Container(),
            ),
            const SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Container(color: hintColor, height: 0.8)),
                const SizedBox(width: 16.0),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Or',
                        style: TextStyle(
                          color: hintColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(child: Container(color: hintColor, height: 0.8)),
              ],
            ),
            const SizedBox(height: 20.0),
            OutlinedButton(
              onPressed: () {},
              child: IconTextButton(
                  backgroundColor: Colors.transparent,
                  label: 'Sign in with Google',
                  labelColor: textColor,
                  onPressed: () async {},
                  borderRadius: BorderRadius.circular(20.0),
                  icon: SvgPicture.asset(
                    'assets/svgs/googleicon.svg',
                    height: 24,
                  )),
            ),
            const SizedBox(height: 10.0),

            if (Platform.isIOS)
              OutlinedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                  side: MaterialStateProperty.all(BorderSide.none),
                ),
                onPressed: () async {
                  setState(() {
                    SignInWithApple();
                    _isProcessing = false;
                  });
                },
                child: IconTextButton(
                  backgroundColor: Colors.transparent,
                  label: 'Sign in with Apple',
                  labelColor: Colors.white,
                  onPressed: () async {},
                  borderRadius: BorderRadius.circular(20.0),
                  icon: SvgPicture.asset(
                    'assets/svgs/applelogo.svg',
                    height: 24,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget showHideIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _invisiblePassword = !_invisiblePassword;
        });
      },
      child: Container(
        height: 40.0,
        width: 40.0,
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(right: 10),
        child: SvgPicture.asset(
          _invisiblePassword
              ? 'assets/svgs/private.svg'
              : 'assets/svgs/eye.svg',
          // ignore: deprecated_member_use
          color: hintColor,
        ),
      ),
    );
  }

  Future<void> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'your_client_id_here',
          redirectUri: Uri.parse('your_redirect_uri_here'),
        ),
      );

      // Use the credential data to authenticate the user
    } catch (e) {
      // Handle sign-in errors
    }
  }
}
