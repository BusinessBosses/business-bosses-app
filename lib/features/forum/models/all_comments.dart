import 'package:business_bosses_v2/common/models/comment_model.dart';
import 'package:flutter/material.dart';

import '../../posts/widgets/comment_item.dart';

class AllComments extends StatelessWidget {
  final List<CommentModel> comments;

  const AllComments(this.comments, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('AllComments.build asdf');
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: comments.length,
      itemBuilder: (BuildContext context, int i) {
        return CommentItem(comments[i]);
        //   Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: Row(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       MyContainer(
        //         width: MediaQuery.of(context).size.width * 0.7,
        //         padding: EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             ListTile(
        //               leading: NetworkImageWithPlaceHolder(
        //                 imageUrl: comments[i].userPhotoUrl,
        //                 height: 36.0,
        //                 width: 36.0,
        //                 radius: 30.0,
        //                 placeHolder: Icons.person,
        //               ),
        //               title: Text(
        //                 '${comments[i].userName}',
        //                 style: bodyText1,
        //               ),
        //               subtitle: Text(
        //                 '${TimeFormat.formatString(comments[i].timestamp)}',
        //                 style: bodyText2.copyWith(
        //                   fontSize: 11.0,
        //                   color: hintColor,
        //                 ),
        //               ),
        //               contentPadding: EdgeInsets.all(0.0),
        //             ),
        //             Text(
        //               comments[i].comment,
        //               style: bodyText2,
        //             ),
        //             SizedBox(height: 4.0),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      },
    );
  }
}
