import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class MultipleEditTextWidget extends StatefulWidget {
  final String caption;
  final String hintText;
  final TextEditingController controller;
  final EdgeInsetsGeometry? padding;
  final double? buttonSize;
  final Color? backgroundColor;

  const MultipleEditTextWidget({
    super.key,
    required this.caption,
    required this.hintText,
    required this.controller,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    this.buttonSize = 20,
    this.backgroundColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MultipleEditTextWidgetState createState() => _MultipleEditTextWidgetState();
}

class _MultipleEditTextWidgetState extends State<MultipleEditTextWidget> {
  final List<Widget> _textFields = <Widget>[];
  final int _maxFields = 3;

  @override
  void initState() {
    super.initState();
    _addTextField();
  }

  void _addTextField() {
    if (_textFields.length < _maxFields) {
      setState(() {
        _textFields.add(_buildTextField());
      });
    }
  }

  void _removeTextField(int index) {
    if (_textFields.isNotEmpty) {
      setState(() {
        _textFields.removeAt(index);
      });
    }
  }

  Widget _buildTextField() {
    int index = _textFields.length;
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                hintText: widget.hintText, border: InputBorder.none),
            controller: widget.controller,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        if (_textFields.isNotEmpty)
          Container(
            padding: widget.padding,
            decoration: BoxDecoration(
                color: prosemibackColor,
                borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () => _removeTextField(index),
              child: Icon(
                Icons.remove,
                size: widget.buttonSize,
              ),
            ),
          ),
        if (_textFields.isNotEmpty)
          const SizedBox(
            width: 10,
          ),
        if (_textFields.length < _maxFields)
          Container(
            padding: widget.padding,
            decoration: BoxDecoration(
                color: prosemibackColor,
                borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: _addTextField,
              child: Icon(
                Icons.add,
                size: widget.buttonSize,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Column(
              children: _textFields,
            ),
          ],
        ),
      ),
    );
  }
}
