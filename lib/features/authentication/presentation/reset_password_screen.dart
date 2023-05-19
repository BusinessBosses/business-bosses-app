import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/widgets/buttons/custom_button.dart';
import '../../../functions/validators/validator.dart';
import '../../../navigation/routes.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../controller/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _email;
  String? _password;
  ApiService _apiService = ApiService();
  bool _invisiblePassword = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset password'),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: AbsorbPointer(
              absorbing: _isProcessing,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Text(
                      'Business\nBosses',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 28.0,
                            color: Colors.red,
                          ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: Text(
                      'Reset Password For\n ${widget.email}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                    ),
                  ),
                  const SizedBox(height: 36.0),
                  Text(
                    'Set New Password',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12.0),
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
                      hintText: 'Enter Your Password',
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
                  const SizedBox(height: 12.0),
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
                      hintText: 'Confirm Your Password',
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
                  const SizedBox(height: 48.0),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: CustomButton(
                      label: 'Reset',
                      onPressed: () async {
                        _formKey.currentState?.save();
                        setState(() {
                          _autovalidateMode = AutovalidateMode.always;
                        });
                        setState(() {
                          _isProcessing = true;
                        });
                        dynamic user = await _handleChange();
                        if (user['success'] == false) {
                          Get.snackbar('Error', user['error']);
                          setState(() {
                            _isProcessing = false;
                          });
                        } else {
                          Get.snackbar(
                              'Success', 'Password changed succesfully!');
                          Get.toNamed(Routes.login);
                        }
                      },
                      isProcessing: _isProcessing,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isProcessing = false;

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

  Future<dynamic> _handleChange() async {
    dynamic user = await _apiService.changePassword(widget.email, _password!);
    return user;
  }
}
