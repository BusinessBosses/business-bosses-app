import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.completesearchingscreen),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: backgroundColor)),
          height: 45,
          width: double.infinity,
          child: TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: inputDecoration.copyWith(
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              fillColor: backgroundColor,
              filled: true,
              enabled: false,
              prefixIcon: Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: SvgPicture.asset(
                  'assets/svgs/search.svg',
                  color: hintColor,
                ),
              ),
              hintText: 'Search people & posts',
            ),
          ),
        ),
      ),
    );
  }
}
