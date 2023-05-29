import 'package:flutter/material.dart';

class MySearchTab {
  String? id;
  String? label;
  Widget? widget;

  MySearchTab({
    this.id,
    this.label,
    this.widget,
  }) {
    id = label;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': label,
      'label': label,
      'widget': widget,
    };
  }

  factory MySearchTab.fromMap(Map<String, dynamic> map) {
    return MySearchTab(
      id: map['label'] as String,
      label: map['label'] as String,
      widget: map['widget'] as Widget,
    );
  }

  static List<MySearchTab> cloneList(List<MySearchTab> list) {
    List<MySearchTab> l = [];
    for (var element in list) {
      l.add(MySearchTab.fromMap(element.toMap()));
    }
    return l;
  }
}
