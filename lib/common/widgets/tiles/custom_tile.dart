import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Custom Tile For Forums Categories GridView
class CustomTile extends StatelessWidget {
  /// What happens when it is tapped
  final Function() onTap;

  final String label;
  final String photo;
  final bool hideIcon;
  final bool showBorder;

  /// Custom tile constructor
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
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
          child: Column(
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
                padding: const EdgeInsets.only(left: 7.0, right: 7.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    imageUrl: photo,
                    memCacheHeight: 512,
                    memCacheWidth: 512,
                    placeholder: (context, photo) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, photo, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
