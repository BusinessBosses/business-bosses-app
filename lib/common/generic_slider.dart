import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

import '../features/posts/widgets/images_viewer_screen.dart';

class GenericSlider extends StatefulWidget {
  final List<String> images;
  final double width, height;
  final BoxFit fit;

  const GenericSlider({
    Key? key,
    required this.images,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
  }) : super(key: key);

  @override
  _GenericSliderState createState() => _GenericSliderState();
}

class _GenericSliderState extends State<GenericSlider> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: Stack(
          children: [
            Swiper(
                onIndexChanged: (int i) {
                  setState(() {
                    _activeIndex = i;
                  });
                },
                loop: false,
                itemCount: widget.images.length,
                itemBuilder: (BuildContext context, int i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        // ignore: always_specify_types
                        MaterialPageRoute(
                          builder: (BuildContext context) => ImagesViewerScreen(
                            urls: widget.images,
                            index: i,
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: widget.width,
                          width: widget.height,
                          margin: const EdgeInsets.only(top: 0.0),
                          child: NetworkImageWithPlaceHolder(
                            imageUrl: widget.images[i],
                            fit: widget.fit,
                            placeHolder: Icons.photo,
                            radius: 15.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 16.0,
                width: widget.images.length * 40.0,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.only(bottom: 10.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.images.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int i) {
                      return Container(
                        width: _activeIndex == i ? 16.0 : 10.0,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 2),
                        decoration: BoxDecoration(
                            color: _activeIndex == i
                                ? primaryColorLT
                                : primaryColorLT.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10.0)),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
