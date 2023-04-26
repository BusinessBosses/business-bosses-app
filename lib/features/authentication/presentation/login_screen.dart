import 'package:flutter/material.dart';

import '../../../common/widgets/text_widget.dart';
import '../../../utils/theme/theme.dart';
import '../../../navigation/routes.dart';
import 'forms/login_form.dart';

/// LOGIN SCREEEN
class LoginScreen extends StatelessWidget {
  /// LOGIN SCREEN CONSTRUCTOR
  const LoginScreen({Key? key}) : super(key: key);

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
              children: [
                const SizedBox(height: 69.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: const [
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
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context, Routes.registration as Route<Object?>);
                          },
                          child: const TextWidget(
                            text: 'Sign Up',
                            color: iconColor,
                            fontWeight: FontWeight.w600,
                            size: 18,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(
                  height: 29,
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
}
