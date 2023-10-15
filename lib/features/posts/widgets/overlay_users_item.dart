// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/user_avatar_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

class OverlayUsersItems extends StatelessWidget {
  final String? initialText;
  final List<UserModel> users;
  final VoidCallback? onClose;
  final Function(UserModel user)? onTap;

  const OverlayUsersItems({
    Key? key,
    this.initialText,
    required this.users,
    this.onClose,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    // List<MyUser> filterUsers = [];

    return Padding(
      padding: EdgeInsets.only(top: kToolbarHeight + mediaQuery.padding.top),
      child: Material(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      initialValue: initialText,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                  )
                ],
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int i) {
                    return ListTile(
                      onTap: () => onTap!(users[i]),
                      leading: UserAvatarWithBadge(
                        user: users[i],
                        height: 55.0,
                        width: 55.0,
                        radius: 40.0,
                        placeHolder: Icons.person,
                      ),
                      title: users[i].isSubscribed == true
                          ? Row(
                              children: <Widget>[
                                Text(users[i].name ?? '@${users[i].username}'),
                                const SizedBox(width: 5),
                                SvgPicture.asset(
                                  'assets/svgs/premiumbadge.svg',
                                  height: 9,
                                  color: primaryColorLT,
                                )
                              ],
                            )
                          : Text(users[i].name ?? '@${users[i].username}'),
                      subtitle: Text('@${users[i].username}'),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(height: 0.0),
                  itemCount: users.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
