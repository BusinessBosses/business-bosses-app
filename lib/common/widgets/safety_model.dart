import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';

class SafetyModel extends StatelessWidget {
  final bool isLoading;
  final Widget icon;
  final String title;
  final String subTitle;
  final String? clickableText;
  final Function()? onTap;

  final MainAxisAlignment mainAxisAlignment;

  const SafetyModel({
    super.key,
    this.isLoading = true,
    this.icon = const Icon(
      Icons.warning,
      size: 0.0,
      color: Color(0xFF616161),
    ),
    this.title = 'No data found',
    this.subTitle = '',
    this.clickableText = '',
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (OverscrollIndicatorNotification overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isLoading
                        ? const SizedBox(
                            height: 24.0,
                            width: 24.0,
                            child: CircularProgressIndicator.adaptive(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              icon,
                              const SizedBox(height: 16.0),
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: bodyText1,
                              ),
                              const SizedBox(height: 4.0),
                              if (subTitle.isNotEmpty)
                                Text(
                                  subTitle,
                                  textAlign: TextAlign.center,
                                  style: bodyText2.copyWith(
                                    color: Color(0xFF616161),
                                  ),
                                ),
                              clickableText != null
                                  ? TextButton(
                                      onPressed: onTap,
                                      child: Text(clickableText!),
                                    )
                                  : Container(),
                            ],
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
