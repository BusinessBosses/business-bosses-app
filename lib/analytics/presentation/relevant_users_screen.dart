import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../common/models/my_response.dart';
import '../../common/models/my_title.dart';
import '../../common/widgets/data_selection_screen.dart';
import '../../features/connects/widgets/connection_grid_tile.dart';
import '../../features/search/controller/search_controller.dart';
import '../../utils/theme/theme.dart';
import 'analysescreen.dart';

class RelevantUsersScreen extends StatefulWidget {
  static const String routeName = '/relevant-users-screen';

  const RelevantUsersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RelevantUsersScreenState createState() => _RelevantUsersScreenState();
}

class _RelevantUsersScreenState extends State<RelevantUsersScreen> {
  final ScrollController _scrollController = ScrollController();
  ProfileController profileController = Get.find();
  String _filtertitle = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Get.find<CompleteSearchController>().loadMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CompleteSearchController>(
        builder: (CompleteSearchController controller) {
      final List<UserModel> filteredConnections =
          controller.recommendedConnections;

      // Sorting: Users with profile pictures come first
      filteredConnections.sort((UserModel a, UserModel b) {
        if (a.photoUrl != null && a.photoUrl!.isNotEmpty) {
          return (b.photoUrl != null && b.photoUrl!.isNotEmpty) ? 0 : -1;
        } else {
          return (b.photoUrl != null && b.photoUrl!.isNotEmpty) ? 1 : 0;
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
          title: const Text('Find Collaborators'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _showFilterModal(controller);
              },
              icon: SvgPicture.asset('assets/svgs/filternoback.svg'),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : filteredConnections.isEmpty
                      ? _safetyModal()
                      : MasonryGridView.count(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(8.0),
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          itemCount:
                              filteredConnections.length + 1, // +1 for loader
                          itemBuilder: (BuildContext context, int index) {
                            if (index < filteredConnections.length) {
                              final UserModel user = filteredConnections[index];
                              bool checkConnected = profileController
                                      .myProfile.connecteds
                                      ?.contains(user.uid) ??
                                  false;

                              return ConnectionGridTile(
                                user: user,
                                status: checkConnected,
                                onChangeConnectionStatus: () {
                                  controller.connectToUser(user);
                                },
                              );
                            } else {
                              return controller.loadingMore.value
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : const SizedBox.shrink();
                            }
                          },
                        ),
            ),
          ],
        ),
      );
    });
  }

  void _showFilterModal(CompleteSearchController controller) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
                height: 300,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SvgPicture.asset('assets/svgs/filternoback.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Filter',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                        'Select a category or profession to filter results',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () => _selectCategory(controller, setState),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _filtertitle.isNotEmpty
                                  ? _filtertitle
                                  : 'Select Category',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _filtertitle = '';
                            });
                            controller.resetData('');
                            Get.back();
                          },
                          child: const Text('Clear'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColorLT,
                          ),
                          onPressed: () {
                            Get.back();
                            controller.resetData(_filtertitle);
                          },
                          child: const Text(
                            'Apply',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ));
          });
        });
  }

  void _selectCategory(
      CompleteSearchController controller, StateSetter setState) async {
    final MyResponse? res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) =>
            const DataSelectionScreen(analyser: Analyser.category),
      ),
    );

    if (res != null && res.success) {
      MyTitle category = res.data;
      controller.selectedFilter.value = category.title ?? '';
      setState(() {
        _filtertitle = category.title ?? '';
      });
      controller.update();
    }
  }

  Widget _safetyModal() {
    return Center(
      child: Text(
        'No matching results found!',
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }
}
