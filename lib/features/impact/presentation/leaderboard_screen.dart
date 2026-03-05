import 'package:business_bosses_v2/bbpro/widgets/countrycodes.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/impact/controllers/impact_controller.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({
    super.key,
    this.isMarketplace = false,
    this.selectedCategory,
  });

  final bool isMarketplace;
  final String? selectedCategory;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final List<String> _filters = <String>['Global', 'Industry', 'Country'];

  final ProfileController profileController = Get.find();
  final ShopController shopController = Get.find();
  final ReachController reachController = Get.put(ReachController());

  bool isLoading = false;
  bool isCountryLoading = false;
  bool isIndustryLoading = false;

  String? selectedCountry;
  String? selectedCountryCode;
  String? selectedIndustry;

  final List<String> categories = const <String>[
    'Agriculture, Food & Beverage',
    'Learning & Education',
    'Construction & Real Estate',
    'Fashion & Beauty',
    'Finance & Legal',
    'Healthcare & Wellness',
    'Home, Gardens & Outdoors',
    'Jewellery & Timepieces',
    'Media & Entertainment',
    'Transport & Logistics',
    'Travel & Hospitality',
    'Business Services & Consulting',
  ];

  Future<void> loadUsers() async {
    setState(() => isLoading = true);

    final UserModel user = profileController.myProfile;
    selectedCountry =
        (profileController.myProfile.hasShop && shopController.shop != null)
            ? shopController.shop!.location
            : user.location ?? 'United Kingdom';
    selectedCountryCode = CountryCodes.nameToCode[selectedCountry!] ?? 'NG';
    selectedIndustry =
        (profileController.myProfile.hasShop && shopController.shop != null)
            ? shopController.shop!.category
            : user.industry ?? 'General';

    await reachController.loadLeaderboardData(
        industry: selectedIndustry, country: selectedCountry);

    setState(() => isLoading = false);
  }

  Future<void> loadCountryLeaders(String country) async {
    setState(() => isCountryLoading = true);
    await reachController.loadLeaderboardData(country: country);
    setState(() => isCountryLoading = false);
  }

  Future<void> loadIndustryLeaders(String industry) async {
    setState(() => isIndustryLoading = true);
    await reachController.loadLeaderboardData(industry: industry);
    setState(() => isIndustryLoading = false);
  }

  @override
  void initState() {
    super.initState();

    if (!widget.isMarketplace) {
      _tabController = TabController(length: _filters.length, vsync: this);
      loadUsers();
    } else {
      _loadMarketplaceData();
    }
  }

  Future<void> _loadMarketplaceData() async {
    setState(() => isLoading = true);

    if (widget.selectedCategory == null ||
        widget.selectedCategory!.isEmpty ||
        widget.selectedCategory == 'All') {
      // 🔵 ALL → GLOBAL
      await reachController.loadLeaderboardData();
    } else {
      // 🟢 CATEGORY SELECTED
      selectedIndustry = widget.selectedCategory;
      await reachController.loadLeaderboardData(industry: selectedIndustry);
    }

    setState(() => isLoading = false);
  }

  @override
  void didUpdateWidget(covariant LeaderboardScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isMarketplace &&
        widget.selectedCategory != oldWidget.selectedCategory) {
      _loadMarketplaceData();
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.isMarketplace
          ? null
          : AppBar(
              title: const Text('Top Ranking Businesses'),
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
              ),
              elevation: 0,
              bottom: TabBar(
                controller: _tabController,
                labelColor: primaryColorLT,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryColorLT,
                tabs: _filters.map((String f) => Tab(text: f)).toList(),
              ),
            ),
      body: widget.isMarketplace
          ? _buildMarketplaceLeaderboard()
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                _buildLeaderboardList('Global'),
                _buildLeaderboardList('Industry'),
                _buildLeaderboardList('Country'),
              ],
            ),
    );
  }

  Widget _buildMarketplaceLeaderboard() {
    if ((isLoading || reachController.leaderboardLoading.value) &&
        reachController.globalLeaders.isEmpty &&
        reachController.industryLeaders.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final bool isAll = widget.selectedCategory == null ||
        widget.selectedCategory!.isEmpty ||
        widget.selectedCategory == 'All';

    final List<Map<String, dynamic>> data =
        isAll ? reachController.globalLeaders : reachController.industryLeaders;

    return data.isEmpty
        ? const Center(child: Text('No ranking data'))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildLeaderboardItem(data[index]);
            },
          );
  }

  Widget _buildLeaderboardList(String filterType) {
    List<Map<String, dynamic>> leaderboardData;
    bool currentLoading = false;

    switch (filterType) {
      case 'Industry':
        leaderboardData = reachController.industryLeaders;
        currentLoading = isIndustryLoading;
        break;
      case 'Country':
        leaderboardData = reachController.countryLeaders;
        currentLoading = isCountryLoading;
        break;
      default:
        leaderboardData = reachController.globalLeaders;
        currentLoading = false;
    }

    if ((isLoading ||
            reachController.leaderboardLoading.value ||
            currentLoading) &&
        leaderboardData.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: <Widget>[
        if (filterType == 'Country')
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          CountryCodes.nameToCode[selectedCountry] != null
                              ? _generateFlag(
                                  CountryCodes.nameToCode[selectedCountry]!)
                              : '📍',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Current Country',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                selectedCountry ?? 'Not Set',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CountryListPick(
                          appBar: AppBar(
                            title: const Text('Select Country'),
                            backgroundColor: Colors.white,
                          ),
                          theme: CountryTheme(
                            isShowFlag: true,
                            isShowTitle: false,
                            isShowCode: false,
                            isDownIcon: true,
                            showEnglishName: true,
                          ),
                          initialSelection: selectedCountryCode,
                          onChanged: (CountryCode? code) {
                            if (code != null && code.name != null) {
                              setState(() {
                                selectedCountry = code.name;
                                selectedCountryCode = code.code;
                              });
                              loadCountryLeaders(code.name!);
                            }
                          },
                          pickerBuilder:
                              (BuildContext context, CountryCode? countryCode) {
                            return const Icon(LucideIcons.edit3,
                                size: 20, color: primaryColorLT);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (filterType == 'Industry')
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(LucideIcons.briefcase,
                      size: 20, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Selected Industry',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          selectedIndustry ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(LucideIcons.edit3,
                        size: 20, color: primaryColorLT),
                    onSelected: (String value) {
                      setState(() {
                        selectedIndustry = value;
                      });
                      loadIndustryLeaders(value);
                    },
                    itemBuilder: (BuildContext context) {
                      return categories.map((String category) {
                        return PopupMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: currentLoading
              ? const Center(child: CircularProgressIndicator())
              : leaderboardData.isEmpty
                  ? Center(
                      child: Text(
                        filterType == 'Global'
                            ? 'No global data'
                            : filterType == 'Industry'
                                ? 'No data for this industry'
                                : 'No data for this country',
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      itemCount: leaderboardData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> item =
                            leaderboardData[index];
                        return _buildLeaderboardItem(item);
                      },
                    ),
        ),
      ],
    );
  }

  String _generateFlag(String countryCode) {
    if (countryCode.length != 2) return '🌐';
    final int firstLetter = countryCode.codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> item) {
    bool isTop3 = item['rank'] <= 3;
    Color rankColor = isTop3 ? const Color(0xFFFFD700) : Colors.grey.shade400;
    if (item['rank'] == 2) rankColor = const Color(0xFFC0C0C0);
    if (item['rank'] == 3) rankColor = const Color(0xFFCD7F32);

    return GestureDetector(
      onTap: () {
        Get.to(
          () => PublicProfileScreen(
            currentIndex: 1,
          ),
          arguments: item['user'],
        );
      },
      child: Container(
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
            color:
                isTop3 ? rankColor.withValues(alpha: 0.3) : Colors.transparent,
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
                  imageUrl: item['image'] ?? '',
                  placeHolder: LucideIcons.store,
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
                    '${item['description']}',
                    maxLines: 1,
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
      ),
    );
  }
}
