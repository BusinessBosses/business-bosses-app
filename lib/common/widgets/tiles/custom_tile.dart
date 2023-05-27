import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Custom Tile For Forums Categories GridView
class CustomTile extends StatelessWidget {
  final Function() onTap;
  final String label;
  final String photo;
  final bool hideIcon;
  final bool showBorder;

  const CustomTile({
    Key? key,
    required this.onTap,
    required this.label,
    required this.photo,
    this.hideIcon = false,
    this.showBorder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: Wrap(children: [
        GestureDetector(
          onTap: onTap, // Added onTap property to GestureDetector
          child: Container(

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
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
                        : const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.red,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, bottom: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: photo,
                        memCacheHeight: 512,
                        memCacheWidth: 512,
                        placeholder: (BuildContext context, String photo) =>
                            const CircularProgressIndicator(),
                        errorWidget:
                            (BuildContext context, String photo, error) =>
                                const Icon(Icons.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
