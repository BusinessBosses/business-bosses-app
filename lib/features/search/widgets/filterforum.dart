import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/widgets/safety_model.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/models/forum_model.dart';

class FilterForum extends StatefulWidget {
  final List<ForumModel> filterItems;
  final bool isLoading;

  // ignore: public_member_api_docs
  const FilterForum({
    Key? key,
    this.filterItems = const <ForumModel>[],
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<FilterForum> createState() => _FilterForumState();
}

class _FilterForumState extends State<FilterForum> {
  @override
  Widget build(BuildContext context) {
    return widget.filterItems.isEmpty
        ? SafetyModel(
            icon: SvgPicture.asset(
              'assets/svgs/group.svg',
              height: 80.0,
              colorFilter: const ColorFilter.mode(hintColor, BlendMode.srcIn),
            ),
            title: 'No forum to show you',
            subTitle: 'Your search forums will be displayed here!',
            isLoading: widget.isLoading,
          )
        : ListView.separated(
            key: ValueKey<List<ForumModel>>(widget.filterItems),
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemCount: widget.filterItems.length,
            itemBuilder: (BuildContext context, int i) {
              return Container();
              //  ForumItem();
            },
          );
  }
}
