import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/courses/models/course_model.dart';
import 'package:business_bosses_v2/features/forum/widgets/downloadable_item.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ExpandedCourseScreen extends StatefulWidget {
  static const String routeName = '/expandedcoursescreen';
  final CourseModel course;

  const ExpandedCourseScreen({Key? key, required this.course})
      : super(key: key);

  @override
  _ExpandedCourseScreenState createState() => _ExpandedCourseScreenState();
}

class _ExpandedCourseScreenState extends State<ExpandedCourseScreen> {
  String? description;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize data or perform any other necessary setup
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              centerTitle: true,
              title: Text(
                widget.course.title!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              expandedHeight: 300.0,
              collapsedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: YoutubeDisplay(
                    widget.course.youtubeUrls![0],
                    corner: BorderRadius.circular(0),
                  ),
                ),
              ),
            ),
          ];
        },
        body: MyStickyHeader(course: widget.course),
      ),
    );
  }
}

class MyStickyHeader extends StatelessWidget {
  final CourseModel course;

  const MyStickyHeader({required this.course});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Text(
                            course.title!,
                            overflow: TextOverflow
                                .ellipsis, // or TextOverflow.ellipsis
                            maxLines: 5,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Icon(
                          Icons.more_horiz,
                          size: 20,
                          color: Colors.black,
                          weight: 100,
                        )
                      ],
                    ),
                    Text(
                      course.description!,
                      style: const TextStyle(fontSize: 15, color: textColor),
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: NetworkImageWithPlaceHolder(
                                imageUrl: course.user?.photoUrl ?? '',
                                radius: radius,
                                placeHolder: Icons.person,
                                iconSize: 15.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          overflow:
                              TextOverflow.ellipsis, // or TextOverflow.ellipsis
                          maxLines: 1,
                          course.user?.name ?? course.user!.name!,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.star,
                          color: Color.fromRGBO(255, 202, 40, 1),
                          size: 16,
                        ),
                        Text(
                          course.averageRating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {},
                          icon: const Icon(Icons.remove_red_eye_outlined,
                              size: 19, color: Colors.black),
                          label: Text(
                            '${course.views.toString()} ${course.views == 1 ? 'View' : 'Views'}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: textColor.withOpacity(0.8),
                                ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: course.youtubeUrls?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: [
                                Stack(children: [
                                  SizedBox(
                                    height: 90,
                                    width: 160,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: FittedBox(
                                        fit: BoxFit.fill,
                                        child: Stack(
                                          children: <Widget>[
                                            GestureDetector(
                                                onTap: () {},
                                                child: YoutubeDisplay(course
                                                    .youtubeUrls![index])),
                                            Positioned(
                                              top: 0,
                                              bottom: 0,
                                              right: 0,
                                              left: 0,
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Icon(
                                                  Icons.play_circle_outlined,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  size: 70,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      height: 90,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: course.courseType == 'free'
                          ? const SizedBox()
                          : ElevatedButton(
                              onPressed: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Wrap(
                                  runAlignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Text('Buy Course for '),
                                    SvgPicture.asset('assets/svgs/coin.svg'),
                                    Text(course.price!)
                                  ],
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: backgroundcolorinterface,
                      height: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: backgroundcolorinterface,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('Video Transcript'),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                  'Video Transcript Text here iuhuh uhiuh hiuhuhiuhiiu gu giuiukg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (course.documents != null &&
                        course.documents!.isNotEmpty)
                      const SizedBox(
                        height: 30,
                      ),
                    if (course.documents != null &&
                        course.documents!.isNotEmpty)
                      const Text(
                        'Downloadable Resources',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    if (course.documents != null &&
                        course.documents!.isNotEmpty)
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: course.documents?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return DownloadableItem(
                                link: course.documents![index],
                              ); // Assuming DownloadableItem is a widget class
                            }),
                      ),
                    if (course.documents != null &&
                        course.documents!.isNotEmpty)
                      const SizedBox(
                        height: 100,
                      )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 90,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: backgroundcolorinterface,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset('assets/svgs/comment.svg'),
                        onPressed: () {},
                      ),
                      const Text('Comment'),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/svgs/star.svg',
                          height: 18,
                        ),
                        onPressed: () {},
                      ),
                      const Text('Rate'),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset(
                            'assets/svgs/share.svg',
                            height: 18,
                          ),
                          onPressed: () {},
                        ),
                        const Text('Share'),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
