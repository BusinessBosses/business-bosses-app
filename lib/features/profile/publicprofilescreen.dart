import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/posts/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../common/params.dart';
import '../../utils/theme/theme.dart';

var isExpanded = false;

class PublicProfileScreen extends StatefulWidget {
  static const routeName = '/public-profile-screen';

  const PublicProfileScreen({Key? key}) : super(key: key);

  @override
  _PublicProfileScreenState createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  UserModel _publicUser = UserModel();
  bool _isInit = false;

  bool _isLoading = true;
  bool blocked = false;

  List<PostModel> _friendPosts = [];

  Future<void> report(
      BuildContext context, String type, String publicUserUid) async {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInit) {
      final data = ModalRoute.of(context)?.settings.arguments as Params;
      debugPrint('_PublicProfileScreenState.: ${data?.toMap()}');
      if (data?.arg1 == null && data?.arg2 == null) {
        Navigator.of(context).pop();
      }
      _loadUser(data);
      _isInit = true;
    }
  }

  Future<void> _loadUser(Params params) async {}

  Future<void> _loadMyPost() async {}

  Widget _buildChoiceChips(String data) {
    return SizedBox(
        child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // ignore: unnecessary_null_comparison
        itemCount: data == null ? 0 : data.split('+').length,
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              Chip(
                backgroundColor: backgroundcolorinterface,
                avatar: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 5,
                ),
                label: Text(
                  data.split('+')[index],
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          );
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        title: Text('@${_publicUser?.username ?? ''}'),
        actions: [],
      ),
    );
  }
}
