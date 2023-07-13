// ignore_for_file: public_member_api_docs

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWithPlaceHolder extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double? iconSize;
  final int cacheHeight;
  final int cacheWidth;
  final double radius;
  final IconData? placeHolder;
  final Color? color;
  final Color? borderColor;
  final BoxFit fit;
  final PlaceHolderType placeHolderType;
  final Color? progressCircleColor;
  final double progressCircleHeight;

  const NetworkImageWithPlaceHolder({
    Key? key,
    required this.imageUrl,
    this.placeHolder,
    this.width = 120.0,
    this.height = 120.0,
    this.iconSize,
    this.cacheHeight = 900,
    this.cacheWidth = 900,
    this.radius = 10.0,
    this.color,
    this.borderColor,
    this.fit = BoxFit.cover,
    this.placeHolderType = PlaceHolderType.icon,
    this.progressCircleColor,
    this.progressCircleHeight = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // iconSize = iconSize ?? height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 0.5)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: CachedNetworkImage(
            // memCacheHeight: cacheHeight,
            imageUrl:
                imageUrl ?? '' /* == null ? 'https://www.error' : imageUrl*/,
            fit: fit,
            errorWidget: (_, __, ___) => Container(
              color: color == null
                  ? Theme.of(context).iconTheme.color!.withOpacity(0.1)
                  : color!.withOpacity(0.1),
              child: placeHolder == null
                  ? myProgressIndicator(context)
                  : Icon(
                      placeHolder,
                      size: iconSize,
                      color: color == null
                          ? Theme.of(context).iconTheme.color!.withOpacity(0.3)
                          : color!.withOpacity(0.3),
                    ),
            ),
            placeholder: (_, __) => Container(
              color: color == null
                  ? Theme.of(context).iconTheme.color!.withOpacity(0.1)
                  : color!.withOpacity(0.1),
              child: PlaceHolderType.icon == placeHolderType
                  ? placeHolder == null
                      ? myProgressIndicator(context)
                      : Icon(
                          placeHolder,
                          size: iconSize,
                          color: color == null
                              ? Theme.of(context)
                                  .iconTheme
                                  .color!
                                  .withOpacity(0.3)
                              : color!.withOpacity(0.3),
                        )
                  : myProgressIndicator(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget myProgressIndicator(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: progressCircleHeight,
      width: progressCircleHeight,
      child: CircularProgressIndicator(
        backgroundColor: progressCircleColor ?? Colors.white,
      ),
    );
  }
}

enum PlaceHolderType {
  icon,
  progress,
}
