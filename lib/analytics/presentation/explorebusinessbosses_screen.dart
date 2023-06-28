import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../features/posts/widgets/my_container.dart';
import '../../utils/theme/theme.dart';

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
      final response = await http.get(
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
              ? Center(
                  child: Container(
                    width: 40,
                    height: 40,
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Text(
                  description ?? 'Description',
                  style: bodyText2,
                ),
        ),
      ),
    );
  }
}
