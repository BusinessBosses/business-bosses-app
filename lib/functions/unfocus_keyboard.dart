import 'package:flutter/material.dart';

/// REMOVE FOCUS ON KEYBOARD
void unFocusKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
