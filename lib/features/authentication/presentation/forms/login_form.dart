import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;

// import 'package:apple_sign_in_safety/apple_sign_in.dart';
import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart'
    show TextWidget;
import 'package:business_bosses_v2/features/profile/presentation/update_profile_screen.dart';
import 'package:country_picker/country_picker.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../action/action.dart';
import '../../../../common/models/user_model.dart';
import '../../../../common/widgets/buttons/icon_text_button.dart';
import '../../../../navigation/routes.dart';
import '../../../../services/api_service.dart';
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
  String? _email, _token;
  bool _invisiblePassword = true;
  String countryCode = '+447';
  final ApiService _apiService = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  String? _authCred, _password, _authusername;

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  bool emailValidatorExists(String? val, {required bool isUnique}) {
    if (!isValidEmail(val!)) {
      return false;
    } else {
      return true;
    }
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

  ///  COUNTRY CHANGE HANDLER
  void onChangeCountry(Country value) {
    List<String> spl = value.displayName.toString().split(' ');
    setState(() {
      countryCode = spl[spl.length - 1].toString().split('[')[1].split(']')[0];
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

  Future<void> saveToSharedPreferences(String value, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<dynamic> _handleRegister() async {
    if (emailValidatorExists(_authCred!, isUnique: false)) {
      _handleAppleLogin();
    } else {
      dynamic user = await _apiService.register(
          _authCred!,
          _password ?? DateTime.now().millisecondsSinceEpoch.toString(),
          _authusername!,
          '');
      return user;
      // }
    }
  }

  void _handleAppleSignIn() async {
    setState(() {
      _isProcessing = true;
    });
    final String rawNonce = generateNonce();
    final String nonce = sha256ofString(rawNonce);
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
              username: _authusername!,
              email: _authCred!,
            )));
      }
    } catch (error) {
      // Error occurred during sign in
      // log('Here ->>>>>> $error');

      showSnackBar(Get.context!,
          message: 'Opps!! Something went wrong. Try again');
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void _handleGoogleSignIn() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Attempt to sign in with Google
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication auth = googleUser.authentication;
      // Sign in was successful
      _email = googleUser.email;
      _token = auth.idToken;
      dynamic user = await _handleGoogleLogin();
      if (user['success'] == false) {
        Get.snackbar('Error', user['error']);
        await _googleSignIn.disconnect();
      } else {
        await logEvents('login', 'apple');
        FirebaseMessaging.instance.getToken().then((String? value) async {
          Map<String, dynamic> data = <String, dynamic>{
            'deviceToken': value,
          };
          await ApiService.post(path: 'users/add-device-token', body: data);
        });
        // Add RevenueCat login here
        if (user['data']['bio'] != null) {
          // GetStorage().write('isFirstTime', false);
          Get.offAndToNamed(Routes.home);
        } else {
          Get.off(
              () => UpdateProfileScreen(user: UserModel.fromMap(user['data'])));
        }
      }

      setState(() {
        _isProcessing = false;
      });
    } catch (error) {
      // Error occurred during sign in
      // log('Here ->>>>>> ${error.toString()}');

      showSnackBar(Get.context!,
          message: 'Opps!! Something went wrong. Try again');
    }

    setState(() {
      _isProcessing = false;
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
          children: <Widget>[
            const SizedBox(height: 25.0),
            // Social login buttons first
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: primaryColorLT),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconTextButton(
                backgroundColor: Colors.transparent,
                label: 'Sign in with Google',
                labelColor: textColor,
                onPressed: _handleGoogleSignIn,
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),

            const SizedBox(height: 10.0),

            if (Platform.isIOS)
              SizedBox(
                height: 55,
                child: SignInWithAppleButton(
                  height: 40,
                  text: 'Sign in with Apple',
                  onPressed: _handleAppleSignIn,
                ),
              ),

            const SizedBox(height: 20.0),

            // "Or" separator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Container(color: hintColor, height: 0.8)),
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
                Expanded(child: Container(color: hintColor, height: 0.8)),
              ],
            ),

            const SizedBox(height: 20.0),

            // Email/Phone and password fields
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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

            const SizedBox(height: 15.0),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
              onTap: () {
                Get.toNamed(Routes.resetPassword);
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  'Forgot Password?',
                  style: headline6.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30.0),

            CustomButton(
              margin: const EdgeInsets.all(2.0),
              label: 'Login',
              onPressed: () async {
                setState(() {
                  _autoValidateMode = AutovalidateMode.always;
                });
                setState(() {
                  _isProcessing = true;
                });
                if (_authCred != null || _password != null) {
                  dynamic user = await _handleLogin();
                  if (user['success'] == false) {
                    Get.snackbar('Error', user['error']);
                  } else {
                    await logEvents('login', 'email');
                    FirebaseMessaging.instance
                        .getToken()
                        .then((String? value) async {
                      Map<String, dynamic> data = <String, dynamic>{
                        'deviceToken': value,
                      };
                      await ApiService.post(
                          path: 'users/add-device-token', body: data);
                    });
                    if (user['data']['bio'] != null) {
                      // GetStorage().write('isFirstTime', false);
                      Get.offAndToNamed(Routes.home);
                    } else {
                      Get.off(() => UpdateProfileScreen(
                          user: UserModel.fromMap(user['data'])));
                    }
                  }
                }
                setState(() {
                  _isProcessing = false;
                });
              },
              isProcessing: _isProcessing,
              buttonType: ButtonType.elevated,
              child: Container(),
            ),
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
          colorFilter: const ColorFilter.mode(hintColor, BlendMode.srcIn),
        ),
      ),
    );
  }

  Future<dynamic> _handleLogin() async {
    dynamic user = await _apiService.login(
      _authCred!,
      _password!,
    );
    return user;
  }

  Future<dynamic> _handleAppleLogin() async {
    dynamic user = await _apiService.googleLogin(
      _authCred!,
      _password ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return user;
  }

  Future<dynamic> _handleGoogleLogin() async {
    dynamic user = await _apiService.googleLogin(
      _email!,
      _token ?? DateTime.now().millisecondsSinceEpoch.toString(),
    );
    return user;
  }

  Future<void> logEvents(dynamic event, dynamic method) async {
    await FirebaseAnalytics.instance.logEvent(
      name: event,
      parameters: <String, Object>{'method': method},
    );
  }
}
