import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/theme/theme.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final Function(String val) onChange;
  final Function(String val) onSubmit;
  final bool hasSearchIcon;
  final bool autofocus;

  const SearchBar({
    Key? key,
    this.hintText = 'Search',
    required this.onChange,
    required this.onSubmit,
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
