import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../posts/widgets/my_container.dart';
import '../../utils/theme/theme.dart';

class InviteAFriendTermsAndConditions extends StatefulWidget {
  static const String routeName = '/invite-terms-conditions';

  const InviteAFriendTermsAndConditions({Key? key}) : super(key: key);

  @override
  _InviteAFriendTermsAndConditionsState createState() =>
      _InviteAFriendTermsAndConditionsState();
}

class _InviteAFriendTermsAndConditionsState
    extends State<InviteAFriendTermsAndConditions> {
  String? description;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
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
          final terms = rows.firstWhere(
            (item) => item['title'] == 'terms',
            orElse: () => null,
          );

          if (terms != null && terms['description'] != null) {
            setState(() {
              description = terms['description'];
            });
          } else {
            // Handle the case when 'terms' object or 'description' is not found
            print("'terms' object or 'description' not found in the response");
          }
        } else {
          // Handle the case when the response data is not in the expected format
          print('Invalid response format');
        }
      } else {
        // Handle API error
        print('API request failed with status code ${response.statusCode}');
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
          'Invite a Friend Terms & Conditions',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
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
              : Text(
                  description ?? 'Description',
                  style: bodyText2,
                ),
        ),
      ),
    );
  }
}
