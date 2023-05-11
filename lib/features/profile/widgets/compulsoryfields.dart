import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/dialogs/snackbar.dart';
import '../../../common/models/analyser_data.dart';
import '../../../common/models/for_data_picker.dart';
import '../../../common/models/industry.dart';
import '../../../common/models/my_response.dart';
import '../../../common/models/my_title.dart';
import '../../../common/widgets/data_selection_screen.dart';
import '../../../functions/validators/validator.dart';
import '../../../utils/theme/theme.dart';
import '../analysescreen.dart';
import '../myprofilescreen.dart';
import '../user_profile_image_item.dart';

class AchievementsExpansionTile extends StatefulWidget {
  const AchievementsExpansionTile({Key? key}) : super(key: key);

  @override
  _AchievementsExpansionTileState createState() =>
      _AchievementsExpansionTileState();
}

class _AchievementsExpansionTileState extends State<AchievementsExpansionTile> {
  String _name = '';
  bool? _isUniqueName;
  String? _category;
  String? _industry;
  String? _bio;
  bool _isUploading = false;
  String? _photoUrl;
  File? _imageFile;
  bool _isNetworkImage = false;

  @override
  Widget build(BuildContext context) {
    const Color textColor = Colors.black;
    const MaterialColor hintColor = Colors.grey;
    final Color? subtextColor = Colors.grey[700];
    final Color backgroundcolorinterface = Colors.grey[200]!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: _name,
                      onChanged: (String val) {
                        _name = val;
                        setState(() {});
                      },
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: Validator.nameValidator,
                      decoration: inputDecoration.copyWith(
                        hintStyle: const TextStyle(
                          color: iconColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        suffixIcon: _name != null
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
                    const Text(
                      'Title',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    GestureDetector(
                      onTap: () => onDataPicker(
                        analyser: Analyser.category,
                        title: 'Title',
                        list: AnalyserData.industries,
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: backgroundcolorinterface,
                          borderRadius: BorderRadius.circular(radiusValue),
                        ),
                        child: ListTile(
                          leading: _category != null
                              ? Text(_category!)
                              : Text(
                                  'select a category or profession',
                                  style: bodyText2.copyWith(color: hintColor),
                                ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Bio',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: textColor,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      onChanged: (val) {
                        _bio = val;
                      },
                      maxLength: 150,
                      maxLines: 5,
                      keyboardType: TextInputType.text,
                      validator: Validator.bioValidator,
                      textInputAction: TextInputAction.next,
                      decoration: inputDecoration.copyWith(
                        hintStyle: const TextStyle(
                          color: iconColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        suffixIcon: _bio != null
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
                  ]),
            ),
          ),
        ],
      )
    ]);
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
        MyTitle category = res.data;
        setState(() {
          _category = category.category;
        });
      } else if (analyser == Analyser.industry) {
        Industry industry = res.data;
        setState(() {
          _industry = industry.industry;
        });
      } else {}
    }
  }
}
