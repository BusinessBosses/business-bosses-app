import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/my_response.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';

import '../../features/profile/analysescreen.dart';
import '../../features/forum/models/industry.dart';
import '../models/my_title.dart';
import 'safety_model.dart';
import 'search/search_bar.dart' as searchBar;

class DataSelectionScreen extends StatefulWidget {
  final Analyser analyser;
  final bool hasSearchBar;

  /// DATA SELECTION SCREEN
  const DataSelectionScreen({
    Key? key,
    required this.analyser,
    this.hasSearchBar = true,
  }) : super(key: key);

  @override
  _DataSelectionScreenState createState() => _DataSelectionScreenState();
}

class _DataSelectionScreenState extends State<DataSelectionScreen> {
  List<MyTitle> _categories = [];

  List<Industry> _industries = [];
  List<String> _searchableData = [];
  List<String> listData = [];
  String _title = '';
  // bool _isInit = false;
  bool _isLoading = true;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_isInit) {
  //     if (widget.analyser == Analyser.category) {
  //       _title = 'Profession';
  //       _loadCategories();
  //     } else if (widget.analyser == Analyser.industry) {
  //       _title = 'Industries';
  //       _loadIndustries();
  //     }
  //     _isInit = true;
  //   }
  // }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });
    final ApiResponseModel response =
        await ApiService.get(path: 'category/get?page=0&size=20');
    if (response.success) {
      _categories = MyTitle.toCategoriesList(snapshot: response.data['rows']);
      setState(() {
        _isLoading = false;
      });
      toStringList(_categories);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadIndustries() async {
    setState(() {
      _isLoading = true;
    });
    final ApiResponseModel response =
        await ApiService.get(path: 'industry/get');
    if (response.success) {
      _industries = Industry.toIndustries(snapshot: response.data['rows']);
      _industries
          .sort((Industry a, Industry b) => a.industry!.compareTo(b.industry!));

      setState(() {
        _isLoading = false;
      });
      toStringList(_industries);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.analyser == Analyser.category) {
      _title = 'Profession';
      _loadCategories();
    } else if (widget.analyser == Analyser.industry) {
      _title = 'Industries';
      _loadIndustries();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Column(
        children: [
          !widget.hasSearchBar
              ? Container()
              : Container(
                  margin: const EdgeInsets.all(16.0),
                  child: searchBar.SearchBarWidget(
                    hintText: _title,
                    onChange: onChange,
                    onSubmit: (String val) {},
                  ),
                ),
          Expanded(
            child: _searchableData.isEmpty
                ? SafetyModel(
                    mainAxisAlignment: MainAxisAlignment.start,
                    icon: const Icon(
                      Icons.category,
                      size: 80.0,
                      color: Colors.grey,
                    ),
                    subTitle: 'There is no $_title for you to select',
                    title: 'There is no $_title found',
                    clickableText: 'Reload',
                    isLoading: _isLoading,
                    onTap: widget.analyser == Analyser.category
                        ? _loadCategories
                        : _loadIndustries,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _searchableData.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        onTap: () {
                          MyResponse res = MyResponse(
                              success: true,
                              message: 'Item selected',
                              data: _getObject(_searchableData[i]));
                          Navigator.of(context).pop(res);
                        },
                        title: Text(_searchableData[i]),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  void onChange(String val) {
    final List<String> data = listData.where((String e) {
      return e.toLowerCase().contains(val.toLowerCase());
    }).toList();
    setState(() {
      _searchableData = data;
    });
  }

  dynamic _getObject(String title) {
    if (widget.analyser == Analyser.category) {
      for (int i = 0; i < _categories.length; i++) {
        if (_categories[i].category == title) return _categories[i];
      }
    } else {
      for (int i = 0; i < _industries.length; i++) {
        if (_industries[i].industry == title) return _industries[i];
        // debugPrint('i: $i: ${_industries[i].industry}');
      }
    }
  }

  void toStringList(List<dynamic> list) {
    if (widget.analyser == Analyser.category) {
      List<String> data = [];
      for (int i = 0; i < list.length; i++) {
        MyTitle cat = list[i];
        data.add(cat.category);
      }
      listData = data;
    } else {
      List<String> data = [];
      for (int i = 0; i < list.length; i++) {
        Industry industry = list[i];
        data.add(industry.industry!);
      }
      listData = data;
    }

    setState(() {
      _searchableData = listData;
    });
  }
}
