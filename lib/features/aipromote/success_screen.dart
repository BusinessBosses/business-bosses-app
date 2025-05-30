import 'package:business_bosses_v2/action/action.dart';
import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final VoidCallback onCreateAnother;

  const SuccessScreen({super.key, required this.onCreateAnother});

  void _handleShare() async {
    try {
      socialShare(
          'Check out my business! I just created a promotion for my business.');
    } catch (e) {
      print('Error sharing: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEDE9FE),
          ),
          child: Icon(
            Icons.auto_fix_high,
            color: Color(0xFF6366F1),
            size: 40,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Success!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1F2937),
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Your business is now being promoted globally!',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF4B5563),
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      '1,000+',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Potential Viewers',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Color(0xFFE5E7EB),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      'Global',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Reach',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onCreateAnother,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6366F1),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Create Another Ad',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _handleShare,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF3F4F6),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.share,
                  color: Color(0xFF6366F1),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Share Outside the App',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        Text(
          '3 ads remaining this month',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
