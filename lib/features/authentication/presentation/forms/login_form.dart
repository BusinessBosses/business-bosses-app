
import 'dart:io';
// import 'package:apple_sign_in_safety/apple_sign_in.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart'
    as custombuttom;
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';

import 'package:business_bosses_v2/common/widgets/text_widget.dart'
    show TextWidget;
import 'package:business_bosses_v2/features/authentication/controller/auth_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../common/widgets/buttons/icon_text_button.dart';
import '../../../../utils/theme/theme.dart';
import '../../../../utils/validators/phone_input.dart';
import '../../../../utils/validators/validator.dart';

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
                icon: Icons.search,
              ),
            ),
            const SizedBox(height: 10.0),


            if (Platform.isIOS)
              SignInWithAppleButton(onPressed: () async {
                AuthController().appleAuthentication();
              })
            // Stack(
            //   children: [
            //     IconTextButton(
            //       backgroundColor: Colors.black,
            //       label: 'Sign in with Apple',
            //       labelColor: Colors.white,
            //       onPressed: logIn,
            //       borderRadius: BorderRadius.circular(10.0),
            //       icon: SvgPicture.asset(
            //         'assets/svgs/applelogo.svg',
            //         height: 24,
            //       ),
            //     ),
            //     Container(
            //       color: Colors.transparent,
            //       child: SizedBox(
            //         height: 57,
            //         child: Container(
            //           color: Colors.transparent,
            //           child: AppleSignInButton(
            //             cornerRadius: 10,
            //             type: ButtonType.defaultButton,
            //             style: ButtonStyleApple.black,
            //             onPressed: logIn,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // if (Platform.isIOS)
            //   SignInWithAppleButton(
            //     onPressed: () async {
            //       final MyResponse res = await MyFirebase().signInWithApple();
            //       // print(res.);
            //       if (res.success) {
            //         if (res.message == "newUser") {
            //           MyUser user = MyUser(
            //             username: res.data.user.displayName,
            //             uid: _firebase.uid,
            //             email: res.data.user.email,
            //             timestamp: DateTime.now().millisecondsSinceEpoch,
            //             deviceTokens:
            //                 _deviceToken != null ? [_deviceToken] : [],
            //           );
            //           _onJoinedDefault(_firebase.uid);
            //           _createUser(user);
            //         } else {
            //           _checkProfile();
            //         }
            //       } else {
            //         debugPrint("===========>>> ${res.message}");
            //         showSnackBar(
            //           context,
            //           message:
            //               'OOPS! Something went wrong. Check internet connection and try again.',
            //         );
            //         setState(() {
            //           _isProcessing = false;
            //         });
            //       }
            //     },
            //   ),
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

  // void logIn() async {
  //   final AuthorizationResult result = await AppleSignIn.performRequests([
  //     const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  //   ]);

  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       break;

  //     case AuthorizationStatus.error:
  //       break;

  //     case AuthorizationStatus.cancelled:
  //       break;
  //   }
  // }

  // void checkLoggedInState() async {
  //   final userId = await FlutterSecureStorage().read(key: 'userId');
  //   if (userId == null) {
  //     return;
  //   }

  //   final credentialState = await AppleSignIn.getCredentialState(userId);
  //   switch (credentialState.status) {
  //     case CredentialStatus.authorized:
  //       break;

  //     case CredentialStatus.error:
  //       break;

  //     case CredentialStatus.revoked:
  //       break;

  //     case CredentialStatus.notFound:
  //       break;

  //     case CredentialStatus.transferred:
  //       break;
  //   }
  // }

}
