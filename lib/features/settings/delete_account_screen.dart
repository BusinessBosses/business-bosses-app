import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../action/action.dart';
import '../../common/widgets/buttons/custom_button.dart';
import '../../common/widgets/safety_model.dart';
import '../../services/api_service.dart';
import '../../utils/size_config.dart';
import '../../utils/theme/theme.dart';
import '../profile/controller/profile_controller.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  _DeleteAccountScreenState createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Delete Account',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('assets/app/app_logo.png',
                          height: 140.0, width: 140.0),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 1,
                  ),
                  Text(
                    'Deactivate your account \ninstead of deleting?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 3,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/svgs/deactivate.svg',
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                    ),
                    title: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('Deactivating your account is temporary',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    subtitle: Text(
                        'Your profile will not be accessible by other users in search until you activate it by logging in',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey)),
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 2,
                  ),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/svgs/delete-user.svg',
                      height: 30,
                      width: 30,
                      fit: BoxFit.fill,
                    ),
                    title: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text('Deleting your account is permanent',
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                    subtitle: Text(
                        'Your profile photos, videos, comments,likes and followers will be permanently deleted',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.grey)),
                  ),
                  const Spacer(),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 0.3,
                            width: SizeConfig.screenWidth,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 3,
                          ),
                          SizedBox(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            child: CustomButton(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Deactivate Account'),
                                      content: const Text(
                                          'Are you sure you want to deactivate this account?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: deactivateAccount,
                                          child: const Text('Deactivate'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              width: SizeConfig.screenWidth,
                              buttonType: ButtonType.elevated,
                              child: const Text(
                                'Deactivate account',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical * 2,
                          ),
                          SizedBox(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Delete Account'),
                                      content: const Text(
                                          'Are you sure you want to delete this account?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: deleteUser,
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Delete account',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: primaryColorLT),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              color: Colors.white.withOpacity(0.5),
              child: Center(
                child: SafetyModel(
                  isLoading: _isLoading,
                ),
              ),
            )
        ],
      ),
    );
  }

  Future<void> deactivateAccount() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponseModel response = await ApiService.put(
      path: 'users/${profileController.myProfile.uid}',
      body: <String, dynamic>{'deactivated': true},
    );
    if (response.success) {
      showSnackBar(context, message: 'Your account has been deactivated');
      _signOut();
    } else {
      showSnackBar(context, message: 'Error While Deactivating Your Account');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> deleteUser() async {
    setState(() {
      _isLoading = true;
    });
    ApiResponseModel response = await ApiService.delete(
      path: 'users/${profileController.myProfile.uid}',
    );
    if (response.success) {
      showSnackBar(context, message: 'Your account has been deleted');
      _signOut();
    } else {
      showSnackBar(context, message: 'Error While Deleting Your Account');
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _signOut() async {
    await _apiService.logout();
  }
}
