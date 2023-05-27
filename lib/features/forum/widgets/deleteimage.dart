import 'package:flutter/material.dart';

Widget deleteImage(int index) {
  bool isProcessing = false;
  return Positioned(
    right: 5.0,
    top: 5.0,
    child: GestureDetector(
      onTap: isProcessing ? null : () => _removeImage(index),
      child: Container(
        height: 30.0,
        width: 30.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(40.0),
        ),
        child: const Icon(
          Icons.close,
          size: 18.0,
          color: Colors.white,
        ),
      ),
    ),
  );
}

void _removeImage(int index) {}
