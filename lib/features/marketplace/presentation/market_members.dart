import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../navigation/routes.dart';
import '../../../utils/theme/theme.dart';

/// MARKET MEMBERS SCREEN
class MarketMembersScreen extends StatefulWidget {
  /// users were passed from marketplace page
  final List<UserModel> users;

  /// CONSTRUCTOR
  const MarketMembersScreen({super.key, required this.users});

  @override
  _MarketMembersScreenState createState() => _MarketMembersScreenState();
}

class _MarketMembersScreenState extends State<MarketMembersScreen> {
  final ScrollController _controller = ScrollController();

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Marketplace Members',
          textAlign: TextAlign.center,
        ),
      ),
      body: widget.users.isEmpty
          ? SafetyModel(
              isLoading: _isLoading,
              icon: const Icon(
                Icons.person,
                size: 80.0,
                color: hintColor,
              ),
              title: 'There is no marketplace member',
              subTitle: 'Be the first one to join!',
            )
          : Stack(
              children: <Widget>[
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 48.0),
                  controller: _controller,
                  itemCount: widget.users.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          onTap: () async {
                            Get.toNamed(Routes.publicProfile,
                                arguments: widget.users[i]);
                          },
                          leading: UserAvatarWithBadge(
                            user: widget.users[i],
                            height: 48.0,
                            width: 48.0,
                            radius: 30.0,
                            placeHolder: Icons.person,
                          ),
                          title: widget.users[i].isSubscribed == true
                              ? Row(
                                  children: <Widget>[
                                    Text(widget.users[i].name ??
                                        widget.users[i].username),
                                    const SizedBox(width: 5),
                                    SvgPicture.asset(
                                      'assets/svgs/premiumbadge.svg',
                                      height: 9,
                                      color: primaryColorLT,
                                    )
                                  ],
                                )
                              : Text(widget.users[i].name ??
                                  widget.users[i].username),
                          subtitle: Text(
                            widget.users[i].bio ?? '',
                            maxLines: 1,
                          ),
                        ),
                        const Divider(height: 0.0, indent: 0.0, endIndent: 0.0),
                      ],
                    );
                  },
                ),
              ],
            ),
    );
  }
}
