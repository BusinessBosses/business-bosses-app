import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

PreferredSizeWidget searchAppBar({
  String hintText = 'Search',
  Function(String val)? onChange,
  Function(String val)? onSubmit,
  final bool autoFocus = true,
  final Function()? onClose,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leading: Center(
      child: SvgPicture.asset(
        'assets/svgs/search.svg',
        height: 24.0,
        width: 24.0,
      ),
    ),
    actions: <Widget>[
      IconButton(
        onPressed: onClose,
        icon: const Icon(Icons.close),
      ),
    ],
    title: TextFormField(
      autofocus: autoFocus,
      style: const TextStyle(
        color: textColor,
        fontSize: 15.0,
        fontWeight: FontWeight.w700,
      ),
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      textInputAction: TextInputAction.search,
      decoration: inputDecoration.copyWith(
        contentPadding: const EdgeInsets.all(0.0),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF616161),
          fontSize: 15.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}
