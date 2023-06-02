import 'package:flutter/material.dart';

import '../../../action/action.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import 'my_search_tab.dart';

class TabsPagesFilterItem extends StatefulWidget {
  final List<MySearchTab>? allTab;
  final List<MySearchTab>? selectedTabs;
  final Function(List<MySearchTab> newTabs)? onFilterChange;

  const TabsPagesFilterItem({
    Key? key,
    this.allTab = const [],
    this.selectedTabs = const [],
    this.onFilterChange,
  }) : super(key: key);

  @override
  _TabsPagesFilterItemState createState() => _TabsPagesFilterItemState();
}

class _TabsPagesFilterItemState extends State<TabsPagesFilterItem> {
  List<MySearchTab> _selectedTabs = [];
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      _isInit = true;
      _selectedTabs = widget.selectedTabs!;
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Filter'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.allTab!.length,
              itemBuilder: (BuildContext context, int i) {
                int index = _selectedTabs.indexWhere(
                    (MySearchTab element) => element.label == widget.allTab![i].label);
                return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(widget.allTab![i].label!),
                    value: index != -1,
                    onChanged: (bool? status) {
                      if (index != -1) {
                        _selectedTabs.removeWhere((MySearchTab element) =>
                            element.label == widget.allTab![i].label);
                      } else {
                        _selectedTabs.add(widget.allTab![i]);
                      }
                      setState(() {});
                    });
              },
            ),
          ),
          if (_selectedTabs.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Minimum one filter is required',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: MCustomButton(
                    onPressed: () => navigateTo(context),
                    buttonType: ButtonType.outline,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8.0),

                Expanded(
                  child: MCustomButton(
                    onPressed: () {
                      if (_selectedTabs.isEmpty) return;

                      widget.onFilterChange!(_selectedTabs);
                      navigateTo(context);
                    },
                    buttonType: ButtonType.elevated,
                    child: const Text('Ok'),
                  ),
                )
                // Text('asd'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
