import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../common/widgets/safety_model.dart';
import '../../../common/widgets/tiles/custom_tile.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/models/industry.dart';

class MySearchIndustries extends StatelessWidget {
  final List<Industry> searchIndustries;
  final bool isLoading;

  const MySearchIndustries({
    Key? key,
    this.searchIndustries = const <Industry>[],
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return searchIndustries.isEmpty
        ? SafetyModel(
            mainAxisAlignment: MainAxisAlignment.start,
            isLoading: isLoading,
            icon: SvgPicture.asset('assets/svgs/search.svg',
                color: hintColor, height: 80.0, width: 80.0),
            title: 'Search for industries',
            subTitle: 'Search for specific industry!',
          )
        : ListView.builder(
            padding: const EdgeInsets.only(
              top: 8.0,
              right: 8.0,
              left: 8.0,
              bottom: 120.0,
            ),
            itemCount: searchIndustries.length,
            itemBuilder: (BuildContext context, int i) {
              return CustomTile(
                label: searchIndustries[i].industry!,
                photo: searchIndustries[i].photo!,
                onTap: () {
                  // searchIndustries[i]
                  //         .industryId
                  //         .contains('-MsUPNEHnp8-An5VLI_v')
                  //     ? Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => BottomNavScreen(2, true),
                  //         ),
                  //       )
                  //     : searchIndustries[i]
                  //             .industryId
                  //             .contains('-MsUOGcOT9oRXGakCcJv')
                  //         ? Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => BottomNavScreen(1, true),
                  //             ),
                  //           )
                  //         : navigateTo(
                  //             context,
                  //             routeName: AllForumScreen.routeName,
                  //             arguments: searchIndustries[i].industryId,
                  //           );
                },
              );
            },
          );
  }
}
