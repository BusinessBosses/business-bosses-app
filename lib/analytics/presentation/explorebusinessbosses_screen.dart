import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

import '../../features/posts/widgets/my_container.dart';
import '../../utils/theme/theme.dart';
import 'package:business_bosses_v2/features/posts/widgets/youtube_display.dart';
import 'package:business_bosses_v2/features/posts/widgets/yt_player.dart';

class ExplorebusinessbossesScreen extends StatefulWidget {
  static const String routeName = '/explorebusinessbossesscreen';

  const ExplorebusinessbossesScreen({Key? key}) : super(key: key);

  @override
  _ExplorebusinessbossesScreenState createState() =>
      _ExplorebusinessbossesScreenState();
}

class _ExplorebusinessbossesScreenState
    extends State<ExplorebusinessbossesScreen> {
  String? description;
  bool isLoading = false;
  String youtubeUrl = "https://www.youtube.com/watch?v=3gm6eBtWfi4";

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
        final data = jsonDecode(response.body);

        if (data != null &&
            data['data'] != null &&
            data['data']['rows'] != null) {
          final rows = data['data']['rows'];
          final features = rows.firstWhere(
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
      print('Error occurred while fetching data: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'Explore Business Bosses',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: MyContainer(
        margin: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
        padding: const EdgeInsets.all(16.0),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(),
                  ),
                )
              : description == null
                  ? const Text(
                      'Description',
                      style: bodyText2,
                    )
                  : Container(
                      child: Column(
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        YoutubeVideo(
                                      youtubeUrl,
                                    ),
                                  ),
                                );
                              },
                              child: YoutubeDisplay(youtubeUrl ?? "")),
                          const SizedBox(
                            height: 20,
                          ),
                          Linkify(
                            onOpen: (LinkableElement link) async {
                              if (await canLaunchUrl(Uri.parse(link.url))) {
                                await launchUrl(Uri.parse(link.url));
                              } else {
                                showSnackbar(
                                    message:
                                        'Could not launch URL: ${link.url}');
                              }
                            },
                            text: description!,
                            style: bodyText2,
                            linkStyle: const TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
