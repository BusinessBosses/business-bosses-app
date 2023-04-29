import 'dart:io';

import 'package:apple_sign_in_safety/apple_sign_in.dart';
import 'package:apple_sign_in_safety/apple_sign_in_button.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart'
    as custombuttom;
import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/buttons/icon_text_button.dart';
import '../../../../common/widgets/text_widget.dart';
import '../../../../functions/validators/phone_input.dart';
import '../../../../functions/validators/validator.dart';
import '../../../../utils/constants/constants.dart';
import '../../../../utils/theme/theme.dart';
import '../../controller/auth_controller.dart';

/// SignUp Form Main
class SignUpForm extends StatefulWidget {
  /// SignUp Form Main
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final AuthController _authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String? _username, _authCred, _password;
  final List<String> _usersToCompareUsername = [];
  bool _isUniqueName = true;
  bool isEmailAuth = true;
  bool _invisibleCPassword = true, _invisiblePassword = true;
  bool agreedToTerms = true;

  String countryCode = '+447';

  onChangeCountry(Country value) {
    List spl = value.displayName.toString().split(" ");
    setState(() {
      countryCode = spl[spl.length - 1].toString().split("[")[1].split("]")[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    bool _isProcessing = false;
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        children: [
          const SizedBox(height: 25.0),

          //email
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: (String val) {
                  _username = val;
                },
                validator: (String? val) => Validator.usernameValidator(val!),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: inputDecoration.copyWith(
                    hintText: 'Enter your username',
                    hintStyle: const TextStyle(
                      color: iconColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    suffixIcon: _isUniqueName == true
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.close,
                            color: _isUniqueName == null
                                ? Colors.transparent
                                : Colors.red,
                          ),
                    filled: true,
                    fillColor: const Color(0xffF4F4F4)),
              ),
              const SizedBox(height: 15.0),
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
                  onChanged: (val) {
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
                  suffixIcon: _showHideIcon(PasswordField.password),
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
          const SizedBox(height: 24.0),

          agreementText(context),
          const SizedBox(height: 24.0),
          custombuttom.CustomButton(
            label: 'Sign Up',
            onPressed: () {
              // print(countryCode + _authCred);
              if (agreedToTerms) {
                setState(() {
                  _autoValidateMode = AutovalidateMode.always;
                });
                _authController.sendOtp(
                    emailAddress: _authCred!,
                    userName: _username!,
                    onError: () {});
                // Get.toNamed(Routes.codeVerification);
                // if (isEmailAuth) {
                // _setUpReferral();
                // } else {
                // phoneSignUp();
                // }
              } else {
                showSnackBar(context,
                    message:
                        'Before signing up, you must agree to our Terms and Conditions');
              }
            },
            isProcessing: _isProcessing,
            buttonType: custombuttom.ButtonType.elevated,
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
                        color: Color.fromARGB(56, 56, 56, 80),
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
                label: 'Sign up with Google',
                onPressed: () async {
                  setState(() {
                    _isProcessing = true;
                  });

                  // print(res.);
                  // if (res.success) {
                  //   if (res.message == "newUser") {
                  //     MyUser user = MyUser(
                  //       username: res.data.user.displayName,
                  //       uid: _firebase.uid,
                  //       email: res.data.user.email,
                  //       gender: _gender,
                  //       ageRange: _ageRange,
                  //       timestamp: DateTime.now().millisecondsSinceEpoch,
                  //       deviceTokens: _deviceToken != null ? [_deviceToken] : [],
                  //     );
                  //     _onJoinedDefault(_firebase.uid);
                  //     _createUser(user);
                  //   } else {
                  //     _checkProfile();
                  //   }
                  // } else {
                  //   debugPrint("===========>>> ${res.message}");
                  //   showSnackBar(
                  //     context,
                  //     message:
                  //         'OOPS! Something went wrong. Check internet connection and try again.',
                  //   );
                  //   setState(() {
                  //     _isProcessing = false;
                  //   });
                  // }
                },
                borderRadius: BorderRadius.circular(20),
                icon: SvgPicture.asset(
                  'assets/svgs/googleicon.svg',
                  height: 24,
                )),
          ),
          const SizedBox(height: 10.0),
          if (Platform.isIOS)
            Stack(
              children: [
                IconTextButton(
                  backgroundColor: Colors.black,
                  label: 'Sign in with Apple',
                  labelColor: Colors.white,
                  onPressed: logIn,
                  borderRadius: BorderRadius.circular(10.0),
                  icon: SvgPicture.asset(
                    'assets/svgs/applelogo.svg',
                    height: 24,
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: SizedBox(
                    height: 57,
                    child: Container(
                      color: Colors.transparent,
                      child: AppleSignInButton(
                        cornerRadius: 10,
                        type: ButtonType.defaultButton,
                        style: ButtonStyleApple.black,
                        onPressed: logIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // agreeAndJoin(context),
        ],
      ),
    );
  }

  Widget _showHideIcon(PasswordField passwordField) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (passwordField == PasswordField.password) {
            _invisiblePassword = !_invisiblePassword;
          } else {
            _invisibleCPassword = !_invisibleCPassword;
          }
        });
      },
      child: Container(
        height: 40.0,
        width: 40.0,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: SvgPicture.asset(
          passwordField == PasswordField.password
              ? !_invisiblePassword
                  ? 'assets/svgs/eye.svg'
                  : 'assets/svgs/private.svg'
              : !_invisibleCPassword
                  ? 'assets/svgs/eye.svg'
                  : 'assets/svgs/private.svg',
          color: hintColor,
        ),
      ),
    );
  }

  Widget agreementText(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      subtitle: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Check the box to Agree to the  ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xff999797),
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // launchPolicy();
                },
              text: 'Privacy Policy',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                  color: primaryColorLT),
            ),
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    // launchPolicy();
                  },
                text: '  of Business Bosses ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xff999797),
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      value: agreedToTerms,
      onChanged: (bool? value) {
        setState(() {
          agreedToTerms = value!;
        });
      },
    );
  }

  void showSnackBar(BuildContext context, {String message = Constants.STGW}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void logIn() async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        print('success');
        break;

      case AuthorizationStatus.error:
        print('Sign in failed 😿');
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
  }

  void checkLoggedInState() async {
    final userId = await FlutterSecureStorage().read(key: 'userId');
    if (userId == null) {
      print('No stored user ID');
      return;
    }

    final credentialState = await AppleSignIn.getCredentialState(userId);
    switch (credentialState.status) {
      case CredentialStatus.authorized:
        print('getCredentialState returned authorized');
        break;

      case CredentialStatus.error:
        print('error');
        break;

      case CredentialStatus.revoked:
        print('getCredentialState returned revoked');
        break;

      case CredentialStatus.notFound:
        print('getCredentialState returned not found');
        break;

      case CredentialStatus.transferred:
        print('getCredentialState returned not transferred');
        break;
    }
  }
}
