// ignore_for_file: public_member_api_docs

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_plus/flutter_swiper_plus.dart';

import '../../../common/widgets/network_image_with_placeholder.dart';
import '../../../utils/theme/theme.dart';

class ImagesViewerScreen extends StatefulWidget {
  final List<dynamic>? urls;
  final int index;
  final String? text;

  const ImagesViewerScreen({
    Key? key,
    this.urls,
    this.index = 0,
    this.text,
  }) : super(key: key);

  @override
  _ImagesViewerScreenState createState() => _ImagesViewerScreenState();
}

class _ImagesViewerScreenState extends State<ImagesViewerScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool _isFullTextVisiable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          widget.urls == null
              ? Container()
              : Swiper(
                  index: widget.index,
                  loop: false,
                  itemCount: widget.urls!.length,
                  itemBuilder: (BuildContext context, int i) =>
                      InteractiveViewer(
                    child: NetworkImageWithPlaceHolder(
                      cacheHeight: 2200,
                      imageUrl: widget.urls![i],
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height,
                      // placeHolder: Icons.photo,
                      placeHolderType: PlaceHolderType.progress,
                      progressCircleColor: Colors.white,
                      iconSize: 56.0,
                      radius: 0.0,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
          if (widget.text != null && widget.text!.isNotEmpty)
            Positioned(
              bottom: 20.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                color: Colors.black.withOpacity(0.4),
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      _isFullTextVisiable
                          ? TextSpan(
                              text: widget.text,
                              style: bodyText1.copyWith(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          : TextSpan(
                              text: widget.text.toString(),
                              style: bodyText1.copyWith(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                      const TextSpan(text: ' '),
                      if (widget.text!.length > 200)
                        TextSpan(
                          text: _isFullTextVisiable ? 'see less' : 'see more',
                          style: bodyText1.copyWith(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              setState(() {
                                _isFullTextVisiable = !_isFullTextVisiable;
                              });
                            },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            right: 10.0,
            top: 36.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 36.0,
                height: 36.0,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: const Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
