import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/models/quote.dart';
import '../../../utils/theme/theme.dart';

Widget QuoteWidget(Quote quote) {
  return Container(
    decoration: BoxDecoration(
      color: backgroundcolorinterface,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            children: [
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
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ' ${quote.message ?? "Always give without remembering and always receive without forgetting."}',
                            style: bodyText1.copyWith(
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        quote.by ?? "Brian Tracy",
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
