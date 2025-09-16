import 'package:business_bosses_v2/features/matchingfeature/models/matchmodel.dart';
import 'package:business_bosses_v2/features/matchingfeature/widgets/matchcard.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BookmarkedMatches extends StatefulWidget {
  const BookmarkedMatches({super.key});

  @override
  State<BookmarkedMatches> createState() => _BookmarkedMatchesState();
}

class _BookmarkedMatchesState extends State<BookmarkedMatches> {
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Sample bookmarked matches - replace with your actual data source
  final List<Matches> _bookmarkedMatches = <Matches>[
    Matches(
      id: '1',
      name: 'Acme Corp',
      type: 'Seller',
      description: 'Leading provider of business solutions.',
      rating: 4.5,
      location: 'New York, NY',
      services: <String>['Consulting', 'Cloud Services', 'Support'],
      responseTime: '1 hour',
      budget: '\$10,000 - \$50,000',
      isPremium: true,
      isVerified: true,
      matchPercentage: 92,
    ),
    Matches(
      id: '2',
      name: 'Beta Solutions',
      type: 'Buyer',
      description: 'Innovative buyer seeking tech solutions.',
      rating: 4.2,
      location: 'San Francisco, CA',
      services: <String>['Procurement', 'IT Consulting'],
      responseTime: '2 hours',
      budget: '\$20,000 - \$100,000',
      isPremium: false,
      isVerified: true,
      matchPercentage: 88,
    ),
    Matches(
      id: '3',
      name: 'TechStart Inc',
      type: 'Startup',
      description: 'Emerging technology startup seeking partnerships.',
      rating: 4.0,
      location: 'Austin, TX',
      services: <String>['Software Development', 'AI Solutions'],
      responseTime: '4 hours',
      budget: '\$5,000 - \$25,000',
      isPremium: false,
      isVerified: false,
      matchPercentage: 85,
    ),
  ];

  List<Matches> get filteredMatches {
    List<Matches> filtered = _bookmarkedMatches;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((Matches match) =>
              match.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              match.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              match.location.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply type filter
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((Matches match) => match.type == _selectedFilter)
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
          onPressed: () {
            Navigator.pop(context);
          },
          icon: CircleAvatar(
            backgroundColor: backgroundColor,
            child: Icon(
              LucideIcons.arrowLeft,
              color: textColor,
              size: 20,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Saved Matches',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showSortBottomSheet(context);
            },
            icon: CircleAvatar(
              backgroundColor: backgroundColor,
              child: Icon(
                LucideIcons.listFilter,
                color: textColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          // Header Stats
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: _buildStatCard(
                    'Total Saved',
                    _bookmarkedMatches.length.toString(),
                    LucideIcons.bookmark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'This Week',
                    '${_bookmarkedMatches.where((Matches m) => m.matchPercentage > 85).length}',
                    LucideIcons.trendingUp,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (String value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search saved matches...',
                  prefixIcon: Icon(LucideIcons.search,
                      color: textColor.withOpacity(0.6)),
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                'Startup',
                'Investor'
              ].map((String filter) => _buildFilterChip(filter)).toList(),
            ),
          ),

          // Results
          Expanded(
            child: filteredMatches.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(0),
                    itemCount: filteredMatches.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Stack(
                          children: <Widget>[
                            MatchCard(
                              showsavebutton: true,
                              saveontap: () =>
                                  _removeBookmark(filteredMatches[index]),
                              match: filteredMatches[index],
                              userType: 'buyer',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(filter),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedFilter = filter;
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
            color: isSelected ? Colors.white : Colors.grey.shade300,
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
          Icon(
            LucideIcons.bookmark,
            size: 50,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No matches found for "$_searchQuery"'
                : 'No saved matches yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textDark,
            ),
          ),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Start bookmarking matches to see them here',
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 14,
            ),
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

  void _removeBookmark(Matches match) {
    setState(() {
      _bookmarkedMatches.removeWhere((Matches m) => m.id == match.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${match.name} removed from saved matches'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _bookmarkedMatches.add(match);
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 20),
            _buildSortOption('Match Percentage', LucideIcons.percent),
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
      shape: ShapeBorder.lerp(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        0,
      ),
      leading: Icon(icon, color: textColor),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        // Implement sorting logic here
      },
    );
  }
}
