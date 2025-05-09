// ignore_for_file: public_member_api_docs

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:detectable_text_field/detectable_text_field.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  const TextInput(
      {super.key,
      required this.onDetectionTyped,
      required this.titleController,
      required this.onDetectionFinished,
      this.isPost = true});
  final Function(String) onDetectionTyped;
  final DetectableTextEditingController titleController;
  final VoidCallback onDetectionFinished;
  final bool isPost;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Container(
              height: 180,
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: DetectableTextField(
                  regExp: detectionRegExp(hashtag: false)!,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  textInputAction: TextInputAction.newline,
                  maxLength: 300,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                  // onChanged: (String val) {
                  //   _postTitle = val;
                  // },
                  decoration: InputDecoration(
                    hintText: isPost
                        ? 'What’s on your mind?'
                        : 'Ask your question here',
                    border: InputBorder.none,
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: hintColor,
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
