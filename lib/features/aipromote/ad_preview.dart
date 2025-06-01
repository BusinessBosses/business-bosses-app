import 'package:flutter/material.dart';

class AdPreview extends StatefulWidget {
  final String content;
  final Function(String) onEdit;
  final Function(List<String> platforms) onPost;
  final bool isLoading;

  const AdPreview({
    super.key,
    required this.content,
    required this.onEdit,
    required this.onPost,
    required this.isLoading,
  });

  @override
  State<AdPreview> createState() => _AdPreviewState();
}

class _AdPreviewState extends State<AdPreview> {
  bool _editMode = false;
  late TextEditingController _editController;
  final Map<String, bool> _selectedPlatforms = <String, bool>{
    'homepage': true,
    'marketplace': false,
    'challenge': false,
  };

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_editMode) {
      // Dismiss keyboard when saving
      FocusScope.of(context).unfocus();
      widget.onEdit(_editController.text);
    }
    setState(() {
      _editMode = !_editMode;
    });
  }

  void _togglePlatform(String platform) {
    setState(() {
      _selectedPlatforms[platform] = !_selectedPlatforms[platform]!;
    });
  }

  void _selectAll() {
    bool allSelected = _selectedPlatforms.values.every((bool v) => v);
    setState(() {
      _selectedPlatforms.forEach((String key, bool value) {
        _selectedPlatforms[key] = !allSelected;
      });
    });
  }

  bool get _isAnyPlatformSelected =>
      _selectedPlatforms.values.any((bool v) => v);
  bool get _areAllSelected => _selectedPlatforms.values.every((bool v) => v);

  Widget _buildPlatformChip(String key, String label) {
    bool isSelected = _selectedPlatforms[key]!;
    return GestureDetector(
      onTap: () => _togglePlatform(key),
      child: Container(
        margin: EdgeInsets.only(right: 8, bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6366F1) : Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Add GestureDetector to dismiss keyboard on tap outside
      onTap: () {
        if (_editMode) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'AI-Generated Mini Ad',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Review and edit your ad before posting it to selected platforms',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: <Color>[Color(0xFF6366F1), Color(0xFF8B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              constraints: BoxConstraints(minHeight: 120),
              child: _editMode
                  ? TextFormField(
                      controller: _editController,
                      maxLines: null,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Edit your ad content...',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      // Add this to handle keyboard dismissal on done
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).unfocus();
                      },
                    )
                  : Text(
                      _editController.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: _toggleEdit,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Color(0xFF6366F1)),
              ),
            ),
            child: Text(
              _editMode ? 'Save Changes' : 'Edit Copy',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Select where to post:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            children: <Widget>[
              _buildPlatformChip('homepage', 'Homepage'),
              _buildPlatformChip('challenge', 'Boss Up Challenge'),
            ],
          ),
          TextButton(
            onPressed: _selectAll,
            child: Text(
              _areAllSelected ? 'Deselect All' : 'Select All',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_isAnyPlatformSelected && !widget.isLoading)
                  ? () {
                      // collect keys with true value
                      final List<String> selected = _selectedPlatforms.entries
                          .where((MapEntry<String, bool> e) => e.value)
                          .map((MapEntry<String, bool> e) => e.key)
                          .toList();
                      widget.onPost(selected);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6366F1),
                disabledBackgroundColor: Color(0xFFA5B4FC),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ))
                  : Text(
                      'Post Ad',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
