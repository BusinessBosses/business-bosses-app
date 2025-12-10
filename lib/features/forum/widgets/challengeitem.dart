import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Challengeitem extends StatelessWidget {
  final VoidCallback? onTap;
  final String? title;
  final String? imageurl;
  final String? time;
  final String? categorytype;
  final Industry? category;
  final bool? iscustom;
  final String? description;
  final bool? isPartner;
  final bool? isCrowdfund;
  final bool? isMentor;

  const Challengeitem({
    super.key,
    this.onTap,
    this.title,
    this.imageurl,
    this.time,
    this.category,
    this.categorytype,
    this.iscustom,
    this.isPartner,
    this.description,
    this.isCrowdfund,
    this.isMentor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: Colors.black12),
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ✅ Image container
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _buildImage(imageurl),
            ),

            // ✅ Description or challenge info
            description != null
                ? _buildDescriptionSection(context)
                : _buildDefaultChallengeSection(),
          ],
        ),
      ),
    );
  }

  /// Builds either a network or asset image correctly
  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return Container(
        height: 86,
        width: double.infinity,
        color: Colors.grey.shade200,
        child: const Center(child: Icon(Icons.image_not_supported)),
      );
    }

    final bool isNetwork = url.startsWith('http');

    return SizedBox(
      height: 86,
      width: double.infinity,
      child: isNetwork
          ? CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (BuildContext context, _) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (BuildContext context, _, __) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
            )
          : Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.grey),
            ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Text(
            description ?? '',
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onTap,
              child: Text(
                isPartner == true
                    ? 'Partners Deals'
                    : isCrowdfund == true
                        ? 'Crowdfund'
                        : isMentor == true
                            ? 'Start Learning'
                            : 'Enter',
                style: const TextStyle(
                  color: primaryColorLT,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultChallengeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Text(
              categorytype ?? '',
              style: const TextStyle(
                color: primaryColorLT,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            if (categorytype != null)
              const Icon(Icons.watch_later_outlined,
                  size: 15, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              time ?? '',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onTap,
            child: const Text(
              'Enter',
              style: TextStyle(
                color: primaryColorLT,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
