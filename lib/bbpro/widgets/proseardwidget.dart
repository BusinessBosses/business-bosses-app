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

  final bool? ismarketplace;

  final VoidCallback? onfiltertap;

  final VoidCallback? onTap;

  // ignore: public_member_api_docs
  const ProSearchbar({
    Key? key,
    this.hintText = 'Search',
    this.onChange,
    this.onSubmit,
    this.hasSearchIcon = true,
    this.autofocus = true,
    this.backgroundColor,
    this.ismarketplace,
    this.onfiltertap,
    this.radius,
    this.contentPadding,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      TextFormField(
        onTap: onTap,
        autofocus: autofocus,
        onChanged: onChange,
        onFieldSubmitted: onSubmit,
        style: const TextStyle(
          color: textColor,
          fontSize: 15.0,
          fontWeight: FontWeight.w700,
        ),
        textInputAction: TextInputAction.search,
        decoration: inputDecoration.copyWith(
          fillColor: backgroundColor ?? Colors.white,
          contentPadding: EdgeInsets.symmetric(
              horizontal: contentPadding ?? 0.0,
              vertical: contentPadding ?? 0.0),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: textColor,
            fontSize: 15.0,
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: hasSearchIcon == false
              ? null
              : Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 0.0),
                  child: SvgPicture.asset(
                    'assets/svgs/homesearch.svg',
                    colorFilter: const ColorFilter.mode(
                      textColor,
                      BlendMode.srcIn,
                    ),
                    height: 20,
                  ),
                ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius ?? 100.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      if (ismarketplace != null)
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: onfiltertap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: SvgPicture.asset('assets/svgs/filterprosections.svg'),
              ),
            ),
          ),
        ),
    ]);
  }
}
