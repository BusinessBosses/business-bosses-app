import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/text_widget.dart';
import '../../../functions/unfocus_keyboard.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';
import 'forms/signup_form.dart';

/// REGISTER SCREEN
class RegisterScreen extends StatelessWidget {
  /// REGISTER SCREEN CONSTRUCTOR

  const RegisterScreen({super.key});
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        backgroundColor: Colors.white,
        // key: _scaffoldKey,
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
                          'Free Promotion App - Sell, Network & Grow Globally',
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
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.login);
                          },
                          child: const TextWidget(
                            text: 'Log In',
                            color: iconColor,
                            fontWeight: FontWeight.w700,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 46),
                    const Column(
                      children: <Widget>[
                        TextWidget(
                          text: 'Sign Up',
                          color: primaryColorLT,
                          fontWeight: FontWeight.w700,
                          size: 20,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        CircleAvatar(
                          backgroundColor: primaryColorLT,
                          radius: 3,
                        )
                      ],
                    )
                  ],
                ),

                //field user name or email
                // SizedBox(height: 24.0),
                const SignUpForm(),
                const SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
