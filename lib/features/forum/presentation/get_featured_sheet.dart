import 'package:business_bosses_v2/features/forum/presentation/apply_to_be_featured_screen.dart';
import 'package:business_bosses_v2/features/forum/presentation/bossup_challenge.dart';
import 'package:business_bosses_v2/features/premium/premium_paywall_sheet.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Modal dialog showing the 4 ways to get featured (Magazine, Marketplace, Homepage, Boss of Week)
/// matching Mockup Image 2.
class GetFeaturedSheet extends StatefulWidget {
  final int initialTabIndex;
  const GetFeaturedSheet({super.key, this.initialTabIndex = 0});

  @override
  State<GetFeaturedSheet> createState() => _GetFeaturedSheetState();
}

class _GetFeaturedSheetState extends State<GetFeaturedSheet> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12),
          // Handle bar
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Header title bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: const Icon(LucideIcons.chevronLeft, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Get featured',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black54),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Four ways to get your business seen by 70,000+ Business Bosses.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 4 Tab Headers
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: <Widget>[
                _buildTabItem(0, LucideIcons.bookOpen, 'Magazine'),
                _buildTabItem(1, LucideIcons.store, 'Marketplace'),
                _buildTabItem(2, LucideIcons.home, 'Homepage'),
                _buildTabItem(3, LucideIcons.trophy, 'Boss of Week'),
              ],
            ),
          ),

          // Active Tab Content View
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildTabContent(_selectedTab),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label) {
    final bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? primaryColorLT : Colors.transparent,
                width: 2.5,
              ),
            ),
          ),
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                size: 20,
                color: isSelected ? primaryColorLT : Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primaryColorLT : Colors.grey.shade700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    switch (tabIndex) {
      case 0: // Magazine
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1E),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: <Widget>[
                  // Magazine Cover Image / Card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 85,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        border: Border.all(color: Colors.yellow.shade700, width: 1),
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.asset(
                              'assets/images/magazinecover.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(LucideIcons.bookOpen, color: Colors.yellow.shade700, size: 28),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'MAGAZINE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'BUSINESS BOSSES MAGAZINE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow.shade700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tell your story in the next issue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Founder profiles, The Next Big Idea and Founder\'s Playbook.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade300,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'What you get',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildCheckItem('A feature in the monthly digital magazine'),
            _buildCheckItem('Shared with the community and on our socials'),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'How it works',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildStepItem('1', 'Share your story in a short form'),
                  _buildStepItem('2', 'Our editors review every application'),
                  _buildStepItem('3', 'If selected, we\'ll contact you for an interview'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildActionButton('Apply to be featured', () {
              Navigator.pop(context);
              Get.to(() => const ApplyToBeFeaturedScreen());
            }),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Open to all business bosses members',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
            ),
          ],
        );

      case 1: // Marketplace
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Marketplace Pro Visibility',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Showcase your products, services, and requests directly to buyers search result headers.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            _buildCheckItem('Unlimited marketplace listings'),
            _buildCheckItem('Priority placement in buyer matches'),
            _buildCheckItem('Direct messaging with lead buyers'),
            const SizedBox(height: 40),
            _buildActionButton('Become a Pro member', () {
              Navigator.pop(context);
              showPremiumPaywall();
            }),
          ],
        );

      case 2: // Homepage
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Homepage Reach Boost',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Boost your reach across the homepage feed so your post is seen first by active members.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            _buildCheckItem('Pinned post placement at top of feed'),
            _buildCheckItem('High engagement boost algorithm'),
            _buildCheckItem('Verified badge author highlight'),
            const SizedBox(height: 40),
            _buildActionButton('Boost your reach', () {
              Navigator.pop(context);
              showPremiumPaywall();
            }),
          ],
        );

      case 3: // Boss of Week
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Boss of The Week Challenge',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Participate in the weekly community challenge to win free top placement as Boss of The Week.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            _buildCheckItem('Featured profile card at top of For You feed'),
            _buildCheckItem('Special Boss of the Week profile badge'),
            _buildCheckItem('Free promotion to 70,000+ members'),
            const SizedBox(height: 40),
            _buildActionButton('Join this week\'s challenge', () {
              Navigator.pop(context);
              Get.to(() => const BossupChallenge(ishome: false));
            }),
          ],
        );
    }
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          const Icon(LucideIcons.check, size: 16, color: Colors.black87),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 10,
            backgroundColor: Colors.black,
            child: Text(
              number,
              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColorLT,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
