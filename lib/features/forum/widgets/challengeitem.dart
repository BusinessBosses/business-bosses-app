import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/forum/widgets/gettimeleft.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Challengeitem extends StatelessWidget {
  final OnTap;
  final String? title;
  final String? imageurl;
  final String? time;
  final String? categorytype;
  final Industry? category;
  final bool? iscustom;
  final String? description;

  const Challengeitem(
      {super.key,
      this.OnTap,
      this.title,
      this.imageurl,
      this.time,
      this.category,
      this.categorytype,
      this.iscustom,
      this.description});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: OnTap,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
            decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Colors.black12),
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title ?? '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                    SvgPicture.asset(
                      'assets/svgs/nexticon.svg',
                      color: textColor,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 86,
                      width: 142,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9.9),
                          border: Border.all(
                            color: Colors.black12,
                            width: 0.5,
                          )),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: iscustom == true
                              ? Image.asset(imageurl ?? '')
                              : CachedNetworkImage(
                                  width: 120,
                                  imageUrl: imageurl ?? '',
                                  memCacheHeight: 256,
                                  memCacheWidth: 256,
                                  placeholder:
                                      (BuildContext context, String photo) =>
                                          const Center(
                                    child: SizedBox(
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (BuildContext context,
                                          String photo, dynamic error) =>
                                      const Icon(Icons.error),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    description != null
                        ? Flexible(
                            child: Text(
                              description ?? '',
                              softWrap: true,
                              style: TextStyle(fontSize: 13),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    categorytype ?? '',
                                    style: const TextStyle(
                                      color: primaryColorLT,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  if (categorytype != null)
                                    const Icon(
                                      Icons.watch_later_outlined,
                                      size: 15,
                                      color: Colors.grey,
                                    ),
                                  if (title != '')
                                    const SizedBox(
                                      width: 5,
                                    ),
                                  Text(
                                    time ?? '',
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (category != null)
                                getChallengeTimeLeft(category!)
                            ],
                          )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
