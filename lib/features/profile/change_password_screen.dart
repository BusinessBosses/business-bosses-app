import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../action/action.dart';
import '../../functions/validators/validator.dart';
import '../../services/api_service.dart';
import '../../utils/theme/theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final ApiService _apiService = ApiService();
  String? _currentPassword, _newPassword;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        backgroundColor: backgroundcolorinterface,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'Change Password',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
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
                  // Text(
                  //   'Old password',
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodyLarge!
                  //       .copyWith(fontWeight: FontWeight.w600),
                  // ),
                  // const SizedBox(height: 12.0),
                  // TextFormField(
                  //   onChanged: (val) => _currentPassword = val,
                  //   validator: Validator.passwordValidator,
                  //   textInputAction: TextInputAction.next,
                  //   obscureText: true,
                  //   keyboardType: TextInputType.visiblePassword,
                  //   decoration: inputDecoration.copyWith(
                  //     hintText: 'Enter your current password',
                  //   ),
                  // ),
                  // const SizedBox(height: 24.0),
                  Text(
                    'New password',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  TextFormField(
                    onChanged: (String val) => _newPassword = val,
                    validator: Validator.passwordValidator,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Enter your new password',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    onChanged: (String val) {},
                    validator: (String? val) =>
                        Validator.confirmPasswordValidator(val!, _newPassword!),
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Confirm new password',
                    ),
                  ),
                  const SizedBox(height: 48.0),
                  CustomButton(
                    label: 'Continue',
                    onPressed: () {
                      setState(() {
                        _autovalidateMode = AutovalidateMode.always;
                      });
                      unFocusKeyboard(context);
                      if (_formKey.currentState!.validate()) {
                        _onChangePassword();
                      }
                    },
                    isProcessing: _isProcessing,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onChangePassword() async {
    setState(() {
      _isProcessing = true;
    });
    // MyResponse res = await _firebase.signInWithEmailAndPassword(
    //     email: FirebaseAuth.instance.currentUser.email,
    //     password: _currentPassword);
    // if (res.success) {
    //   MyResponse res2 =
    //       await _firebase.changePassword(newPassword: _newPassword);
    //   if (res2.success) {
    //     showSnackBar(context, message: 'Password changed');
    //     navigateTo(context);
    //   } else {
    //     showSnackBar(context, message: res.message);
    //   }
    // } else {
    //   Get.snackbar('Error', 'Error while changing password!');
    // }
    // setState(() {
    //   _isProcessing = false;
    // });
  }

  Future<dynamic> _handleChange() async {
    // dynamic user = await _apiService.changePassword(
    //     ProfileController().myProfile.email, _password!);
    // return user;
  }
}
