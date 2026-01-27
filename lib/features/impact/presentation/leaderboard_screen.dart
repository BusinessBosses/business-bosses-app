import 'dart:developer';

import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
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

  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();

  bool isLoading = false;

  List<Map<String, dynamic>> globalLeaders = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> industryLeaders = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> countryLeaders = <Map<String, dynamic>>[];

  /// ===============================
  /// LOAD SHOPS (NOT USERS)
  /// ===============================
  Future<void> loadUsers() async {
    setState(() => isLoading = true);

    ApiResponseModel? industryResponse;
    ApiResponseModel? countryResponse;

    final ApiResponseModel globalResponse =
        await ApiService.get(path: 'impact/top/shops?limit=30');

    if (profileController.myProfile.hasShop && shopController.shop != null) {
      industryResponse = await ApiService.get(
        path: 'impact/top/shops/industry/${shopController.shop!.id}?limit=30',
      );

      countryResponse = await ApiService.get(
        path: 'impact/top/shops/location/${shopController.shop!.id}?limit=30',
      );
    }

    if (globalResponse.success) {
      log(globalResponse.data.toString());
      globalLeaders = _mapApiResponse(globalResponse.data);
    }

    if (industryResponse?.success == true) {
      industryLeaders = _mapApiResponse(industryResponse!.data);
    }

    if (countryResponse?.success == true) {
      countryLeaders = _mapApiResponse(countryResponse!.data);
    }

    setState(() => isLoading = false);
  }

  /// ===============================
  /// MAP SHOP RESPONSE → SAME UI DATA
  /// ===============================
  List<Map<String, dynamic>> _mapApiResponse(dynamic data) {
    return (data as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map<Map<String, dynamic>>((Map<String, dynamic> item) {
      final Map<String, dynamic> shop =
          Map<String, dynamic>.from(item['shop'] ?? <dynamic, dynamic>{});

      return <String, dynamic>{
        'rank': item['globalRank'] ?? 0,
        'name': shop['name'] ?? '',
        'score': item['impactScore'] ?? 0,
        'image': shop['image'] ?? '',
        'verified': shop['verificationStatus'] == 'approved',
      };
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    loadUsers();
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
    List<Map<String, dynamic>> leaderboardData;

    switch (filterType) {
      case 'Industry':
        leaderboardData = industryLeaders;
        break;
      case 'Country':
        leaderboardData = countryLeaders;
        break;
      default:
        leaderboardData = globalLeaders;
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (leaderboardData.isEmpty) {
      return const Center(child: Text('No leaderboard data'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: leaderboardData.length,
      itemBuilder: (BuildContext context, int index) {
        final Map<String, dynamic> item = leaderboardData[index];
        return _buildLeaderboardItem(item);
      },
    );
  }

  /// ===============================
  /// SAME LEADERBOARD ITEM UI
  /// ===============================
  Widget _buildLeaderboardItem(Map<String, dynamic> item) {
    bool isTop3 = item['rank'] <= 3;
    Color rankColor = isTop3 ? const Color(0xFFFFD700) : Colors.grey.shade400;
    if (item['rank'] == 2) rankColor = const Color(0xFFC0C0C0);
    if (item['rank'] == 3) rankColor = const Color(0xFFCD7F32);

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
                placeHolder: LucideIcons.store,
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
                        item['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (item['verified'] == true) ...<Widget>[
                      const SizedBox(width: 4),
                      const Icon(
                        LucideIcons.badgeCheck,
                        size: 16,
                        color: Colors.blue,
                      ),
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
