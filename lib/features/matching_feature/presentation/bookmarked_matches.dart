import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';
import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';
import 'package:business_bosses_v2/features/matching_feature/controllers/match_controller.dart';

class BookmarkedMatches extends StatefulWidget {
  const BookmarkedMatches({super.key});

  @override
  State<BookmarkedMatches> createState() => _BookmarkedMatchesState();
}

class _BookmarkedMatchesState extends State<BookmarkedMatches> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MatchController matchController = Get.find<MatchController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CircleAvatar(
            backgroundColor: backgroundColor,
            child: Icon(LucideIcons.arrowLeft, color: textColor, size: 20),
          ),
        ),
        centerTitle: true,
        title: const Text('Saved Matches', textAlign: TextAlign.center),
      ),
      body: Obx(() {
        List<Match> bookmarked = matchController.bookmarkedMatches;

        // 🔍 Search
        if (_searchQuery.isNotEmpty) {
          bookmarked = bookmarked
              .where((Match m) =>
                  m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                  m.description
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) ||
                  m.location.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();
        }

        // 🏷️ Filter
        if (_selectedFilter != 'All') {
          bookmarked = bookmarked
              .where((Match m) => m.matchType == _selectedFilter.toLowerCase())
              .toList();
        }

        return Column(
          children: <Widget>[
            // 📊 Stats
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _buildStatCard(
                      'Total Saved',
                      matchController.bookmarkedMatches.length.toString(),
                      LucideIcons.bookmark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Top Tier',
                      '${matchController.bookmarkedMatches.where((Match m) => m.quality > 90).length}',
                      LucideIcons.trendingUp,
                    ),
                  ),
                ],
              ),
            ),

            // 🔍 Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (String value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search saved matches...',
                    prefixIcon: Icon(LucideIcons.search,
                        size: 20, color: textColor.withOpacity(0.6)),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(LucideIcons.x,
                                color: textColor.withOpacity(0.6)),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  ),
                ),
              ),
            ),

            // 🏷️ Filter Chips
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children:
                    <String>['All', 'Seller', 'Buyer', 'Supplier', 'Partner']
                        .map((String filter) => _buildFilterChip(
                              filter,
                              matchController.bookmarkedMatches,
                            ))
                        .toList(),
              ),
            ),

            // 📋 Results
            Expanded(
              child: bookmarked.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: bookmarked.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Match match = bookmarked[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MatchCard(
                            match: match,
                            userType: match.matchType ?? 'Not Specified',
                            isBookmarked: true,
                            onBookmarkToggle: () =>
                                matchController.toggleBookmark(match),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: textColor.withOpacity(0.6), size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textDark,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, List<Match> allBookmarked) {
    final bool isSelected = _selectedFilter == filter;
    final int count = filter == 'All'
        ? allBookmarked.length
        : allBookmarked
            .where((Match m) => m.matchType == filter.toLowerCase())
            .length;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text('$filter ($count)'),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            // ✅ Toggle logic
            if (isSelected) {
              // If already selected, reset back to "All"
              _selectedFilter = 'All';
            } else {
              _selectedFilter = filter;
            }
          });
        },
        backgroundColor: backgroundColor,
        selectedColor: textColor,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : textColor,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(LucideIcons.bookmark,
              size: 50, color: textColor.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No matches found for "$_searchQuery"'
                : 'No saved matches yet',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Start bookmarking matches to see them here',
            style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
