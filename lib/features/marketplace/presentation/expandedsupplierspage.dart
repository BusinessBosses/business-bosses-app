import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/marketplace/widgets/suppliers_grid_tile.dart';
import 'package:business_bosses_v2/features/posts/widgets/images_viewer_screen.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../common/models/user_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/user_avatar_with_badge.dart';
import '../../../utils/theme/theme.dart';

class ExpandedSuppliersPage extends StatefulWidget {
  final List<UserModel> filterItems;
  final List<UserModel> members;
  final bool isLoading;
  final bool isSearch;
  final Function(UserModel)? onConnectionChange;

  // ignore: public_member_api_docs
  const ExpandedSuppliersPage(
      {Key? key,
      this.filterItems = const <UserModel>[],
      this.isLoading = false,
      this.isSearch = false,
      this.onConnectionChange,
      this.members = const <UserModel>[]})
      : super(key: key);

  @override
  State<ExpandedSuppliersPage> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<ExpandedSuppliersPage> {
  final ScrollController _controller = ScrollController();
  final ProfileController _profileController = Get.find();
  final bool loadingNext = false;
  String? _selectedCategory;
  String? _selectedLocation;
  String? filterCode;
  @override
  Widget build(
    BuildContext context,
  ) {
    final ProfileController profileController = Get.find();
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
            'About Supplier',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/report.svg',
                      color: Colors.red,
                      height: 26,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'This supplier isn\'t verified by Business Bosses; we cannot guarantee a response',
                        style: TextStyle(color: Colors.red),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  UserAvatarWithBadge(
                    user: profileController.myProfile,
                    height: 128.0,
                    width: 128.0,
                    radius: 64.0,
                    placeHolder: Icons.person,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business name',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: textColor),
                      ),
                      Text(
                        'Telephone number',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: textColor.withAlpha(200)),
                      ),
                      Text('Email', style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: textColor.withAlpha(200)),),
                      Text('Website link', style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: textColor.withAlpha(200)),),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Text('Location:'),
              Text('Category'),
              Text('Description'),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 90,
                  itemBuilder: (BuildContext context, int i) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ImagesViewerScreen(
                              // urls: 'post.images',
                              index: i - 1,
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding:
                                const EdgeInsets.only(top: 10.0, right: 10),
                            child: NetworkImageWithPlaceHolder(
                              imageUrl: '',
                              width: 200,
                              height: 200,
                              placeHolder: Icons.photo,
                              iconSize: 18.0,
                              radius: 20.0,
                            ),
                          ),
                          // if (post.images!.length > 5 &&
                          //     i == 5)
                          //   Container(
                          //     padding:
                          //         const EdgeInsets.all(0.0),
                          //     alignment: Alignment.center,
                          //     color: Colors.white
                          //         .withOpacity(0.5),
                          //     child: Text(
                          //       '+${post.images!.length - 5}',
                          //       style: headline6.copyWith(
                          //         fontWeight:
                          //             FontWeight.bold,
                          //       ),
                          //     ),
                          //   )
                          // else
                          //   Container()
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
