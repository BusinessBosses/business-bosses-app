import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/theme/theme.dart';

// ignore: public_member_api_docs
class SearchBar extends StatelessWidget {
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

  // ignore: public_member_api_docs
  const SearchBar({
    Key? key,
    this.hintText = 'Search',
    this.onChange,
    this.onSubmit,
    this.hasSearchIcon = true,
    this.autofocus = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: autofocus,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      textInputAction: TextInputAction.search,
      decoration: inputDecoration.copyWith(
        contentPadding: const EdgeInsets.all(0.0),
        hintText: hintText,
        prefixIcon: hasSearchIcon == false
            ? null
            : Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
                child: SvgPicture.asset(
                  'assets/svgs/search.svg',
                  color: hintColor,
                ),
              ),
      ),
    );
  }
}
