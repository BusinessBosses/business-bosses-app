import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> _leaderboardData = <Map<String, dynamic>>[];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  /// LOAD DUMMY DATA ONLY (no Supabase)
  Future<void> _loadLeaderboard() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      await Future<void>.delayed(const Duration(seconds: 1)); // simulate API

      final List<Map<String, dynamic>> dummy = <Map<String, dynamic>>[
        <String, dynamic>{
          'username': 'Ernest',
          'avatar_url': 'https://i.pravatar.cc/150?img=3',
          'achievements_count': 12,
          'level': 6,
          'score': 990,
        },
        <String, dynamic>{
          'username': 'Kofi',
          'avatar_url': 'https://i.pravatar.cc/150?img=4',
          'achievements_count': 9,
          'level': 5,
          'score': 870,
        },
        <String, dynamic>{
          'username': 'Ama',
          'avatar_url': 'https://i.pravatar.cc/150?img=10',
          'achievements_count': 7,
          'level': 4,
          'score': 820,
        },
        <String, dynamic>{
          'username': 'Junior Dev',
          'avatar_url': '',
          'achievements_count': 4,
          'level': 2,
          'score': 400,
        },
      ];

      setState(() {
        _leaderboardData = dummy;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text('Previous Winners'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadLeaderboard,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_leaderboardData.isEmpty) {
      return const Center(child: Text('No data yet'));
    }

    return RefreshIndicator(
      onRefresh: _loadLeaderboard,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _leaderboardData.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> user = _leaderboardData[index];
          final int rank = index + 1;
          return _buildLeaderboardItem(user, rank);
        },
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> user, int rank) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        // leading: _buildRankBadge(rank),
        title: Row(
          children: <Widget>[
            _buildAvatar(user),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user['username'] ?? 'Unknown',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${user['achievements_count']} achievements',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
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

  /// Avatar with fallback initial
  Widget _buildAvatar(Map<String, dynamic> user) {
    final String username = (user['username'] ?? 'U').trim();
    final String? avatarUrl = user['avatar_url'];

    final bool hasImage = avatarUrl != null &&
        avatarUrl.isNotEmpty &&
        avatarUrl.startsWith('http');

    if (hasImage) {
      return CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatarUrl),
      );
    }

    final String firstLetter =
        username.isNotEmpty ? username[0].toUpperCase() : 'U';

    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blueGrey,
      child: Text(
        firstLetter,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Rank Badge — same grey for all (#)
  Widget _buildRankBadge(int rank) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '#$rank',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: primaryColorLT,
          ),
        ),
      ),
    );
  }
}
