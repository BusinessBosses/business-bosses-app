import 'package:flutter/material.dart';

import 'login_screen.dart';

/// REGISTER SCREEN
class RegisterScreen extends StatelessWidget {
  /// REGISTER SCREEN CONSTRUCTOR

  const RegisterScreen({super.key});
  // GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(isLogin: false);
  }
}
