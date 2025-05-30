import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../action/action.dart';
import '../../../common/widgets/buttons/custom_button.dart';
import '../../../functions/validators/validator.dart';
import '../../../services/api_service.dart';
import '../../../utils/theme/theme.dart';
import '../controller/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final AuthController authController = Get.put(AuthController());

  String? _email;
  // ignore: unused_field
  bool? _isUniqueEmail;

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
            'Forgot password',
            textAlign: TextAlign.center,
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

                  const SizedBox(height: 36.0),
                  Text(
                    // 'Enter your email for the verification process, and we will send 4 digits code to your email for the verification.',
                    'Enter your email for the verification process, we\'ll send you a reset password email.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: textColor.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 36.0),
                  Text(
                    'E-mail',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    onChanged: (String val) {
                      _email = val;
                    },
                    validator: Validator.emailValidator,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    decoration: inputDecoration.copyWith(
                      hintText: 'Enter your email',
                    ),
                  ),
                  //field user name or email

                  const SizedBox(height: 48.0),
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: CustomButton(
                      label: 'Continue',
                      onPressed: () async {
                        _formKey.currentState?.save();
                        setState(() {
                          _autovalidateMode = AutovalidateMode.always;
                        });
                        setState(() {
                          _isProcessing = true;
                        });
                        String? result = await checkIfEmailExist(_email!);

                        // setState(() {
                        //   _isUniqueEmail = result != null;
                        // });
                        if (result != null) {
                          authController.sendOtpPassword(
                              emailAddress: _email!,
                              username: result,
                              onError: () {
                                setState(() {
                                  _isProcessing = false;
                                });
                              });
                        } else {
                          Get.snackbar('Error', 'Email Does Not Exist');
                          setState(() {
                            _isProcessing = false;
                          });
                        }
                        setState(() {
                          _isProcessing = false;
                        });
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
  Future<String?> checkIfEmailExist(String email) async {
    final ApiResponseModel response =
        await ApiService.get(path: 'users/email/$email');
    if (response.success) {
      return response.data.runtimeType == String
          ? null
          : response.data['username'];
    }
    return null;
  }

  // Future<bool?> _verifyUnique(String username, String email) async {
  //   bool? user = await _apiService.verifyUnique(
  //     username,
  //     email,
  //   );
  //   return user;
  // }
}
