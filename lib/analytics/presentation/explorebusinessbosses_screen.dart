import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../utils/theme/theme.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';

class ExplorebusinessbossesScreen extends StatefulWidget {
  static const String routeName = '/explorebusinessbossesscreen';

  const ExplorebusinessbossesScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ExplorebusinessbossesScreenState createState() =>
      _ExplorebusinessbossesScreenState();
}

class _ExplorebusinessbossesScreenState
    extends State<ExplorebusinessbossesScreen> {
  String? description;
  bool isLoading = false;
  String youtubeUrl = 'https://www.youtube.com/watch?v=3gm6eBtWfi4';

  @override
  void initState() {
    super.initState();
    fetchDescription();
  }

  Future<void> fetchDescription() async {
    setState(() {
      isLoading = true;
    });

    try {
      final http.Response response = await http.get(
        Uri.parse('https://orca-app-5dg8w.ondigitalocean.app/api/v1/admin'),
      );

      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);

        if (data != null &&
            data['data'] != null &&
            data['data']['rows'] != null) {
          final dynamic rows = data['data']['rows'];
          // ignore: always_specify_types
          final features = rows.firstWhere(
            // ignore: always_specify_types
            (item) => item['title'] == 'features',
            orElse: () => null,
          );

          if (features != null && features['description'] != null) {
            setState(() {
              description = features['description'];
            });
          }
        }
      }
    } catch (error) {
      // Handle network or parsing errors
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
          'How to use Business Bosses App',
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              width: double.infinity,
              height: 20,
              child: ColoredBox(color: backgroundcolorinterface),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          // ignore: always_specify_types
                          MaterialPageRoute(
                            builder: (BuildContext context) => YoutubeVideo(
                              youtubeUrl,
                            ),
                          ),
                        );
                      },
                      child: YoutubeDisplay(youtubeUrl)),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 50.0),
                      Text(
                        'Profile',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Keep your bio up to date as a virtual business card \n• Showcase your products or services to find new opportunities',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/exploreone.png'),
                      Text(
                        'Content Feed',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Engage with content from posts and topics you\'re interested in \n• Create & post relevant content for an opportunity to get discovered',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/explore2.png'),
                      Text(
                        'Networking & Referrals',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Get connected & connections from entrepreneurs around the globe\n• Invite contacts for a quick & easy way to grow your network & get free promotion\n• 1 to 1 chat to follow up meaningful conversations\n• Give and receive Business referrals',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/explore3.png'),
                      Text(
                        'Community',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Network with new contacts & easily find your industry experts\n• Join groups with topics that support your educational & business goals\n• Enter Boss Up Challenge for a chance to become "Boss of the week"',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Image.asset('assets/images/explorefour.png'),
                      Text(
                        'Analyser',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• See your analytics and statistics\n• Easy navigation within Business Bosses',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/explore5.png'),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Search & Notifications',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Find users and posts through the home page search\n• Find groups and topics through community search\n• Receive daily motivational quotes\n• Receive alerts from your network activities',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/explore6.png'),
                      Text(
                        'Marketplace',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Sell your products and services\n• Selling is easy, you can add price, description, photos',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/explore7.png'),
                      Text(
                        'Events',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Create events with description, date, and time.\n• Participants can attend, share and save live events.',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/explore8.png'),
                      Text(
                        'Polls & Survey',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                      Text(
                        '• Post polls and surveys to gather feedback\n• Use the feedback to improve your business offerings.',
                        style: bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                        ),
                      ),
                      Image.asset('assets/images/explore9.png'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
