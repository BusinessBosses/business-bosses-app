import 'package:flutter/material.dart';

import '../../../utils/theme/theme.dart';

Widget buildChoiceChips(List<String> data) {
  return SizedBox(
    child: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              Chip(
                backgroundColor: backgroundcolorinterface,
                avatar: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 5,
                ),
                label: Text(
                  data[index],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
