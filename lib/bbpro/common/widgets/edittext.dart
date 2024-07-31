import 'package:flutter/material.dart';

class CustomEditText extends StatelessWidget {
  final String caption;
  final String hintText;
  final int? maxLength;
  final TextInputType inputType;
  final bool isPassword;

  CustomEditText({
    required this.caption,
    required this.hintText,
    this.maxLength,
    this.inputType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        padding: EdgeInsets.only(
            left: 15.0, top: 15, right: 15, bottom: maxLength != null ? 15 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              caption,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5),
            TextFormField(
              maxLines: maxLength != null ? 5 : 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                filled: false,
                fillColor: Colors.grey.shade100,
              ),
              maxLength: maxLength,
              keyboardType: inputType,
              obscureText: isPassword,
            ),
          ],
        ),
      ),
    );
  }
}
