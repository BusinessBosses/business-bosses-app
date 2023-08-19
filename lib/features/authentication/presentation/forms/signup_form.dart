import 'dart:io';

// import 'package:apple_sign_in_safety/apple_sign_in.dart';
// import 'package:apple_sign_in_safety/apple_sign_in_button.dart';
import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/authentication/controller/auth_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/widgets/buttons/custom_button.dart';
import '../../../../common/widgets/buttons/icon_text_button.dart';
import '../../../../common/widgets/text_widget.dart';
import '../../../../services/api_service.dart';
import '../../../../utils/constants/constants.dart';
import '../../../../utils/theme/theme.dart';
import '../../../../utils/validators/phone_input.dart';
import '../../../../utils/validators/validator.dart';

/// SignUp Form Main
class SignUpForm extends StatefulWidget {
  /// SignUp Form Main
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isProcessing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String? _username, _authCred, _password, _inviteId;
  bool? _isUniqueName = false;
  bool? _isUniqueEmail = false;
  bool isEmailAuth = true;
  bool _invisibleCPassword = true, _invisiblePassword = true;
  bool agreedToTerms = true;
  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String countryCode = '+447';

  void onChangeCountry(Country value) {
    List spl = value.displayName.toString().split(' ');
    setState(() {
      countryCode = spl[spl.length - 1].toString().split('[')[1].split(']')[0];
    });
  }

