import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// Custom Tile For Forums Categories GridView
class CustomTile extends StatelessWidget {
  final Function() onTap;
  final String label;
  final String photo;
  final bool hideIcon;
  final bool showBorder;
  final bool? ishome;

  const CustomTile({
    Key? key,
    required this.onTap,
    required this.label,
    required this.photo,
    this.hideIcon = false,
    this.showBorder = false,
    this.ishome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: ishome == true ? 0 : 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: !showBorder
                      ? null
                      : Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 0.3,
                        ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: ishome == true
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      ishome == true
                          ? Container(
                              height: 5,
                            )
                          : ListTile(
                              title: Text(
                                label,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: hideIcon
                                  ? null
                                  : SvgPicture.asset(
                                      'assets/svgs/nexticon.svg')),
                      Stack(
                        children: <Widget>[
                          Padding(
                            padding: ishome == true
                                ? const EdgeInsets.only(left: 15)
                                : const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: 10,
                                  ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 0.5, color: Colors.black12)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: CachedNetworkImage(
                                  imageUrl: photo,
                                  memCacheHeight: 512,
                                  memCacheWidth: 512,
                                  placeholder:
                                      (BuildContext context, String photo) =>
                                          const CircularProgressIndicator(),
                                  errorWidget: (BuildContext context,
                                          String photo, Object error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          if (ishome == true)
                            Positioned(
                                bottom: 10,
                                left: 25,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: primaryColorLT,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          'assets/svgs/playicon.svg',
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          'Watch Videos',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ]),
                                ))
                        ],
                      ),
                      ishome == true
                          ? Container(
                              height: 5,
                            )
                          : Container(),
                      ishome == true
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(label,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  )),
                            )
                          : Container()
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
