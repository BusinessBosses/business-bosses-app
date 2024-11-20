import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class CustomEditText extends StatelessWidget {
  final String caption;
  final Widget? optionalText;
  final String hintText;
  final int? maxLength;
  final TextInputType inputType;
  final bool isPassword;
  final TextEditingController controller;
  final TextEditingController? currencycontroller;
  final TextEditingController? pm1controller;
  final TextEditingController? pm2controller;
  final TextEditingController? pm3controller;
  final TextEditingController? pm4controller;
  final String? pmh1;
  final String? pmh2;
  final String? pmh3;
  final String? pmh4;
  final Color? backgroundcolor;
  final bool? iscurrencyfield;
  final Color? currencyfieldcolor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final double? padding;
  final bool? ispaymentfield;

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
    this.optionalText,
    this.validator,
    this.onChanged,
    this.padding,
    this.currencycontroller,
    this.ispaymentfield,
    this.pm1controller,
    this.pm2controller,
    this.pm3controller,
    this.pm4controller,
    this.pmh1,
    this.pmh2,
    this.pmh3,
    this.pmh4,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 15.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: backgroundcolor ?? Colors.white),
        padding: EdgeInsets.only(
            left: 15.0,
            top: 15,
            right: 15,
            bottom: maxLength != null && maxLength! > 14 && maxLength! != 300
                ? 0
                : 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    caption,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  optionalText ?? Container()
                ]),
            if (ispaymentfield == null)
              (iscurrencyfield == true)
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                          width: 40,
                          child: TextFormField(
                            controller: currencycontroller,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'USD',
                              fillColor: currencyfieldcolor ?? prosemibackColor,
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 5.0,
                                vertical: 0.0,
                              ),
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide.none,
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
                            style: const TextStyle(fontSize: 13),
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
                            validator: validator,
                            onChanged: onChanged,
                          ),
                        ),
                      ],
                    )
                  : TextFormField(
                      style: const TextStyle(fontSize: 13),
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
                      validator: validator,
                      onChanged: onChanged,
                    ),
            if (ispaymentfield == true)
              Column(children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: pmh1,
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 13),
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: pmh2,
                    border: InputBorder.none,
                  ),
                ),
                TextFormField(
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: pmh3,
                      border: InputBorder.none,
                    )),
                TextFormField(
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: pmh4,
                      border: InputBorder.none,
                    ))
              ])
          ],
        ),
      ),
    );
  }
}
