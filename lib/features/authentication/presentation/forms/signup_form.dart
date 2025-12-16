import 'dart:convert';
import 'dart:io';
import 'dart:math';

// import 'package:apple_sign_in_safety/apple_sign_in.dart';
// import 'package:apple_sign_in_safety/apple_sign_in_button.dart';
import 'package:business_bosses_v2/action/action.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/authentication/controller/auth_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';

import 'package:country_picker/country_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/dialogs/snackbar.dart';
import '../../../../common/widgets/buttons/custom_button.dart';
import '../../../../common/widgets/buttons/icon_text_button.dart';
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
  String? _username,
      _authCred,
      _password,
      _confirmPassword,
      _inviteId,
      _authusername;
  bool? _isUniqueName = false;
  bool? _isUniqueEmail = false;
  bool isEmailAuth = true;
  bool _invisiblePassword = true;
  bool _invisibleCPassword = true;
  bool agreedToTerms = true;
  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  String countryCode = '+447';

  void onChangeCountry(Country value) {
    List<dynamic> spl = value.displayName.toString().split(' ');
    setState(() {
      countryCode = spl[spl.length - 1].toString().split('[')[1].split(']')[0];
    });
  }

  // Future<GoogleSignInAccount?> _handleGoogleAuth() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     return googleUser;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> saveToSharedPreferences(String value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<dynamic> _handleAppleLogin() async {
    dynamic user = await _apiService.googleLogin(
      _authCred!,
      _password ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return user;
  }

  /// CREATE NONCE
  String generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List<String>.generate(
        length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.initialize(
      clientId: null, // Android/iOS: typically null
      serverClientId:
          '346913891380-jc6ue1tk6jb1urt1r7sv6rg65eucjot5.apps.googleusercontent.com', // Required for ID tokens
      hostedDomain: null,
      nonce: null,
    );
  }

  /// Returns the sha156 hash of [input] in hex notation.
  String sha156ofString(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
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
                  children: <Widget>[
                    TextFormField(
                      onChanged: (String val) {
                        _password = val;
                        setState(() {});
                      },
                      validator: Validator.signuppasswordValidator,
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

                            Get.off(() => UpdateProfileScreen(
                                    user: UserModel(
                                  username: _username!,
                                  email: _authCred!,
                                )));
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

  void _handleAppleSignIn() async {
    setState(() {
      _isProcessing = true;
    });
    final String rawNonce = generateNonce();
    final String nonce = sha156ofString(rawNonce);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      _authCred = appleCredential.email;
      _authusername =
          '${appleCredential.givenName} ${appleCredential.familyName}';
      if (_authCred == null) {
        _authCred = prefs.getString('_authCred');
        _authusername = prefs.getString('_authusername');
        await logEvents('login', 'Apple SignIn');
        dynamic user = await _handleAppleLogin();
        Get.offAndToNamed(Routes.home);
        if (user['success'] == false) {
          Get.snackbar('Error', user['error']);
        } else {}
      } else {
        saveToSharedPreferences(_authCred!, '_authCred');
        saveToSharedPreferences(_authusername!, '_authusername');
        await _handleRegister();
        Get.snackbar('Success', 'Authentication completed');
        await logEvents('signup', 'email');
        Get.off(() => UpdateProfileScreen(
                user: UserModel(
              name: _username!,
              username: _username!,
              email: _authCred!,
            )));
      }
    } catch (error) {
      // Error oc'${_authCred!} ${_authusername!}'og('Here ->>>>>> $error');

      showSnackBar(Get.context!,
          message: 'Opps!! Something went wrong. Try again');
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _handleGoogleSignUp() async {
    setState(() {
      _isProcessing = true;
    });

    // Attempt to sign in with Google
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

    final GoogleSignInAuthentication auth = googleUser.authentication;
    // Sign in was successful
    setState(() {
      _isProcessing = false;
    });
    _authCred = googleUser.email;
    _username = googleUser.displayName;
    _password = auth.idToken;

    // showPasswordDialog();
    // await _handleRegister();
    dynamic user = await _handleRegister();
    if (user['success'] == false) {
      Get.snackbar('Error', user['error']);
    } else {
      Get.snackbar('Success', 'You have registered succesfully!');
      Get.off(() => UpdateProfileScreen(
              user: UserModel(
            name: _username!,
            username: _username!,
            email: _authCred!,
          )));
    }
    await _googleSignIn.disconnect();

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
        children: <Widget>[
          const SizedBox(height: 25.0),
          // Social login buttons first
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: primaryColorLT),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconTextButton(
              label: 'Sign up with Google',
              onPressed: _handleGoogleSignUp,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 10.0),

          if (Platform.isIOS) ...<Widget>[
            SizedBox(
              height: 55,
              child: SignInWithAppleButton(
                height: 40,
                text: 'Sign up with Apple',
                onPressed: _handleAppleSignIn,
              ),
            ),
          ],

          const SizedBox(height: 20.0),

          // "Or" separator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Container(
                color: hintColor,
                height: 0.8,
              )),
              const SizedBox(width: 16.0),
              RichText(
                text: const TextSpan(
                  children: <InlineSpan>[
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
              Expanded(
                  child: Container(
                color: hintColor,
                height: 0.8,
              )),
            ],
          ),

          const SizedBox(height: 20.0),

          // Email signup form fields
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                onChanged: (String val) async {
                  // Process the value by removing spaces and converting to lowercase
                  final String processedVal =
                      val.replaceAll(' ', '').toLowerCase();
                  _username = processedVal;
                  bool? result = await _verifyUnique(processedVal, '');
                  setState(() {
                    _isUniqueName = result;
                  });
                },
                validator: (String? val) => Validator.usernameValidator(
                  val!,
                  isUnique: _isUniqueName ?? false,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: inputDecoration.copyWith(
                    hintText: 'Enter / Create username',
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
          const SizedBox(height: 15.0),

          // Password
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                onChanged: (String val) {
                  _password = val;
                  setState(() {});
                },
                validator: Validator.signuppasswordValidator,
                textInputAction: TextInputAction.next,
                obscureText: _invisiblePassword,
                keyboardType: TextInputType.visiblePassword,
                maxLength: 16,
                decoration: inputDecoration.copyWith(
                  counterText: '',
                  hintText: 'Password (8-16 chars, include numbers)',
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
              const SizedBox(height: 15.0),
              TextFormField(
                onChanged: (String val) {
                  _confirmPassword = val;
                  setState(() {});
                },
                validator: (String? val) {
                  if (val!.isEmpty) return 'Confirm Password is required';
                  if (val != _password) return 'Passwords do not match';
                  return null;
                },
                textInputAction: TextInputAction.done,
                obscureText: _invisibleCPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: inputDecoration.copyWith(
                  hintText: 'Confirm Password',
                  suffixIcon: _showHideIcon(PasswordField.confirmPassword),
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
          CustomButton(
            label: 'Join Now',
            onPressed: () async {
              _formKey.currentState!.save();
              setState(() {
                _autoValidateMode = AutovalidateMode.always;
              });
              if (!_formKey.currentState!.validate()) return;

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
          colorFilter: const ColorFilter.mode(hintColor, BlendMode.srcIn),
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
          children: <InlineSpan>[
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
            if (Platform.isIOS)
              TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () {},
                  text: ' and ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xff999797),
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            if (Platform.isIOS)
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    launchTermsofService();
                  },
                text: 'Terms of Service',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    color: primaryColorLT),
              ),
            TextSpan(
                recognizer: TapGestureRecognizer()..onTap = () {},
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
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
  }

  Future<void> launchTermsofService() async {
    String url = Constants.TERMS_OF_SERVICE_LINK;
    bool canLunchLink = await canLaunchUrlString(url);
    if (canLunchLink) {
      await launchUrlString(url);
    } else {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
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

  Future<void> logEvents(dynamic event, dynamic method) async {
    await FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: <String, Object>{'method': method},
    );
  }
}
