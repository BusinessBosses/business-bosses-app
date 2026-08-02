import 'package:business_bosses_v2/features/marketplace/models/buyer_request_model.dart';
import 'package:business_bosses_v2/utils/currency_format.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class BuyerRequestItem extends StatelessWidget {
  final BuyerRequestModel request;
  final VoidCallback? onTap;
  final VoidCallback? onApply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onMoreOptions;
  final bool? ismyrequest;

  const BuyerRequestItem({
    super.key,
    required this.request,
    this.onTap,
    this.onApply,
    this.onEdit,
    this.onDelete,
    this.ismyrequest,
    this.onMoreOptions,
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final Uri? uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDeadline = _formatDeadline(request.deadline);
    final bool hasValidImage = _isValidImageUrl(request.imageUrl);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // ✅ Image (only if valid)
                  if (hasValidImage) ...<Widget>[
                    SizedBox(
                      height: 120.0,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          request.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error,
                                  StackTrace? stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ✅ Title and Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              request.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (onMoreOptions != null)
                            GestureDetector(
                              onTap: onMoreOptions,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.more_horiz,
                                  size: 20,
                                  color: textColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        request.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: textColor,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // ✅ Info Chips (Budget, Deadline, Files)
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: <Widget>[
                      // ✅ Budget (Start - End) — hidden when no budget was set,
                      // shown in the user's location currency otherwise.
                      if (CurrencyFormatter.budgetRange(
                              request.budgetStart, request.budgetEnd) !=
                          null)
                        _buildInfoChip(
                          icon: LucideIcons.coins,
                          label: CurrencyFormatter.budgetRange(
                              request.budgetStart, request.budgetEnd)!,
                        ),

                      // ✅ Deadline
                      _buildInfoChip(
                        icon: Icons.calendar_today,
                        label: formattedDeadline,
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // ✅ Apply Button
                  if (ismyrequest == null)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onTap,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'View Job',
                          style: TextStyle(
                            fontSize: 13,
                            color: primaryColorLT,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Helper: Format deadline date
  String _formatDeadline(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';
    try {
      final DateTime date = DateTime.parse(dateStr);
      return DateFormat('MMM dd').format(date);
    } catch (e) {
      return 'Invalid date';
    }
  }

  // ✅ Info Chip Widget (unchanged visually)
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 12, color: textColor),
          SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
