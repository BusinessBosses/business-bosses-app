import 'package:flutter/material.dart';

import '../../../action/action.dart';
import '../../../common/widgets/buttons/custom_button.dart';
import '../../../functions/validators/validator.dart';
import '../../../utils/theme/theme.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  String? _email;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocusKeyboard(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Forgot password'),
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
                            color: Theme.of(context).primaryColor,
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
                        .copyWith(color: textColor.withOpacity(0.8)),
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
                    onChanged: (val) {
                      _email = val;
                    },
                    validator: Validator.emailValidator,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
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
                      onPressed: () {
                        _formKey.currentState?.save();
                        setState(() {
                          _autovalidateMode = AutovalidateMode.always;
                        });
                        _onSendEmail();
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

  Future<void> _onSendEmail() async {
    unFocusKeyboard(context);
    setState(() {
      _isProcessing = true;
    });

    setState(() {
      _isProcessing = false;
    });
  }
}
