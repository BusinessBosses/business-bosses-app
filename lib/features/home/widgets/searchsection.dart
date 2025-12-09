import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.completesearchingscreen),
      child: Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: hintColor)),
          height: 45,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(
                'assets/svgs/search.svg',
                colorFilter:
                    const ColorFilter.mode(Colors.black45, BlendMode.srcIn),
                height: 20,
              ),
              const SizedBox(width: 7),
              const Text(
                'Search People and Posts',
                style: TextStyle(fontSize: 14, color: Colors.black45),
              )
            ],
          )),
    );
  }
}
