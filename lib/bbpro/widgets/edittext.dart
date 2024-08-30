import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomEditText extends StatelessWidget {
  final String caption;
  final String hintText;
  final int? maxLength;
  final TextInputType inputType;
  final bool isPassword;
  final TextEditingController controller;
  final Color? backgroundcolor;
  final bool? iscurrencyfield;
  final Color? currencyfieldcolor;

  const CustomEditText({
    super.key,
    required this.caption,
    required this.hintText,
    this.maxLength,
    this.inputType = TextInputType.text,
    this.isPassword = false,
    required this.controller,
    this.backgroundcolor,
    this.iscurrencyfield,
    this.currencyfieldcolor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundcolor ?? Colors.white),
        padding: EdgeInsets.only(
            left: 15.0, top: 15, right: 15, bottom: maxLength != null ? 15 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            (iscurrencyfield == true)
                ? Row(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 40,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'USD',
                            fillColor: currencyfieldcolor ?? prosemibackColor,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical:
                                  0.0, // Adjusted vertical padding for centering
                            ),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  5.0), // Set the border radius here
                              borderSide:
                                  BorderSide.none, // Removes the default border
                            ),
                          ),
                          textAlign: TextAlign.left,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLength: 3,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          maxLines:
                              maxLength != null && maxLength! > 30 ? 5 : 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: hintText,
                            filled: false,
                            fillColor: Colors.grey.shade100,
                            counterText: maxLength != null && maxLength! > 30
                                ? null
                                : '',
                          ),
                          maxLength: maxLength,
                          keyboardType: inputType,
                          obscureText: isPassword,
                          controller: controller,
                        ),
                      ),
                    ],
                  )
                : TextFormField(
                    maxLines: maxLength != null && maxLength! > 30 ? 5 : 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
                      filled: false,
                      fillColor: Colors.grey.shade100,
                      counterText:
                          maxLength != null && maxLength! > 30 ? null : '',
                    ),
                    maxLength: maxLength,
                    keyboardType: inputType,
                    obscureText: isPassword,
                    controller: controller,
                  ),
          ],
        ),
      ),
    );
  }
}
