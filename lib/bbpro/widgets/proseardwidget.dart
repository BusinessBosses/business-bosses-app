import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/theme/theme.dart';

// ignore: public_member_api_docs
class ProSearchbar extends StatelessWidget {
  // ignore: public_member_api_docs
  final String hintText;
  // ignore: public_member_api_docs
  final Function(String val)? onChange;
  // ignore: public_member_api_docs
  final Function(String val)? onSubmit;
  // ignore: public_member_api_docs
  final bool hasSearchIcon;
  // ignore: public_member_api_docs
  final bool autofocus;

  final Color? backgroundColor;

  final double? contentPadding;

  final double? radius;

  // ignore: public_member_api_docs
  const ProSearchbar({
    Key? key,
    this.hintText = 'Search',
    this.onChange,
    this.onSubmit,
    this.hasSearchIcon = true,
    this.autofocus = true,
    this.backgroundColor,
    this.contentPadding,
    this.radius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      textInputAction: TextInputAction.search,
      decoration: inputDecoration.copyWith(
        fillColor: backgroundColor ?? Colors.white,
        contentPadding: EdgeInsets.symmetric(
            horizontal: contentPadding ?? 0.0, vertical: contentPadding ?? 0.0),
        hintText: hintText,
        prefixIcon: hasSearchIcon == false
            ? null
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                child: SvgPicture.asset(
                  'assets/svgs/search.svg',
                  height: 20,
                  color: hintColor,
                ),
              ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius ?? 100.0),
          borderSide: BorderSide.none,
        ),
        // enabledBorder: OutlineInputBorder(
        //   borderRadius:
        //       BorderRadius.circular(10.0), // Add BorderRadius for enabled state
        //   borderSide: BorderSide.none,
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderRadius:
        //       BorderRadius.circular(10.0), // Add BorderRadius for focused state
        //   borderSide: BorderSide(
        //       color: proprimaryColor), // Customize border color when focused
        // ),
      ),
    );
  }
}
