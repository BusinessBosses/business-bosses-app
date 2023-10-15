import 'package:business_bosses_v2/common/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../action/action.dart';
import '../../common/models/api_response_model.dart';
import '../../functions/validators/validator.dart';
import '../../navigation/routes.dart';
import '../../services/api_service.dart';
import '../../utils/theme/theme.dart';
import 'controller/profile_controller.dart';

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
                children: <Widget>[
                  Text(
                    'Old password',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    onChanged: (String val) => _currentPassword = val,
                    validator: Validator.passwordValidator,
                    textInputAction: TextInputAction.next,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Enter your current password',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'New password',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 10,
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

  ///change the user password
  Future<void> _onChangePassword() async {
    setState(() {
      _isProcessing = true;
    });

    Map<String, dynamic> updateData = <String, dynamic>{
      'oldPassword': _currentPassword,
      'newPassword': _newPassword,
    };
    ApiResponseModel response =
        await ApiService.post(path: 'users/update-password', body: updateData);
    if (response.success) {
      Get.snackbar('Success', 'Password Updated Succesfully');
      if (Get.isRegistered<ProfileController>()) {
        final ProfileController profileController = Get.find();
        profileController.updateProfile(<String, dynamic>{
          ...profileController.myProfile.toMap(),
          ...updateData
        });
        // Get.back();
        // return;
      }
      Get.toNamed(Routes.home);
    } else {
      Get.snackbar('Error', response.message);
    }

    setState(() {
      _isProcessing = true;
    });

    setState(() {
      _isProcessing = false;
    });
  }

  Future<dynamic> _handleChange() async {
    // dynamic user = await _apiService.changePassword(
    //     ProfileController().myProfile.email, _password!);
    // return user;
  }
}
