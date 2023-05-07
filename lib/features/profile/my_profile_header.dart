import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/user_profile_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/widgets/buttons/custom_child_button.dart';
import '../../utils/theme/theme.dart';
import '../posts/models/post_model.dart';
import '../posts/presentation/widgets/userpost_tile.dart';

class MyProfileHeader extends StatefulWidget {
  const MyProfileHeader({Key? key}) : super(key: key);

  @override
  _MyProfileHeaderState createState() => _MyProfileHeaderState();
}

class _MyProfileHeaderState extends State<MyProfileHeader> {
  late UserModel _user;

  bool _isInit = false;
  int _mRefersCount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _getMyReferrals();
      _isInit = true;
    }
  }

  Future<void> _getMyReferrals() async {}

  bool isBioVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserProfileTile(),

              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: CustomChildButton(
                      onPressed: () {},
                      caption: 'Connections',
                      value: 10,
                    )),
                    Expanded(
                        child: CustomChildButton(
                      onPressed: () {},
                      caption: 'Connected',
                      value: 10,
                    )),
                    Expanded(
                      child: CustomChildButton(
                        value: _mRefersCount,
                        caption: 'Referrals',
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              // SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }

  Widget OutlinedContainer(BuildContext context, Widget child,
      {required Function onTap}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radiusValue),
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 1)),
        child: child,
      ),
    );
  }

  Widget LRCL(context, String value, String caption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        Text(
          caption,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor.withOpacity(0.52),
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
        )
      ],
    );
  }
}
