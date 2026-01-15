import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _filters = <String>['Global', 'Industry', 'Country'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Reach Leaderboards'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: primaryColorLT,
          unselectedLabelColor: Colors.grey,
          indicatorColor: primaryColorLT,
          tabs: _filters.map((String filter) => Tab(text: filter)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildLeaderboardList('Global'),
          _buildLeaderboardList('Industry'),
          _buildLeaderboardList('Country'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(String filterType) {
    // Mock data for leaderboards
    final List<Map<String, dynamic>> learderboardData = <Map<String, dynamic>>[
      <String, dynamic>{
        'rank': 1,
        'name': 'Tech Innovators Inc.',
        'score': 985,
        'image': '',
        'verified': true,
      },
      <String, dynamic>{
        'rank': 2,
        'name': 'Green Earth Solutions',
        'score': 950,
        'image': '',
        'verified': true,
      },
      <String, dynamic>{
        'rank': 3,
        'name': 'Creative Minds Studio',
        'score': 920,
        'image': '',
        'verified': false,
      },
      <String, dynamic>{
        'rank': 4,
        'name': 'Global Logistics',
        'score': 890,
        'image': '',
        'verified': true,
      },
      <String, dynamic>{
        'rank': 5,
        'name': 'Healthy Living',
        'score': 850,
        'image': '',
        'verified': false,
      },
      // Add more items to demonstrate list
      ...List<Map<String, dynamic>>.generate(
        10,
        (int index) => <String, dynamic>{
          'rank': index + 6,
          'name': 'Business #${index + 6}',
          'score': 800 - (index * 10),
          'image': '',
          'verified': index % 3 == 0,
        },
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: learderboardData.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> item = learderboardData[index];
        return _buildLeaderboardItem(item);
      },
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> item) {
    bool isTop3 = item['rank'] <= 3;
    Color rankColor =
        isTop3 ? const Color(0xFFFFD700) : Colors.grey.shade400; // Gold or Grey
    if (item['rank'] == 2) rankColor = const Color(0xFFC0C0C0); // Silver
    if (item['rank'] == 3) rankColor = const Color(0xFFCD7F32); // Bronze

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isTop3 ? rankColor.withValues(alpha: 0.3) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            alignment: Alignment.center,
            child: Text(
              '#${item['rank']}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isTop3 ? rankColor : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: NetworkImageWithPlaceHolder(
                placeHolder: LucideIcons.user,
                imageUrl: item['image'] ?? '',
                width: 45,
                height: 45,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        item['name'],
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (item['verified'] == true) ...<Widget>[
                      const SizedBox(width: 4),
                      const Icon(LucideIcons.badgeCheck,
                          size: 16, color: Colors.blue),
                    ],
                  ],
                ),
                Text(
                  'Reach Score: ${item['score']}',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (isTop3)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(LucideIcons.trophy, color: rankColor, size: 20),
            ),
        ],
      ),
    );
  }
}
