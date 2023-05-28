import 'package:business_bosses/action/action.dart';
import 'package:business_bosses/models/search/my_search_tab.dart';
import 'package:business_bosses/ui/button/my_outlined_button.dart';
import 'package:flutter/material.dart';

class TabsPagesFilterItem extends StatefulWidget {
  final List<MySearchTab> allTab;
  final List<MySearchTab> selectedTabs;
  final Function(List<MySearchTab> newTabs) onFilterChange;

  const TabsPagesFilterItem({
    Key key,
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
      _selectedTabs = widget.selectedTabs;
    }
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
              itemCount: widget.allTab.length,
              itemBuilder: (context, i) {
                int index = _selectedTabs.indexWhere(
                    (element) => element.label == widget.allTab[i].label);
                return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(widget.allTab[i].label),
                    value: index != -1,
                    onChanged: (status) {
                      if (index != -1) {
                        _selectedTabs.removeWhere((element) =>
                            element.label == widget.allTab[i].label);
                      } else {
                        _selectedTabs.add(widget.allTab[i]);
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
                  color: Theme.of(context).errorColor,
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
                    child: const Text('Cancel'),
                    onPressed: () => navigateTo(context),
                    buttonType: ButtonType.outline,
                  ),
                ),
                const SizedBox(width: 8.0),

                Expanded(
                  child: MCustomButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      if (_selectedTabs.isEmpty) return;

                      widget.onFilterChange(_selectedTabs);
                      navigateTo(context);
                    },
                    buttonType: ButtonType.elevated,
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
