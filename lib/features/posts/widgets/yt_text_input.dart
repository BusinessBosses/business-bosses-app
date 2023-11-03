// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';

class YTTextInput extends StatelessWidget {
  const YTTextInput({
    Key? key,
    required this.titleController,
  }) : super(key: key);
  final TextEditingController titleController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: TextField(
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,

                  // onChanged: (String val) {
                  //   _postTitle = val;
                  // },
                  decoration: InputDecoration(
                    hintText: 'Paste a Youtube Video link here',
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: textColor.withOpacity(0.2),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
