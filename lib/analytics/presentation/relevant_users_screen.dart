import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/models/analyser_data.dart';
import '../../common/models/for_data_picker.dart';
import '../../common/models/my_response.dart';
import '../../common/models/my_title.dart';
import '../../common/widgets/data_selection_screen.dart';
import '../../common/widgets/safety_model.dart';
import '../../features/connects/widgets/connection_grid_tile.dart';
import '../../features/search/controller/search_controller.dart';
import '../../utils/theme/theme.dart';
import 'analysescreen.dart';

class RelevantUsersScreen extends StatefulWidget {
  static const String routeName = '/relevant-users-screen';

  const RelevantUsersScreen({Key? key}) : super(key: key);

  @override
  _RelevantUsersScreenState createState() => _RelevantUsersScreenState();
}

class _RelevantUsersScreenState extends State<RelevantUsersScreen> {
  final UserModel _user = UserModel();
  ProfileController profileController = Get.find();
  String _filtertitle = "";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
        builder: (CompleteSearchController controller) {
      final List<UserModel> filteredConnections =
          controller.recommendedConnections.toList();
      final List<UserModel> filteredConnectionsbytitle = controller
          .recommendedConnections
          .where((element) => element.category.toString() == _filtertitle)
          .toList();

      void _refreshScreen() {
        setState(() {
          _filtertitle = "";
        });
      }

      filteredConnections.sort((UserModel a, UserModel b) {
        // Sorting logic based on photoUrl when _filtertitle is empty

        if (a.photoUrl != null && a.photoUrl!.isNotEmpty) {
          if (b.photoUrl != null && b.photoUrl!.isNotEmpty) {
            return 0;
          } else {
            return -1;
          }
        } else {
          if (b.photoUrl != null && b.photoUrl!.isNotEmpty) {
            return 1;
          } else {
            return 0;
          }
        }
      });

      filteredConnectionsbytitle.sort((UserModel a, UserModel b) {
        // Sorting logic based on photoUrl when _filtertitle is empty

        if (a.photoUrl != null && a.photoUrl!.isNotEmpty) {
          if (b.photoUrl != null && b.photoUrl!.isNotEmpty) {
            return 0;
          } else {
            return -1;
          }
        } else {
          if (b.photoUrl != null && b.photoUrl!.isNotEmpty) {
            return 1;
          } else {
            return 0;
          }
        }
      });

      return Scaffold(
        backgroundColor: backgroundcolorinterface,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
          ),
          centerTitle: true,
          title: const Text(
            'Connect',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return Container(
                            color: Colors.white,
                            height: 300,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svgs/filternoback.svg',
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      'Filter ',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Select a Category or Profession to filter results ',
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(height: 15),
                                GestureDetector(
                                  onTap: () => onDataPicker(
                                    analyser: Analyser.category,
                                    title: 'Profession',
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
                                      leading: _filtertitle.isNotEmpty
                                          ? Text(_filtertitle!)
                                          : Text(
                                              'Category or profession',
                                              style: bodyText2.copyWith(
                                                  color: hintColor),
                                            ),
                                      trailing: const Icon(
                                          Icons.keyboard_arrow_right),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: MCustomButton(
                                          buttonType: ButtonType.elevated,
                                          onPressed: () {
                                            Get.back();
                                          },
                                          height: 40,
                                          width: 80,
                                          child: const Text(
                                            'Done',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: MCustomButton(
                                        buttonType: ButtonType.outlinegrey,
                                        onPressed: () {
                                          _refreshScreen();
                                          Get.back();
                                        },
                                        height: 40,
                                        width: 80,
                                        child: const Text(
                                          'Clear Filter',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ));
                      });
                    });
              },
              icon: SvgPicture.asset(
                'assets/svgs/filternoback.svg',
              ),
            ),
          ],
        ),
        body: controller.loading.value
            ? const Center(
                child:
                    CircularProgressIndicator(), // Circular Progress Indicator
              )
            : _filtertitle!.isNotEmpty
                ? filteredConnectionsbytitle.isEmpty
                    ? _safetyModal(_user)
                    : StaggeredGridView.countBuilder(
                        padding: const EdgeInsets.all(8.0),
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        itemCount: _filtertitle!.isNotEmpty
                            ? filteredConnectionsbytitle.length
                            : filteredConnections.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool checkConnected = _filtertitle!.isNotEmpty
                              ? profileController.myProfile.connecteds !=
                                      null &&
                                  profileController.myProfile.connecteds!
                                      .contains(
                                    filteredConnectionsbytitle[index].uid,
                                  )
                              : profileController.myProfile.connecteds !=
                                      null &&
                                  profileController.myProfile.connecteds!
                                      .contains(
                                    filteredConnections[index].uid,
                                  );

                          return ConnectionGridTile(
                            user: _filtertitle!.isNotEmpty
                                ? filteredConnectionsbytitle[index]
                                : filteredConnections[index],
                            status: checkConnected,
                            onChangeConnectionStatus: () {
                              _filtertitle!.isNotEmpty
                                  ? controller.connectToUser(
                                      filteredConnectionsbytitle[index])
                                  : controller.connectToUser(
                                      filteredConnections[index]);
                            },
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                      )
                : filteredConnections.isEmpty
                    ? _safetyModal(_user)
                    : StaggeredGridView.countBuilder(
                        padding: const EdgeInsets.all(8.0),
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        itemCount: _filtertitle!.isNotEmpty
                            ? filteredConnectionsbytitle.length
                            : filteredConnections.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool checkConnected = _filtertitle!.isNotEmpty
                              ? profileController.myProfile.connecteds !=
                                      null &&
                                  profileController.myProfile.connecteds!
                                      .contains(
                                    filteredConnectionsbytitle[index].uid,
                                  )
                              : profileController.myProfile.connecteds !=
                                      null &&
                                  profileController.myProfile.connecteds!
                                      .contains(
                                    filteredConnections[index].uid,
                                  );

                          return ConnectionGridTile(
                            user: _filtertitle!.isNotEmpty
                                ? filteredConnectionsbytitle[index]
                                : filteredConnections[index],
                            status: checkConnected,
                            onChangeConnectionStatus: () {
                              _filtertitle!.isNotEmpty
                                  ? controller.connectToUser(
                                      filteredConnectionsbytitle[index])
                                  : controller.connectToUser(
                                      filteredConnections[index]);
                            },
                          );
                        },
                        staggeredTileBuilder: (int index) =>
                            const StaggeredTile.fit(1),
                      ),
      );
    });
  }

  final bool _isLoading = true;

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
          _filtertitle = category.title ?? "";
        });
      } else {
        // debugPrint('CATEGORY FALE');
      }
    }
  }

  Widget _safetyModal(UserModel user) {
    if (user.category?.isEmpty == true || user.industry?.isEmpty == true) {
      return SafetyModel(
        icon: const Icon(
          Icons.info_outline,
          size: 80.0,
          color: hintColor,
        ),
        isLoading: !_isLoading,
        title: 'You may have incomplete profile!',
        subTitle: 'You don\'t have a category or industry yet',
        clickableText: 'Complete profile',
        onTap: () async {
          await Get.toNamed(Routes.updateProfile,
              arguments: profileController.myProfile);
        },
      );
    }
    return SafetyModel(
      icon: SvgPicture.asset(
        'assets/svgs/group.svg',
        color: hintColor,
        height: 80.0,
      ),
      isLoading: !_isLoading,
      title: 'No matching results for searched title',
      subTitle: 'All filtered results will be displayed here!',
    );
  }
}
