import 'package:flutter/material.dart';

import '../../features/profile/analysescreen.dart';
import '../models/industry.dart';
import '../models/my_title.dart';
import 'safety_model.dart';
import 'search/search_bar.dart';

class DataSelectionScreen extends StatefulWidget {
  final Analyser analyser;
  final bool hasSearchBar;

  // final List<dynamic> list;

  /// DATA SELECTION SCREEN
  const DataSelectionScreen({
    Key? key,
    required this.analyser,
    this.hasSearchBar = true,
    // this.list = const [],
  }) : super(key: key);

  @override
  _DataSelectionScreenState createState() => _DataSelectionScreenState();
}

class _DataSelectionScreenState extends State<DataSelectionScreen> {
  // List<ForDataPicker> newList = [];
  List<Map<String, dynamic>> _categories = <Map<String, dynamic>>[
    <String, dynamic>{
      'categoryId': 'shgdghgdshds',
      'timestamp': 16621621,
      'category': 'Developer',
    },
  ];
  List<Map<String, dynamic>> _industries = [];
  List<String> _searchableData = [];
  List<String> listData = [];
  String _title = '';
  bool _isInit = false;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      if (widget.analyser == Analyser.category) {
        _title = 'Profession';
        _loadCategories();
      } else if (widget.analyser == Analyser.industry) {
        _title = 'Industries';
        _loadIndustries();
      }
      _isInit = true;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadCategories() async {
    _categories = [
      {
        'categoryId': 'shgdghgdshds',
        'timestamp': 16621621,
        'category': 'Developer',
      },
    ];
    setState(() {
      _isLoading = false;
    });
    toStringList(_categories);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadIndustries() async {
    _industries = [
      {
        'categoryId': '6b93f3b8-4305-4487-9e1c-35f3f7952cd6',
        'description': 'Discussions about Media & Entertainment',
        'industry': 'Media & Entertainment',
        'photo': 'http://44.210.87.234/learningImages/media.jpg',
        'timestamp': 123456666
      },
    ];
    setState(() {
      _isLoading = false;
    });
    toStringList(_industries);
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
                  child: SearchBar(
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
                    subTitle: 'There is not $_title for to select',
                    title: 'There is $_title found',
                    clickableText: 'Reload',
                    isLoading: _isLoading,
                    onTap: _loadCategories,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _searchableData.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ListTile(
                        onTap: () {},
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
        if (_categories[i]['category'] == title) return _categories[i];
        debugPrint('i: $i: ${_categories[i]['category']}');
      }
    } else {
      for (int i = 0; i < _industries.length; i++) {
        if (_industries[i]['industry'] == title) return _industries[i];
        debugPrint('i: $i: ${_industries[i]['industry']}');
      }
    }
  }

  void toStringList(List<dynamic> list) {
    if (widget.analyser == Analyser.category) {
      List<String> data = ['Developer', 'Doctor', 'Business'];
      // for (int i = 0; i < list.length; i++) {
      //   MyTitle cat = list[i];
      //   data.add(cat.category);
      // }
      listData = data;
    } else {
      List<String> data = [];
      for (int i = 0; i < list.length; i++) {
        Industry industry = list[i];
        data.add(industry.industry);
      }
      listData = data;
    }
    setState(() {
      _searchableData = listData;
    });
  }
}
