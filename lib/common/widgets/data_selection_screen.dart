import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/my_response.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';

import '../../analytics/presentation/analysescreen.dart';
import '../../features/forum/models/industry.dart';
import '../models/my_title.dart';
import 'safety_model.dart';
import 'search/search_bar.dart' as search_bar;

class DataSelectionScreen extends StatefulWidget {
  final Analyser analyser;
  final bool hasSearchBar;

  /// DATA SELECTION SCREEN
  const DataSelectionScreen({
    super.key,
    required this.analyser,
    this.hasSearchBar = true,
  });

  @override
  DataSelectionScreenState createState() => DataSelectionScreenState();
}

class DataSelectionScreenState extends State<DataSelectionScreen> {
  List<MyTitle> _categories = <MyTitle>[];

  List<Industry> _industries = <Industry>[];
  List<String> _searchableData = <String>[];
  List<String> listData = <String>[];
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
        await ApiService.get(path: 'profession/all?size=100');
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
        await ApiService.get(path: 'industry/user-count?size=100');
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
        children: <Widget>[
          !widget.hasSearchBar
              ? Container()
              : Container(
                  margin: const EdgeInsets.all(16.0),
                  child: search_bar.SearchBarWidget(
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
                      color: Color(0xFF616161),
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
        if (_categories[i].title == title) return _categories[i];
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
      List<String> data = <String>[];
      for (int i = 0; i < list.length; i++) {
        MyTitle cat = list[i];
        data.add(cat.title!);
      }
      listData = data;
    } else {
      List<String> data = <String>[];
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
