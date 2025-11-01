import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../presentation/my_profile_screen.dart';

class AchievementsExpansionTile extends StatefulWidget {
  const AchievementsExpansionTile({super.key});

  @override
  State<AchievementsExpansionTile> createState() =>
      _AchievementsExpansionTileState();
}

class _AchievementsExpansionTileState extends State<AchievementsExpansionTile> {
  TextEditingController achievementController = TextEditingController();
  final List<String> achievements = <String>[];

  void addItemToList() {
    if (achievementController.text.isNotEmpty &&
        achievementController.text.trim().isNotEmpty &&
        achievements.length <= 2) {
      setState(() {
        achievements.insert(0, achievementController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color textColor = Colors.black;
    const MaterialColor hintColor = Colors.grey;
    final Color? subtextColor = Colors.grey[700];
    final Color backgroundcolorinterface = Colors.grey[200]!;

    return ExpansionTile(
        trailing: isExpanded
            ? SvgPicture.asset('assets/svgs/dropdownexpansionup.svg')
            : SvgPicture.asset('assets/svgs/dropdownexpansion.svg'),
        title: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            children: <TextSpan>[
              TextSpan(
                  text: 'Add Achievements', style: TextStyle(color: textColor)),
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
                          Text(
                            'You can add up to 3 Achievements',
                            style: TextStyle(color: subtextColor),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 5),
                      child: TextFormField(
                        maxLength: 30,
                        controller: achievementController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter achievement here',
                        ),
                      ),
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: achievements.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(children: <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  height: 1.5,
                                  child: ColoredBox(
                                      color: backgroundcolorinterface),
                                ),
                                ListTile(
                                  title: Text(achievements[index]),
                                  leading: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: SvgPicture.asset(
                                        'assets/svgs/trophy.svg'),
                                  ),
                                  trailing: SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: SvgPicture.asset(
                                        'assets/svgs/close.svg'),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      achievements.remove(achievements[index]);
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        addItemToList();
                                        achievementController.clear();
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          'Add Achievement',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ]));
                        })
                  ]))
        ]);
  }
}
