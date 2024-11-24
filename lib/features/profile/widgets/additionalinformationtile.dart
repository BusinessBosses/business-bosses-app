import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../common/models/analyser_data.dart';
import '../../../common/models/for_data_picker.dart';
import '../../forum/models/industry.dart';
import '../../../common/models/my_response.dart';
import '../../../common/widgets/data_selection_screen.dart';
import '../../../utils/theme/theme.dart';
import '../../../analytics/presentation/analysescreen.dart';
import '../presentation/my_profile_screen.dart';

class AdditionalInfoTile extends StatefulWidget {
  const AdditionalInfoTile({Key? key}) : super(key: key);

  @override
  _AdditionalInfoTileState createState() => _AdditionalInfoTileState();
}

class _AdditionalInfoTileState extends State<AdditionalInfoTile> {
  String? _companyName;
  bool? _isUniqueName;
  String? _industry;
  String? _website;
  String? _instagram;
  String? _twitter;
  String? _ageRange;
  String? _gender;
  String? _location;

  @override
  Widget build(BuildContext context) {
    const Color textColor = Colors.black;
    const MaterialColor hintColor = Colors.grey;
    final Color backgroundcolorinterface = Colors.grey[200]!;

    return ExpansionTile(
      trailing: isExpanded
          ? SvgPicture.asset(
              'assets/svgs/dropdownexpansionup.svg',
            )
          : SvgPicture.asset(
              'assets/svgs/dropdownexpansion.svg',
            ),
      title: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          children: <TextSpan>[
            TextSpan(
                text: 'Additional Information',
                style: TextStyle(color: textColor)),
            TextSpan(text: ' (Optional)', style: TextStyle(color: hintColor)),
          ],
        ),
      ),
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Company Name',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            initialValue: _companyName,
                            onChanged: (String val) {
                              debugPrint('_companyName $_companyName');
                              _companyName = val;
                            },
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: inputDecoration.copyWith(
                              hintStyle: const TextStyle(
                                color: iconColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              suffixIcon: _isUniqueName == true
                                  ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.close,
                                      color: _isUniqueName == null
                                          ? Colors.transparent
                                          : Colors.red,
                                    ),
                              filled: true,
                              fillColor: const Color(0xffF4F4F4),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text('Industry',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () => onDataPicker(
                                  analyser: Analyser.industry,
                                  title: 'Industries',
                                  list: AnalyserData.industries,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: backgroundcolorinterface,
                                    borderRadius:
                                        BorderRadius.circular(radiusValue),
                                  ),
                                  child: ListTile(
                                    leading: _industry != null
                                        ? Text(_industry!)
                                        : Text(
                                            'select a industry',
                                            style: bodyText2.copyWith(
                                                color: hintColor),
                                          ),
                                    trailing:
                                        const Icon(Icons.keyboard_arrow_right),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text('Website',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: _website,
                                onChanged: (String val) {
                                  _website = val;
                                },
                                keyboardType: TextInputType.url,
                                // validator: Validator.websiteValidator,
                                textInputAction: TextInputAction.next,
                                decoration: inputDecoration.copyWith(
                                  hintStyle: const TextStyle(
                                    color: iconColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  suffixIcon: _isUniqueName == true
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.close,
                                          color: _isUniqueName == null
                                              ? Colors.transparent
                                              : Colors.red,
                                        ),
                                  filled: true,
                                  fillColor: const Color(0xffF4F4F4),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Instagram',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: _instagram,
                                onChanged: (String val) {
                                  _instagram = val;
                                },
                                // validator: (val) =>
                                //     Validator
                                //         .socialValidator(
                                //             val,
                                //             "Instagram"),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: inputDecoration.copyWith(
                                  hintStyle: const TextStyle(
                                    color: iconColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  // suffixIcon:
                                  //     _isUniqueName == true
                                  //         ? const Icon(
                                  //             Icons
                                  //                 .check_circle,
                                  //             color: Colors
                                  //                 .green,
                                  //           )
                                  //         : Icon(
                                  //             Icons.close,
                                  //             color: _isUniqueName ==
                                  //                     null
                                  //                 ? Colors
                                  //                     .transparent
                                  //                 : Colors
                                  //                     .red,
                                  //           ),
                                  filled: true,
                                  fillColor: const Color(0xffF4F4F4),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Twitter',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: textColor,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                initialValue: _twitter,
                                onChanged: (String val) {
                                  _twitter = val;
                                },
                                // validator: (val) =>
                                //     Validator
                                //         .socialValidator(
                                //             val, "Twitter"),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: inputDecoration.copyWith(
                                  hintStyle: const TextStyle(
                                    color: iconColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xffF4F4F4),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                          const Text('Age Range',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButton<String>(
                            value: _ageRange,
                            borderRadius: BorderRadius.circular(radius),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_sharp),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 1,
                              color: hintColor,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _ageRange = newValue;
                              });
                            },
                            items: <String>[
                              '18-24',
                              '25-34',
                              '35-44',
                              '45-54',
                              '55-64',
                              '64+'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Gender',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(
                            height: 10,
                          ),
                          DropdownButton<String>(
                            value: _gender,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down_sharp),
                            iconSize: 24,
                            elevation: 16,
                            underline: Container(
                              height: 1,
                              color: hintColor,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                _gender = newValue;
                              });
                            },
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Invite ID',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onChanged: (String val) {},
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            decoration: inputDecoration.copyWith(
                                hintText: 'Eg AKUK_D4U16710',
                                filled: true,
                                fillColor: const Color(0xffF4F4F4)),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text('Location',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10.0),
                          CountryListPick(
                            appBar: AppBar(
                              leading: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: SvgPicture.asset(
                                    'assets/svgs/backbutton.svg'),
                              ),
                              centerTitle: true,
                              // ignore: prefer_const_constructors
                              title: Text(
                                'Select Country',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            initialSelection: _location ?? 'GB',
                            pickerBuilder: (BuildContext context,
                                CountryCode? countryCode) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: backgroundcolorinterface,
                                  borderRadius:
                                      BorderRadius.circular(radiusValue),
                                ),
                                child: ListTile(
                                  leading: _location != null
                                      ? Text(_location!)
                                      : Text(
                                          'select a location',
                                          style: bodyText2.copyWith(
                                              color: hintColor),
                                        ),
                                  trailing:
                                      const Icon(Icons.keyboard_arrow_right),
                                ),
                              );
                            },
                            onChanged: (CountryCode? code) {
                              debugPrint('code: ${code!.code}');
                              setState(() {
                                _location = code.name;
                              });
                            },
                            useSafeArea: false,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const SizedBox(height: 24.0),
                        ]),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ])),
      ],
    );
  }

  Future<void> onDataPicker({
    required Analyser analyser,
    required String title,
    required List<ForDataPicker> list,
  }) async {
    final MyResponse? res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => DataSelectionScreen(
          analyser: analyser,
          // list: list,
        ),
      ),
    );

    if (res != null && res.success) {
      if (analyser == Analyser.category) {
        setState(() {});
      } else if (analyser == Analyser.industry) {
        Industry industry = res.data;
        setState(() {
          _industry = industry.industry;
        });
      }
    }
  }
}
