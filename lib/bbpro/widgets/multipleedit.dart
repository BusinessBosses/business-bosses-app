import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class MultipleEditTextWidget extends StatefulWidget {
  final String caption;
  final String hintText;
  final List<String> initialValues; // New parameter for initial values
  final EdgeInsetsGeometry? padding;
  final double? buttonSize;
  final Color? backgroundColor;
  final Function(List<String>)? onValuesChanged;

  const MultipleEditTextWidget({
    super.key,
    required this.caption,
    required this.hintText,
    this.initialValues =
        const <String>[], // Default to an empty list if not provided
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    this.buttonSize = 20,
    this.backgroundColor,
    this.onValuesChanged,
  });

  @override
  _MultipleEditTextWidgetState createState() => _MultipleEditTextWidgetState();
}

class _MultipleEditTextWidgetState extends State<MultipleEditTextWidget> {
  final List<TextEditingController> _controllers = <TextEditingController>[];
  final List<Widget> _textFields = <Widget>[];
  final int _maxFields = 10;

  @override
  void initState() {
    super.initState();
    // Initialize text fields with initial values if provided
    for (String value in widget.initialValues) {
      _addTextField(value: value);
    }
    // Ensure at least one text field is present
    if (_textFields.isEmpty) {
      _addTextField();
    }
  }

  void _addTextField({String value = ''}) {
    if (_textFields.isNotEmpty && _controllers.last.text.isEmpty) {
      return; // Prevent adding a new field if the last one is empty
    }
    if (_textFields.length < _maxFields) {
      final TextEditingController controller =
          TextEditingController(text: value);
      _controllers.add(controller);
      setState(() {
        _textFields.add(_buildTextField(controller));
      });
    }
  }

  void _removeTextField(int index) {
    if (_textFields.isNotEmpty) {
      _controllers[index].dispose();
      _controllers.removeAt(index);
      setState(() {
        _textFields.removeAt(index);
      });
    }
  }

  Widget _buildTextField(TextEditingController controller) {
    int index = _textFields.length;
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
                hintText: widget.hintText, border: InputBorder.none),
            controller: controller,
            style: const TextStyle(fontSize: 13),
            onChanged: (_) => _notifyParent(),
          ),
        ),
        Container(
          padding: widget.padding,
          decoration: BoxDecoration(
              color: prosemibackColor, borderRadius: BorderRadius.circular(10)),
          child: GestureDetector(
            onTap: () => _removeTextField(index),
            child: Icon(
              Icons.remove,
              size: widget.buttonSize,
            ),
          ),
        ),
        const SizedBox(width: 10),
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

  void _notifyParent() {
    if (widget.onValuesChanged != null) {
      final List<String> values = _controllers
          .map((TextEditingController controller) => controller.text)
          .toList();
      widget.onValuesChanged!(values);
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
