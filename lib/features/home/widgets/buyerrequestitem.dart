import 'package:business_bosses_v2/features/home/widgets/buyerrequestsscreen.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyerRequestItem extends StatelessWidget {
  final BuyerRequest request;
  final VoidCallback? onTap;
  final VoidCallback? onApply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool? ismyrequest;

  const BuyerRequestItem({
    super.key,
    required this.request,
    this.onTap,
    this.onApply,
    this.onEdit,
    this.onDelete,
    this.ismyrequest,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Content
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Image
                  if (request.imageUrl != null)
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

                  if (request.imageUrl != null) const SizedBox(height: 12),

                  // Title and Description
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        request.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
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

                  const SizedBox(height: 12),

                  // Info Chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      if (request.budget != null && request.budget!.isNotEmpty)
                        _buildInfoChip(
                          icon: Icons.attach_money,
                          label: request.budget!,
                        ),
                      if (request.deadline != null)
                        _buildInfoChip(
                          icon: Icons.calendar_today,
                          label:
                              'Due: ${DateFormat('MMM dd').format(request.deadline!)}',
                        ),
                      if (request.attachments.isNotEmpty)
                        _buildInfoChip(
                          icon: Icons.attach_file,
                          label:
                              '${request.attachments.length} file${request.attachments.length == 1 ? '' : 's'}',
                        ),
                      if (request.location != null)
                        _buildInfoChip(
                          icon: Icons.place,
                          label: request.location!,
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Apply Button
                  if (ismyrequest == null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onApply,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Send Proposal',
                          style: TextStyle(
                            fontSize: 13,
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
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
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
