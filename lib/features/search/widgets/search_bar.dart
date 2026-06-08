import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/theme/theme.dart';

// ignore: public_member_api_docs
class Searchbar extends StatelessWidget {
  // ignore: public_member_api_docs
  final String hintText;
  // ignore: public_member_api_docs
  final Function(String val)? onChange;
  final FocusNode? focusNode;
  // ignore: public_member_api_docs
  final Function(String val)? onSubmit;
  // ignore: public_member_api_docs
  final bool hasSearchIcon;
  // ignore: public_member_api_docs
  final bool autofocus;

  final bool? ismarketplace;

  final VoidCallback? onfiltertap;

  // ignore: public_member_api_docs
  const Searchbar({
    super.key,
    this.hintText = 'Search',
    this.onChange,
    this.onSubmit,
    this.hasSearchIcon = true,
    this.autofocus = true,
    this.focusNode,
    this.ismarketplace = false,
    this.onfiltertap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TextFormField(
          autofocus: autofocus,
          onChanged: onChange,
          onFieldSubmitted: onSubmit,
          textInputAction: TextInputAction.search,
          decoration: inputDecoration.copyWith(
            contentPadding: const EdgeInsets.all(0.0),
            hintText: hintText,
            prefixIcon: hasSearchIcon == false ? SizedBox() : SizedBox(),
          ),
        ),
        if (ismarketplace!)
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
      ],
    );
  }
}
