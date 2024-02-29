import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CourseItem extends StatefulWidget {
  const CourseItem({super.key});

  @override
  _CourseItemState createState() => _CourseItemState();
}

class _CourseItemState extends State<CourseItem> {
  String ytUrl =  "https://www.youtube.com/watch?v=3gm6eBtWfi4";
  ProfileController profileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 180,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            YoutubeVideo(
                                          ytUrl!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: YoutubeDisplay(ytUrl!)),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            YoutubeVideo(
                                          ytUrl!,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    Icons.play_circle_outlined,
                                    color: Colors.black.withOpacity(0.5),
                                    size: 70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Course Title'),
                        Text('Course Description'),
                        Row(
                          children: [
                            Text('by'),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              height: 25.0,
                              width: 25.0,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(1000),
                                  child: NetworkImageWithPlaceHolder(
                                    imageUrl:
                                        profileController.myProfile.photoUrl ??
                                            '',
                                    radius: radius,
                                    placeHolder: Icons.person,
                                    iconSize: 18.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('Person Name'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: backgroundcolorinterface,
                      borderRadius: BorderRadius.circular(50)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, top: 5, right: 8, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/svgs/coin.svg',
                          height: 22,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          '500',
                          style: const TextStyle(
                            color: Color.fromRGBO(133, 133, 133, 1),
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.star,
                  color: Color.fromRGBO(255, 202, 40, 1),
                  size: 16,
                ),
                Text(
                  ' 4.7 ratings',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/transcript.svg',
                      height: 18,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      'assets/svgs/closedcaption.svg',
                      height: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      'assets/svgs/downloadables.svg',
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextButton.icon(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/svgs/comment.svg',
                    height: 15,
                  ),
                  label: Text(
                    '0 Comments',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: textColor.withOpacity(0.8),
                        ),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {},
                icon: const Icon(Icons.remove_red_eye_outlined,
                    size: 19, color: Colors.black),
                label: Text(
                  '0 Views',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor.withOpacity(0.8),
                      ),
                ),
              ),
              const SizedBox(width: 8.0),
              GestureDetector(
                onTap: () => {},
                child: SvgPicture.asset(
                  'assets/svgs/share.svg',
                  height: 15.0,
                  width: 15.0,
                  color: textColor.withOpacity(1.0),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  'Time',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: textColor.withOpacity(0.4)),
                ),
              )
            ],
          ),
          Container(
            color: backgroundcolorinterface,
            height: 7,
          )
        ],
      ),
    );
  }
}
