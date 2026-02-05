import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

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
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? pm5controller;
  final String? pmh1;
  final String? pmh2;
  final String? pmh3;
  final String? pmh4;
  final String? pmh5;

  final Color? backgroundcolor;
  final bool? iscurrencyfield;
  final Color? currencyfieldcolor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final double? padding;
  final bool? ispaymentfield;
  final bool? issl;
  final bool? isorder;
  final bool? isps;
  final Function(String)? onTextChanged;

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
    this.pm5controller,
    this.pmh1,
    this.pmh2,
    this.pmh3,
    this.pmh4,
    this.pmh5,
    this.issl,
    this.isorder,
    this.onTextChanged,
    this.isps,
    this.inputFormatters,
  });

  void _updateQuantity(BuildContext context, int newValue) {
    if (newValue >= 1) {
      controller.text = newValue.toString();
      onTextChanged?.call(newValue.toString());
      onChanged?.call(newValue.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isps == null
          ? EdgeInsets.symmetric(horizontal: padding ?? 15.0)
          : const EdgeInsets.only(right: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundcolor ?? Colors.white,
        ),
        padding: EdgeInsets.only(
          left: 15.0,
          top: isorder != null ? 0 : padding ?? 15,
          right: 15,
          bottom: maxLength != null && maxLength! > 14 && maxLength! != 300
              ? 0
              : padding ?? 15,
        ),
        child: isorder != null
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      caption,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            final int currentValue =
                                int.tryParse(controller.text) ?? 0;
                            if (currentValue > 1) {
                              _updateQuantity(context, currentValue - 1);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: const Icon(
                              Icons.remove,
                              size: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            inputFormatters: inputFormatters,
                            onChanged: (String value) {
                              final int intValue = int.tryParse(value) ?? 0;
                              if (intValue >= 1) {
                                _updateQuantity(context, intValue);
                              }
                            },
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 13),
                            maxLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: hintText,
                              hintStyle: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w100),
                              filled: false,
                              fillColor: Colors.grey.shade100,
                              counterText: '',
                            ),
                            keyboardType: TextInputType.number,
                            controller: controller,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                              final int intValue = int.tryParse(value) ?? 0;
                              if (intValue < 1) {
                                return 'Value cannot be less than 1';
                              }
                              return null;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final int currentValue =
                                int.tryParse(controller.text) ?? 0;
                            _updateQuantity(context, currentValue + 1);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      if (caption != '')
                        Text(
                          caption,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (caption != '') const SizedBox(width: 10),
                      optionalText ?? Container(),
                    ],
                  ),
                  if (ispaymentfield == null)
                    _buildInputField()
                  else
                    _buildPaymentFields(),
                ],
              ),
      ),
    );
  }

  Widget _buildInputField() {
    if (iscurrencyfield == true) {
      return Row(
        children: <Widget>[
          SizedBox(
            height: 30,
            width: 55,
            child: TextFormField(
              inputFormatters: inputFormatters,
              controller: currencycontroller,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'USD',
                hintStyle: TextStyle(
                    color: Colors.black87, fontWeight: FontWeight.w100),
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
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: _buildMainTextField(),
          ),
        ],
      );
    }
    return _buildMainTextField();
  }

  Widget _buildMainTextField() {
    return TextFormField(
      inputFormatters: inputFormatters,
      style: const TextStyle(fontSize: 13),
      maxLines: maxLength != null && maxLength! > 30 ? 5 : 1,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle:
            TextStyle(color: Colors.black87, fontWeight: FontWeight.w100),
        filled: false,
        fillColor: Colors.grey.shade100,
        counterText: maxLength != null && maxLength! > 30 ? null : '',
      ),
      maxLength: maxLength,
      keyboardType: inputType,
      obscureText: isPassword,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
    );
  }

  Widget _buildPaymentFields() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        if (pmh1 != null) _buildPaymentField(pm1controller, pmh1!, 'igsl'),
        if (pmh2 != null) _buildPaymentField(pm2controller, pmh2!, 'fbsl'),
        if (pmh3 != null) _buildPaymentField(pm3controller, pmh3!, 'lsl'),
        if (pmh4 != null) _buildPaymentField(pm4controller, pmh4!, 'xsl'),
        if (pmh5 != null) _buildPaymentField(pm5controller, pmh5!, 'website'),
      ],
    );
  }

  Widget _buildPaymentField(
      TextEditingController? controller, String hint, String svgAsset) {
    return Row(
      children: <Widget>[
        if (issl != null) ...<Widget>[
          SvgPicture.asset(
            'assets/svgs/$svgAsset.svg',
            height: 15,
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: TextFormField(
            inputFormatters: inputFormatters,
            controller: controller,
            style: const TextStyle(fontSize: 13),
            maxLines: 1,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
