import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/common/models/my_response.dart';
import 'package:business_bosses_v2/common/models/my_title.dart';
import 'package:business_bosses_v2/common/widgets/data_selection_screen.dart';
import 'package:business_bosses_v2/analytics/presentation/analysescreen.dart';
import 'package:business_bosses_v2/features/search/controller/search_controller.dart';

void showFilterModal(
  BuildContext context,
  CompleteSearchController controller,
  ValueChanged<String> onFilterSelected,
) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    context: context,
    builder: (BuildContext context) {
      String selectedFilter = controller.selectedFilter.value;

      return StatefulBuilder(
        builder: (BuildContext context, Function setState) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/svgs/filternoback.svg'),
                    const SizedBox(width: 8),
                    const Text('Filter',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Select a profession to filter results',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () async {
                    final MyResponse? res = await Navigator.of(context).push(
                      MaterialPageRoute<MyResponse>(
                        builder: (_) => const DataSelectionScreen(
                            analyser: Analyser.category),
                      ),
                    );

                    if (res != null && res.success) {
                      MyTitle category = res.data;
                      setState(() => selectedFilter = category.title ?? '');
                    }
                  },
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
                          selectedFilter.isNotEmpty
                              ? selectedFilter
                              : 'Select Category',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(Icons.chevron_right)
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () {
                        setState(() => selectedFilter = '');
                        controller.resetData('');
                        onFilterSelected('');
                        Get.back();
                      },
                      child: const Text('Clear'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        controller.resetData(selectedFilter);
                        onFilterSelected(selectedFilter);
                        Get.back();
                      },
                      child: const Text('Apply',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
