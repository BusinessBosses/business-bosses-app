// ignore_for_file: public_member_api_docs, duplicate_ignore

import 'package:flutter/widgets.dart';

// ignore: duplicate_ignore
/// SizeConfig
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  // ignore: public_member_api_docs
  static double screenWidth = 0.0;
  // ignore: public_member_api_docs
  static double screenHeight = 0.0;
  // ignore: public_member_api_docs
  static double blockSizeHorizontal = 0.0;
  // ignore: public_member_api_docs
  static double blockSizeVertical = 0.0;
  static double _safeAreaHorizontal = 0.0;
  static double _safeAreaVertical = 0.0;
  static double safeBlockHorizontal = 0.0;
  // ignore: public_member_api_docs
  static double safeBlockVertical = 0.0;

  /// SizeConfig
  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        (_mediaQueryData.padding.left) + (_mediaQueryData.padding.right);
    _safeAreaVertical =
        (_mediaQueryData.padding.top) + (_mediaQueryData.padding.bottom);
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }
}
