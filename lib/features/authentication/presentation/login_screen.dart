import 'package:flutter/material.dart';

import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import 'forms/login_form.dart';
import 'forms/signup_form.dart';

/// LOGIN SCREEEN
class LoginScreen extends StatefulWidget {
  final bool isLogin;

  /// LOGIN SCREEN CONSTRUCTOR
  const LoginScreen({
    super.key,
    this.isLogin = true,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late bool _isLogin;

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 35.0,
                      height: 35.0,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/images/app_logo_2.png',
                        height: 40,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                          'Promote your Business - Get Featured & Reach More Customers',
                          style: TextStyle(
                              fontSize: 14,
                              color: textColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w700)),
                    )
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogin = true;
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          TextWidget(
                            text: 'Log In',
                            color: _isLogin ? primaryColorLT : iconColor,
                            fontWeight: FontWeight.w700,
                            size: 18,
                          ),
                          if (_isLogin) ...<Widget>[
                            const SizedBox(
                              height: 6,
                            ),
                            const CircleAvatar(
                              backgroundColor: primaryColorLT,
                              radius: 3,
                            )
                          ]
                        ],
                      ),
                    ),
                    const SizedBox(width: 46),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLogin = false;
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          TextWidget(
                            text: 'Join Now',
                            color: !_isLogin ? primaryColorLT : iconColor,
                            fontWeight: FontWeight.w700,
                            size: 18,
                          ),
                          if (!_isLogin) ...<Widget>[
                            const SizedBox(
                              height: 6,
                            ),
                            const CircleAvatar(
                              backgroundColor: primaryColorLT,
                              radius: 3,
                            )
                          ]
                        ],
                      ),
                    )
                  ],
                ),
                _isLogin ? const LoginForm() : const SignUpForm(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Remove keyboard focus
  void unFocusKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
