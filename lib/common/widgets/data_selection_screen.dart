// import 'package:flutter/material.dart';

// import '../../features/profile/analysescreen.dart';
// import '../models/my_title.dart';

// class DataSelectionScreen extends StatefulWidget {
//   static const routeName = '/data-selection-screen';
//   final Analyser analyser;
//   final bool hasSearchBar;

//   // final List<dynamic> list;

//   /// DATA SELECTION SCREEN
//   const DataSelectionScreen({
//     Key? key,
//     required this.analyser,
//     this.hasSearchBar = true,
//     // this.list = const [],
//   }) : super(key: key);

//   @override
//   _DataSelectionScreenState createState() => _DataSelectionScreenState();
// }

// class _DataSelectionScreenState extends State<DataSelectionScreen> {
//   // List<ForDataPicker> newList = [];
//   List<MyTitle> _categories = [];
//   List<Industry> _industries = [];
//   final MyFirebase _firebase = MyFirebase();
//   List<String> _searchableData = [];
//   List<String> listData = [];
//   String _title = '';
//   bool _isInit = false;
//   bool _isLoading = true;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_isInit) {
//       if (widget.analyser == Analyser.category) {
//         _title = 'Profession';
//         _loadCategories();
//       } else if (widget.analyser == Analyser.industry) {
//         _title = 'Industries';
//         _loadIndustries();
//       }
//       _isInit = true;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> _loadCategories() async {
//     MyResponse res = await _firebase.fetchAllNodes(path: Constants.TITLES);
//     if (res.success) {
//       _categories = _firebase.toCategoriesList(snapshot: res.data);
//       setState(() {
//         _isLoading = false;
//       });
//       toStringList(_categories);
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _loadIndustries() async {
//     Query query = _firebase.database
//         .reference()
//         .child(Constants.INDUSTRIES)
//         .orderByChild('categoryId')
//         .equalTo('-Mos1VMlx3oxZFRaw_BH');
//     MyResponse res = await _firebase.fetchNotesByQuery(query: query);
//     // MyResponse res = await _firebase.fetchAllNodes(path: Constants.INDUSTRIES);
//     if (res.success) {
//       _industries = _firebase.toIndustries(snapshot: res.data);
//       _industries.sort((a, b) => a?.industry?.compareTo(b?.industry) ?? 0);
//       debugPrint(
//           '_DataSelectionScreenState._loadIndustries: ${_industries.length}');
//       setState(() {
//         _isLoading = false;
//       });
//       toStringList(_industries);
//     } else {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_title),
//       ),
//       body: Column(
//         children: [
//           !widget.hasSearchBar
//               ? Container()
//               : Container(
//                   margin: const EdgeInsets.all(16.0),
//                   child: SearchBar(
//                     hintText: _title ?? 'Search',
//                     onChange: onChange,
//                   ),
//                 ),
//           Expanded(
//             child: _searchableData.isEmpty
//                 ? SafetyModel(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     icon: const Icon(
//                       Icons.category,
//                       size: 80.0,
//                       color: Colors.grey,
//                     ),
//                     subTitle: 'There is not $_title for to select',
//                     title: 'There is $_title found',
//                     clickableText: 'Reload',
//                     onTab: _loadCategories,
//                     isLoading: _isLoading,
//                   )
//                 : ListView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     itemCount: _searchableData.length,
//                     itemBuilder: (context, i) {
//                       return ListTile(
//                         onTap: () {
//                           MyResponse res = MyResponse(
//                               success: true,
//                               message: "Item selected",
//                               data: _getObject(_searchableData[i]));
//                           Navigator.of(context).pop(res);
//                         },
//                         title: Text(_searchableData[i]),
//                       );
//                     },
//                   ),
//           )
//         ],
//       ),
//     );
//   }

//   void onChange(String val) {
//     final data = listData.where((e) {
//       return e.toLowerCase().contains(val.toLowerCase());
//     }).toList();
//     setState(() {
//       _searchableData = data;
//     });
//   }

//   dynamic _getObject(String title) {
//     debugPrint('title: $title');
//     if (widget.analyser == Analyser.category) {
//       for (int i = 0; i < _categories.length; i++) {
//         if (_categories[i].category == title) return _categories[i];
//         debugPrint('i: $i: ${_categories[i].category}');
//       }
//     } else {
//       for (int i = 0; i < _industries.length; i++) {
//         if (_industries[i].industry == title) return _industries[i];
//         debugPrint('i: $i: ${_industries[i].industry}');
//       }
//     }
//   }

//   void toStringList(List<dynamic> list) {
//     if (widget.analyser == Analyser.category) {
//       List<String> data = [];
//       for (int i = 0; i < list.length; i++) {
//         MyTitle cat = list[i];
//         data.add(cat.category);
//       }
//       listData = data;
//     } else {
//       List<String> data = [];
//       for (int i = 0; i < list.length; i++) {
//         Industry industry = list[i];
//         data.add(industry.industry);
//       }
//       listData = data;
//     }
//     setState(() {
//       _searchableData = listData;
//     });
//   }
// }
