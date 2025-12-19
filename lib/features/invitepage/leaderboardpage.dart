import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/common/widgets/safety_model.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LeaderboardScreen extends StatefulWidget {
  final bool isBossUp;
  const LeaderboardScreen({super.key, this.isBossUp = false});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final List<UserModel> _leaderboardData = <UserModel>[];
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
      _leaderboardData.clear();
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final ApiResponseModel response;
      if (widget.isBossUp) {
        response = await ApiService.get(path: 'users/bossup-winners');
      } else {
        response = await ApiService.get(path: 'users/backer-winners');
      }

      if (response.success) {
        for (dynamic user in response.data) {
          _leaderboardData.add(UserModel.fromMap(user));
        }
      } else {
        _error = response.message;
      }
      setState(() {
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
      return const Center(
          child: SafetyModel(isLoading: false, title: 'No data yet'));
    }

    return RefreshIndicator(
      onRefresh: _loadLeaderboard,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _leaderboardData.length,
        itemBuilder: (BuildContext context, int index) {
          final UserModel user = _leaderboardData[index];
          final int rank = index + 1;
          return _buildLeaderboardItem(user, rank);
        },
      ),
    );
  }

  Widget _buildLeaderboardItem(UserModel user, int rank) {
    return GestureDetector(
      onTap: () => Get.to(() => PublicProfileScreen(), arguments: user),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      user.name ?? user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${!widget.isBossUp ? user.backerCount : user.bossCount} achievement(s)',
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
      ),
    );
  }

  /// Avatar with fallback initial
  Widget _buildAvatar(UserModel user) {
    final String username = (user.username).trim();
    final String? avatarUrl = user.photoUrl;

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
}
