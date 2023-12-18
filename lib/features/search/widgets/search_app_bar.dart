import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/theme/theme.dart';

PreferredSizeWidget SearchAppBar({
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
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      textInputAction: TextInputAction.search,
      decoration: inputDecoration.copyWith(
        contentPadding: const EdgeInsets.all(0.0),
        hintText: hintText,
      ),
    ),
  );
}
