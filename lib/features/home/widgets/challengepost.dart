import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

class Post {
  final String id;
  final String type;
  final String title;
  final String content;
  final String createdAt;
  final Author author;
  final List<String>? images;
  final double? price;
  final String? location;
  final int? participantCount;
  final String? endDate;
  final double? currentAmount;
  final double? targetAmount;

  Post({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.author,
    this.images,
    this.price,
    this.location,
    this.participantCount,
    this.endDate,
    this.currentAmount,
    this.targetAmount,
  });
}

class Author {
  final String name;
  final String avatar;

  Author({required this.name, required this.avatar});
}

// ========== UTILITIES ==========
String formatTimeAgo(String dateString) {
  final DateTime date = DateTime.parse(dateString);
  final DateTime now = DateTime.now();
  final Duration diff = now.difference(date);

  if (diff.inHours < 1) return 'Just now';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

String formatPrice(double price) {
  return NumberFormat.currency(locale: 'en_US', symbol: '\$').format(price);
}

// Common Card Layout
class BasePostCard extends StatelessWidget {
  final Post post;
  final Widget? details;

  const BasePostCard({super.key, required this.post, this.details});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      margin: const EdgeInsets.only(bottom: 7),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          debugPrint('Navigate to ${post.type} details: ${post.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    spacing: 10,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(post.author.avatar),
                        radius: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(post.author.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16)),
                          Text(formatTimeAgo(post.createdAt),
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(post.type.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue)),
                  )
                ],
              ),

              const SizedBox(height: 12),
              Text(post.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 8),
              Text(post.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, color: Colors.black54)),

              if (post.images != null && post.images!.isNotEmpty) ...<Widget>[
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(post.images!.first,
                      height: 200, width: double.infinity, fit: BoxFit.cover),
                ),
              ],

              if (details != null) ...<Widget>[
                const SizedBox(height: 12),
                details!,
              ],

              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _ActionButton(icon: LucideIcons.heart, label: 'Like'),
                  _ActionButton(
                      icon: LucideIcons.messageCircle, label: 'Comment'),
                  _ActionButton(icon: LucideIcons.share2, label: 'Share'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600])),
        ],
      ),
    );
  }
}

// ========== SPECIFIC POST TYPES ==========

class SellPostCard extends StatelessWidget {
  final Post post;
  const SellPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BasePostCard(
      post: post,
      details: Row(
        children: <Widget>[
          if (post.price != null)
            Row(children: <Widget>[
              const Icon(LucideIcons.dollarSign, size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(formatPrice(post.price!),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.green)),
            ]),
          const SizedBox(width: 16),
          if (post.location != null)
            Row(children: <Widget>[
              const Icon(LucideIcons.mapPin, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(post.location!,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
            ]),
        ],
      ),
    );
  }
}

class ChallengePostCard extends StatelessWidget {
  final Post post;
  const ChallengePostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BasePostCard(
      post: post,
      details: Row(
        children: <Widget>[
          if (post.participantCount != null)
            Row(children: <Widget>[
              const Icon(LucideIcons.users, size: 16, color: Colors.purple),
              const SizedBox(width: 4),
              Text('${post.participantCount} joined',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
            ]),
          const SizedBox(width: 16),
          if (post.endDate != null)
            Row(children: <Widget>[
              const Icon(LucideIcons.clock, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('Ends ${formatTimeAgo(post.endDate!)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
            ]),
        ],
      ),
    );
  }
}

class CrowdfundPostCard extends StatelessWidget {
  final Post post;
  const CrowdfundPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    double progress = (post.currentAmount ?? 0) / (post.targetAmount ?? 1);
    return BasePostCard(
      post: post,
      details: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LinearProgressIndicator(
            value: progress.clamp(0, 1),
            color: Colors.red,
            backgroundColor: Colors.grey[200],
            borderRadius: BorderRadius.circular(3),
            minHeight: 6,
          ),
          const SizedBox(height: 6),
          Text(
              '${formatPrice(post.currentAmount ?? 0)} of ${formatPrice(post.targetAmount ?? 0)}',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }
}

class DealPostCard extends StatelessWidget {
  final Post post;
  const DealPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return BasePostCard(
      post: post,
      details: Row(
        children: <Widget>[
          if (post.price != null)
            Row(children: <Widget>[
              const Icon(LucideIcons.target, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(formatPrice(post.price!),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.orange)),
            ]),
          const SizedBox(width: 16),
          if (post.endDate != null)
            Row(children: <Widget>[
              const Icon(LucideIcons.clock, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text('Expires ${formatTimeAgo(post.endDate!)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey)),
            ]),
        ],
      ),
    );
  }
}
