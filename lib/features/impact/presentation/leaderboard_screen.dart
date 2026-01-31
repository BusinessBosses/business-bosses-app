import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:business_bosses_v2/bbpro/widgets/countrycodes.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/profile/presentation/public_profile_screen.dart';
import 'package:country_list_pick/country_list_pick.dart';
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
  const LeaderboardScreen({super.key, this.isMarketplace = false});

  final bool isMarketplace;

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
  bool isCountryLoading = false;
  bool isIndustryLoading = false;

  String? selectedCountry;
  String? selectedCountryCode;
  String? selectedIndustry;

  List<Map<String, dynamic>> globalLeaders = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> industryLeaders = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> countryLeaders = <Map<String, dynamic>>[];

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
            : user.location ?? 'Nigeria';
    selectedCountryCode = CountryCodes.nameToCode[selectedCountry!] ?? 'NG';
    selectedIndustry =
        (profileController.myProfile.hasShop && shopController.shop != null)
            ? shopController.shop!.category
            : user.industry ?? 'General';

    ApiResponseModel industryResponse;
    ApiResponseModel countryResponse;

    final ApiResponseModel globalResponse =
        await ApiService.get(path: 'impact/top/shops?limit=30');

    if (profileController.myProfile.hasShop && shopController.shop != null) {
      industryResponse = await ApiService.get(
        path:
            'impact/top/shops/category?category=${Uri.encodeComponent(shopController.shop!.category)}&limit=30',
      );

      countryResponse = await ApiService.get(
        path:
            'impact/top/shops/location?location=${Uri.encodeComponent(shopController.shop!.location)}&limit=30',
      );
    } else {
      industryResponse = await ApiService.get(
        path: 'impact/top/shops/category?category=$selectedIndustry&limit=30',
      );

      countryResponse = await ApiService.get(
        path: 'impact/top/shops/location?location=$selectedCountry&limit=30',
      );
    }

    if (globalResponse.success) {
      globalLeaders = _mapApiResponse(globalResponse.data);
    }

    if (industryResponse.success) {
      industryLeaders = _mapApiResponse(industryResponse.data);
    }

    if (countryResponse.success) {
      countryLeaders = _mapApiResponse(countryResponse.data);
    }

    setState(() => isLoading = false);
  }

  Future<void> loadCountryLeaders(String country) async {
    setState(() => isCountryLoading = true);
    final ApiResponseModel response = await ApiService.get(
      path:
          'impact/top/shops/location?location=${Uri.encodeComponent(country)}&limit=30',
    );
    if (response.success) {
      countryLeaders = _mapApiResponse(response.data);
    }
    setState(() => isCountryLoading = false);
  }

  Future<void> loadIndustryLeaders(String industry) async {
    setState(() => isIndustryLoading = true);
    final ApiResponseModel response = await ApiService.get(
      path:
          'impact/top/shops/category?category=${Uri.encodeComponent(industry)}&limit=30',
    );
    if (response.success) {
      industryLeaders = _mapApiResponse(response.data);
    }
    setState(() => isIndustryLoading = false);
  }

  /// ===============================
  /// MAP SHOP RESPONSE → SAME UI DATA
  /// ===============================
  List<Map<String, dynamic>> _mapApiResponse(dynamic data) {
    final List<dynamic> list = data is List<dynamic> ? data : <dynamic>[];
    return list
        .asMap()
        .entries
        .map<Map<String, dynamic>>((MapEntry<int, dynamic> entry) {
      final int index = entry.key;
      final Map<String, dynamic> item = Map<String, dynamic>.from(entry.value);
      final Shop shop = Shop.fromMap(item['shop']);
      final UserModel user = UserModel.fromMap(item['shop']['user']);

      return <String, dynamic>{
        'rank': item['globalRank'] ?? (index + 1),
        'name': shop.name,
        'description': shop.description,
        'user': user,
        'score': item['impactScore'] ?? 0,
        'image': shop.image ?? '',
        'verified': shop.verificationStatus == 'approved',
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
      appBar: widget.isMarketplace
          ? null
          : AppBar(
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
                tabs:
                    _filters.map((String filter) => Tab(text: filter)).toList(),
              ),
            ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildLeaderboardList('Global'),
          if (!widget.isMarketplace) _buildLeaderboardList('Industry'),
          if (!widget.isMarketplace) _buildLeaderboardList('Country'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(String filterType) {
    List<Map<String, dynamic>> leaderboardData;
    bool currentLoading = false;

    switch (filterType) {
      case 'Industry':
        leaderboardData = industryLeaders;
        currentLoading = isIndustryLoading;
        break;
      case 'Country':
        leaderboardData = countryLeaders;
        currentLoading = isCountryLoading;
        break;
      default:
        leaderboardData = globalLeaders;
        currentLoading = false;
    }

    if (isLoading) {
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
