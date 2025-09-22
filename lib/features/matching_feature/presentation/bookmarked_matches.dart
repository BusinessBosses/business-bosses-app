import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

// Your app's theme and custom widgets
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:business_bosses_v2/features/matching_feature/widgets/match_card.dart';

// Import the correct, singular 'Match' model
import 'package:business_bosses_v2/features/matching_feature/models/matchmodel.dart';

class BookmarkedMatches extends StatefulWidget {
  const BookmarkedMatches({super.key});

  @override
  State<BookmarkedMatches> createState() => _BookmarkedMatchesState();
}

class _BookmarkedMatchesState extends State<BookmarkedMatches> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // UPDATED: Sample data now uses the correct 'Match' model
  final List<Match> _bookmarkedMatches = <Match>[
    Match(
      id: '1',
      name: 'Acme Corp',
      type: 'Seller',
      description: 'Leading provider of business solutions.',
      rating: 4.5,
      location: 'New York, NY',
      services: const <String>['Consulting', 'Cloud Services', 'Support'],
      responseTime: 'Within an hour',
      budget: r'$10,000 - $50,000',
      verified: true,
      quality: 92,
      photoUrl: 'https://businessbosses.com.ng/appfiles/sample_photo_2.jpg',
      achievements: <String>[],
    ),
    Match(
      id: '2',
      name: 'Beta Solutions',
      type: 'Buyer',
      description: 'Innovative buyer seeking tech solutions.',
      rating: 4.2,
      location: 'San Francisco, CA',
      services: const <String>['Procurement', 'IT Consulting'],
      responseTime: 'Within an hour',
      budget: r'$20,000 - $100,000',
      verified: true,
      quality: 88,
      photoUrl: 'https://businessbosses.com.ng/appfiles/sample_photo_1.jpg',
      achievements: <String>[],
    ),
    Match(
      id: '3',
      name: 'TechStart Inc',
      type: 'Supplier',
      description: 'Emerging technology startup seeking partnerships.',
      rating: 4.0,
      location: 'Austin, TX',
      services: const <String>['Software Development', 'AI Solutions'],
      responseTime: 'A few hours',
      budget: r'$5,000 - $25,000',
      verified: false,
      quality: 85,
      photoUrl: null,
      achievements: <String>[],
    ),
  ];

  // UPDATED: Getter is now correctly typed to 'Match'
  List<Match> get filteredMatches {
    List<Match> filtered = _bookmarkedMatches;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((Match match) =>
              match.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              match.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              match.location.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((Match match) => match.type == _selectedFilter)
          .toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        actions: <Widget>[
          IconButton(
            onPressed: () => _showSortBottomSheet(context),
            icon: CircleAvatar(
              backgroundColor: backgroundColor,
              child: Icon(LucideIcons.listFilter, color: textColor, size: 20),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          spacing: 0,
          children: <Widget>[
            // Header Stats
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         child: _buildStatCard(
            //           'Total Saved',
            //           _bookmarkedMatches.length.toString(),
            //           LucideIcons.bookmark,
            //         ),
            //       ),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: _buildStatCard(
            //           'Top Tier',
            //           // UPDATED: Logic uses 'quality' and 'Match' type
            //           '${_bookmarkedMatches.where((Match m) => m.quality > 90).length}',
            //           LucideIcons.trendingUp,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Search Bar
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
            // Filter Chips
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: <String>[
                  'All',
                  'Seller',
                  'Buyer',
                  'Supplier',
                  'Partner'
                ].map((String filter) => _buildFilterChip(filter)).toList(),
              ),
            ),
            // Results List
            Expanded(
              child: filteredMatches.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      itemCount: filteredMatches.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Match match = filteredMatches[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MatchCard(
                            showsavebutton: true,
                            saveontap: () => _removeBookmark(match),
                            match: match,
                            userType: 'buyer', // This should be dynamic
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
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

  Widget _buildFilterChip(String filter) {
    final bool isSelected = _selectedFilter == filter;
    // UPDATED: Logic is now correctly typed to 'Match'
    final int count = filter == 'All'
        ? _bookmarkedMatches.length
        : _bookmarkedMatches.where((Match m) => m.type == filter).length;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text('$filter ($count)'),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() => _selectedFilter = filter);
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
              color: isSelected ? Colors.transparent : Colors.grey.shade300),
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
          if (_searchQuery.isNotEmpty) ...<Widget>[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                  _selectedFilter = 'All';
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ],
      ),
    );
  }

  // UPDATED: Method parameter is now correctly typed to 'Match'
  void _removeBookmark(Match match) {
    final int index = _bookmarkedMatches.indexOf(match);
    setState(() {
      _bookmarkedMatches.removeWhere((Match m) => m.id == match.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${match.name} removed from saved matches'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _bookmarkedMatches.insert(index, match);
            });
          },
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Sort & Filter',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
            ),
            const SizedBox(height: 20),
            _buildSortOption('Match Quality', LucideIcons.percent),
            _buildSortOption('Rating', LucideIcons.star),
            _buildSortOption('Recently Added', LucideIcons.clock),
            _buildSortOption('Response Time', LucideIcons.timer),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, IconData icon) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: textColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        // Implement your sorting logic here based on the title
      },
    );
  }
}
