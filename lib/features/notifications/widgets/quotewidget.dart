import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/models/quote.dart';
import '../../../utils/theme/theme.dart';

// ignore: non_constant_identifier_names
Widget QuoteWidget(Quote quote) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundcolorinterface,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16, top: 7),
          child: Text(
            "Today's Quote",
            style: bodyText1,
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 12.0, top: 5, right: 12, bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                  radius: 48 / 2,
                  backgroundColor: primaryColorLT.withOpacity(0.1),
                  child: SvgPicture.asset(
                    'assets/app/app_icon_only.svg',
                  )),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            ' ${quote.message}',
                            style: bodyText1.copyWith(
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        quote.by,
                        style: bodyText1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
