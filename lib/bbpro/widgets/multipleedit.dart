import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';

class MultipleEditTextWidget extends StatefulWidget {
  final String caption;
  final String hintText;
  final EdgeInsetsGeometry? padding;
  final double? buttonSize;
  final Color? backgroundColor;
  final Function(List<String>)? onValuesChanged; // New callback

  const MultipleEditTextWidget({
    super.key,
    required this.caption,
    required this.hintText,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    this.buttonSize = 20,
    this.backgroundColor,
    this.onValuesChanged, // Initialize the callback
  });

  @override
  _MultipleEditTextWidgetState createState() => _MultipleEditTextWidgetState();
}

class _MultipleEditTextWidgetState extends State<MultipleEditTextWidget> {
  final List<TextEditingController> _controllers = <TextEditingController>[];
  final List<Widget> _textFields = <Widget>[];
  final int _maxFields = 3;

  @override
  void initState() {
    super.initState();
    _addTextField(); // Initialize with one text field
  }

  void _addTextField() {
    if (_textFields.length < _maxFields) {
      final TextEditingController controller =
          TextEditingController(); // Create a new controller
      _controllers.add(controller); // Add controller to the list
      setState(() {
        _textFields.add(_buildTextField(controller)); // Pass the new controller
      });
    }
  }

  void _removeTextField(int index) {
    if (_textFields.isNotEmpty) {
      _controllers[index].dispose(); // Dispose the controller
      _controllers.removeAt(index); // Remove the controller
      setState(() {
        _textFields.removeAt(index); // Remove the text field
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
            onChanged: (_) => _notifyParent(), // Notify parent on change
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
        if (_textFields.isNotEmpty) const SizedBox(width: 10),
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
      widget.onValuesChanged!(values); // Call the callback with current values
    }
  }

  @override
  void dispose() {
    for (TextEditingController controller in _controllers) {
      controller.dispose(); // Dispose all controllers
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
