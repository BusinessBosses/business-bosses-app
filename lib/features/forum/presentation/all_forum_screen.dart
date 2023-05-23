import 'package:business_bosses_v2/features/forum/models/forum_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../navigation/routes.dart';
import '../models/industry.dart';
import '../../../utils/theme/theme.dart';
import '../widgets/joinedbutton.dart';

// ignore: public_member_api_docs
class AllForumScreen extends StatelessWidget {
  // ignore: public_member_api_docs
  static const String routeName = 'all-forum-screen';

  // ignore: public_member_api_docs
  const AllForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final ScrollController scrollController = ScrollController();
    Industry industry = Industry();
    final List<ForumModel> forums = [];

    return Scaffold(
        backgroundColor: backgroundcolorinterface,
        key: scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: Text(
            industry.industry ?? 'Topic',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        body: NestedScrollView(
          controller: scrollController,
          headerSliverBuilder: (
            BuildContext context,
            bool innerBoxIsScrolled,
          ) {
            return <Widget>[
              SliverStickyHeader(
                sticky: false,
                header: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Column(children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(150, 45)),
                                onPressed: () {
                                  Get.toNamed(Routes.createForum);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Start a Topic' ?? 'Create Opportunities',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SvgPicture.asset(
                                        'assets/svgs/startatopic.svg')
                                  ],
                                ),
                              ),
                            )),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 10, right: 20, left: 20),
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.asset(
                                      'assets/images/postbackground.png'),
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 25, right: 20, left: 35),
                                      height: 86,
                                      width: 142,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: CachedNetworkImage(
                                            imageUrl: 'industry.photo!',
                                            memCacheHeight: 256,
                                            memCacheWidth: 256,
                                            placeholder: (BuildContext context,
                                                    String photo) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                // ignore: always_specify_types
                                                (BuildContext context,
                                                        // ignore: always_specify_types
                                                        String photo,
                                                        error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.only(right: 35),
                                      child: Text(
                                        industry.description ??
                                            'Industry Description',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                        softWrap: true,
                                        maxLines: 5,
                                      ),
                                    )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 35, top: 5),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8,
                                                top: 8,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                              color: primaryColorLT,
                                            ),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: SvgPicture.asset(
                                                      'assets/svgs/members.svg'),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: industry
                                                                    .joinedUsers ==
                                                                null
                                                            ? 'Members: 0'
                                                            : 'Members: (${industry.joinedUsers!.length ?? 0})',
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.white),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                // navigateTo(
                                                                //   context,
                                                                //   routeName:
                                                                //       SpecificUserListScreen
                                                                //           .routeName,
                                                                //   arguments: ParamData(
                                                                //       'Members',
                                                                //       industry
                                                                //           .joinedUsers),
                                                                // );
                                                              },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5, top: 5),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8,
                                                top: 8,
                                                left: 10,
                                                right: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                              color: const Color.fromARGB(
                                                  47, 255, 255, 255),
                                            ),
                                            child: Row(children: [
                                              SvgPicture.asset(
                                                  'assets/svgs/topics.svg'),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Topics: (${forums.length ?? 0}) ' ??
                                                          ' Opport..: (${forums.length ?? 0})',
                                                      style: const TextStyle(
                                                          fontSize: 11),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    JoinedButton(),
                                                  ],
                                                )),
                                          )),
                                    )
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    )
                  ],
                ),
              )
            ];
          },
          body: 'forums.isEmpty || industry.joinedUsers' == null
              ? const SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (BuildContext context, int index) {},
                ),
        ));
  }
}
