import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';

class SafetyModel extends StatelessWidget {
  final bool isLoading;
  final Widget icon;
  final String title;
  final String subTitle;
  final String clickableText;
  final Function? onTap;

  final MainAxisAlignment mainAxisAlignment;

  const SafetyModel(
      {Key? key,
      this.isLoading = true,
      this.icon = const Icon(
        Icons.warning,
        size: 0.0,
        color: Colors.grey,
      ),
      this.title = 'No data found',
      this.subTitle = '',
      this.clickableText = '',
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? const SizedBox(
                            child: CircularProgressIndicator.adaptive(),
                            height: 24.0,
                            width: 24.0,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
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
                                    color: Colors.grey,
                                  ),
                                ),
                              clickableText != null
                                  ? TextButton(
                                      onPressed: () {},
                                      child: Text(clickableText),
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
