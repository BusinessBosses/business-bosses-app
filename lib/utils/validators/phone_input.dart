import 'package:business_bosses_v2/utils/validators/validator.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/icon_widget.dart';
import '../theme/theme.dart';

class PhoneNumberInput extends StatelessWidget {
  final Function onChangeCountry;
  final String countryCode;
  final Function onChangeText;

  /// CONSTRUCTOR
  const PhoneNumberInput(
      {Key? key,
      required this.onChangeCountry,
      required this.countryCode,
      required this.onChangeText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// COUNTRY PICKER FUNCTION
    void pickCountry() {
      showCountryPicker(
        context: context,
        showPhoneCode: true,
        onSelect: (Country country) => onChangeCountry(country),
        countryListTheme: CountryListThemeData(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
          inputDecoration: InputDecoration(
            labelText: 'Search',
            hintText: 'Search...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: const Color(0xFF8C98A8).withOpacity(0.2),
              ),
            ),
          ),
        ),
      );
    }

    return Row(children: <Widget>[
      TextButton(
        onPressed: () => pickCountry(),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Row(
            children: <Widget>[
              Text(
                countryCode,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const IconWidget(icon: Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
      Expanded(
        child: TextFormField(
          onChanged: (String val) {
            onChangeText(val);
            // _formKey.currentState.save();
            // setState(() {});
          },
          validator: Validator.phoneValidator,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          maxLength: 30,
          decoration: inputDecoration.copyWith(
            hintText: 'Enter phone number',
            hintStyle: const TextStyle(
              color: iconColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: const Color(0xffF4F4F4),
          ),
        ),
      )
    ]);
  }
}
