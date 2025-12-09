import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../../../navigation/routes.dart';
import 'forms/login_form.dart';

/// LOGIN SCREEEN
class LoginScreen extends StatelessWidget {
  /// LOGIN SCREEN CONSTRUCTOR
  const LoginScreen({super.key});

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
                    const Column(
                      children: <Widget>[
                        TextWidget(
                          text: 'Log In',
                          color: primaryColorLT,
                          fontWeight: FontWeight.w700,
                          size: 18,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        CircleAvatar(
                          backgroundColor: primaryColorLT,
                          radius: 3,
                        )
                      ],
                    ),
                    const SizedBox(width: 46),
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.registration);
                          },
                          child: const TextWidget(
                            text: 'Join Now',
                            color: iconColor,
                            fontWeight: FontWeight.w600,
                            size: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                // Text(
                //   'Login',
                //   style: Theme.of(context).textTheme.headline6.copyWith(
                //         fontWeight: FontWeight.w800,
                //       ),
                // ),
                //field user name or email

                const LoginForm(),
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

  Future<dynamic> navigateTo(
    BuildContext context, {
    String? routeName,
    dynamic arguments,
    bool isRemoveUntil = false,
  }) async {
    // print("=====>>>> $routeName");
    if (routeName == null) {
      // print('+++++++ pop');
      Navigator.of(context).pop(arguments);
    } else if (isRemoveUntil) {
      return await Navigator.of(context).pushNamedAndRemoveUntil(
          routeName, (Route<dynamic> route) => false,
          arguments: arguments);
    } else {
      return await Navigator.of(context)
          .pushNamed(routeName, arguments: arguments);
    }
  }
}