  Future<GoogleSignInAccount?> _handleGoogleAuth() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      return googleUser;
    } catch (e) {
      rethrow;
    }
  }

  void showPasswordDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(26),
              // ),
              content: Form(
                key: _passwordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(height: 24.0),
                    const SizedBox(height: 24.0),
                    CustomButton(
                      label: 'Continue',
                      onPressed: () async {
                        _passwordFormKey.currentState!.save();

                        if (!_passwordFormKey.currentState!.validate()) return;
                        Navigator.of(context).pop(context);
                        if (agreedToTerms) {
                          setState(() {
                            _isProcessing = true;
                          });

                          dynamic user = await _handleRegister();
                          if (user['success'] == false) {
                            Get.snackbar('Error', user['error']);
                          } else {
                            Get.snackbar(
                                'Success', 'You have registered succesfully!');
                            Get.toNamed(
                              Routes.updateProfile,
                              arguments: UserModel(
                                username: _username!,
                                email: _authCred!,
                              ),
                            );
                          }
                        } else {
                          Get.snackbar('Error',
                              'Before signing up, you must agree to our Terms and Conditions');
                          setState(() {
                            _isProcessing = false;
                          });
                        }

                        setState(() {
                          _isProcessing = false;
                        });
                      },
                      isProcessing: _isProcessing,
                      buttonType: ButtonType.elevated,
                    ),
                  ],
                ),
              ),
            ));
  }

  void _handleGoogleSignUp() async {
    setState(() {
      _isProcessing = true;
    });

    // Attempt to sign in with Google
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      // Sign in was successful
      setState(() {
        _isProcessing = false;
      });
      _authCred = googleUser.email;
      _username = googleUser.displayName;
      _password = googleUser.serverAuthCode;

      // showPasswordDialog();
      // await _handleRegister();
      dynamic user = await _handleRegister();
      if (user['success'] == false) {
        Get.snackbar('Error', user['error']);
      } else {
        Get.snackbar('Success', 'You have registered succesfully!');
        Get.toNamed(
          Routes.updateProfile,
          arguments: UserModel(
            username: _username!,
            email: _authCred!,
          ),
        );
      }
      await _googleSignIn.disconnect();
    } else {
      showSnackBar(context, message: 'Opps!! Something went wrong. Try again');
    }

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onChanged: (String val) async {
                  _username = val;
                  bool? result = await _verifyUnique(val, '');
                  setState(() {
                    _isUniqueName = result;
                  });
                  // _autoValidateMode = AutovalidateMode.always;
                },
                validator: (String? val) => Validator.usernameValidator(
                  val!,
                  isUnique: true,
                ),
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
                        : const SizedBox(),
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
                  onChanged: (String val) async {
                    _authCred = val;
                    bool? result = await _verifyUnique('', val);
                    setState(() {
                      _isUniqueEmail = result;
                    });
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
                    suffixIcon: _isUniqueEmail == true
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          )
                        : const SizedBox(),
                  ),
                  validator: (String? val) => Validator.emailValidatorSignUp(
                    _authCred,
                    isUnique: true,
                  ),
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

          const SizedBox(height: 25.0),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     TextFormField(
          //       onChanged: (String val) {
          //         _inviteId = val;
          //         setState(() {});
          //       },
          //       textInputAction: TextInputAction.done,
          //       keyboardType: TextInputType.visiblePassword,
          //       decoration: inputDecoration.copyWith(
          //         hintText: 'Invite Id (Optional)',
          //         hintStyle: const TextStyle(
          //           color: iconColor,
          //           fontSize: 14,
          //           fontWeight: FontWeight.w600,
          //         ),
          //         filled: true,
          //         fillColor: const Color(0xffF4F4F4),
          //       ),
          //     ),
          //   ],
          // ),

          const SizedBox(height: 24.0),

          agreementText(context),
          const SizedBox(height: 24.0),
          CustomButton(
            label: 'Sign Up',
            onPressed: () async {
              _formKey.currentState!.save();
              setState(() {
                _autoValidateMode = AutovalidateMode.always;
              });
              if (!_formKey.currentState!.validate()) return;
              // if (Validator.emailValidatorSignUp(_authCred,
              //             isUnique: _isUniqueEmail!) ==
              //         '' &&
              //     Validator.usernameValidator(_username!,
              //             isUnique: _isUniqueName!) ==
              //         '') {
              if (agreedToTerms) {
                setState(() {
                  _autoValidateMode = AutovalidateMode.always;
                  _isProcessing = true;
                });
                AuthController().sendOtp(
                    emailAddress: _authCred!,
                    userName: _username!,
                    password: _password!,
                    inviteId: _inviteId,
                    onError: () {
                      setState(() {
                        _isProcessing = false;
                      });
                    });
              } else {
                Get.snackbar('Error',
                    'Before signing up, you must agree to our Terms and Conditions');
                setState(() {
                  _isProcessing = false;
                });
              }
              // } else {
              //   Get.snackbar('Error', 'Invalid Entries in Form');
              //   setState(() {
              //     _isProcessing = false;
              //   });
              // }
              setState(() {
                _isProcessing = false;
              });
            },
            isProcessing: _isProcessing,
            buttonType: ButtonType.elevated,
          ),

          const SizedBox(height: 20.0),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Container(
                color: hintColor,
                height: 0.8,
              )),
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
              Expanded(
                  child: Container(
                color: hintColor,
                height: 0.8,
              )),
            ],
          ),
          const SizedBox(height: 20.0),

          OutlinedButton(
            onPressed: () {},
            child: IconTextButton(
              label: 'Sign up with Google',
              onPressed: _handleGoogleSignUp,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 10.0),
          if (Platform.isIOS)
            Stack(children: [
              Container(
                height: 55,
                child: SignInWithAppleButton(
                  height: 40,
                  text: 'Sign up with Apple',
                  onPressed: () async {
                    AuthController().appleAuthentication();
                  },
                ),
              ),
            ])
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
                  launchPolicy();
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

  // void showSnackBar(BuildContext context, {String message = Constants.STGW}) {
  //   ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

  Future<bool?> _verifyUnique(String username, String email) async {
    bool? user = await _apiService.verifyUnique(
      username,
      email,
    );
    return user;
  }

  Future<void> launchPolicy() async {
    String url = Constants.PRIVACY_POLICY_LINK;
    bool canLunchLink = await canLaunchUrlString(url);
    if (canLunchLink) {
      await launchUrlString(url);
    } else {
      Get.snackbar('An Error Occured', 'Try again later.');
    }
  }

  Future<dynamic> _handleRegister() async {
    dynamic user = await _apiService.register(
        _authCred!,
        _password ?? DateTime.now().millisecondsSinceEpoch.toString(),
        _username!,
        _inviteId);
    return user;
  }
}
