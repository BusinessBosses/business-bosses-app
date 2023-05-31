import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/models/user_model.dart';
import '../../common/widgets/safety_model.dart';
import '../../services/api_service.dart';
import '../../utils/constants/constants.dart';
import '../../utils/size_config.dart';
import '../../utils/theme/theme.dart';
import '../marketplace/controllers/market_controller.dart';
import '../marketplace/models/market_model.dart';
import '../marketplace/presentation/market_members.dart';
import '../marketplace/presentation/sell_screen.dart';
import '../marketplace/widgets/marketplace_item.dart';
import '../profile/controller/profile_controller.dart';

/// Buying and Selling screen
class MarketplaceScreen extends StatefulWidget {
  /// Mrketplace constructor
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  final ProfileController _profileController = Get.find();
  final MarketController _marketController = Get.find();
  String? _selectedCategory;
  String? _selectedLocation;
  final bool _isSearching = false;
  String? filterCode;
  String? filterLocation;
  String? filterCategory;

  @override
  void initState() {
    super.initState();
  }

  filterResults() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Marketplace'),
          actions: [
            IconButton(
                icon: _isSearching
                    ? const Icon(Icons.close)
                    : SvgPicture.asset(
                        'assets/svgs/search.svg',
                      ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                        child: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Filter'),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  color: Colors.red,
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: backgroundcolorinterface,
                                      borderRadius:
                                          BorderRadius.circular(radiusValue),
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 16.0,
                                      right: 16,
                                      top: 4,
                                      bottom: 5,
                                    ),
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: DropdownButton<String>(
                                      underline: Container(),
                                      value: _selectedCategory,
                                      isExpanded: true,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_right,
                                      ),
                                      iconSize: 24,
                                      elevation: 16,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedCategory = newValue!;
                                        });
                                      },
                                      items: <String?>[
                                        null,
                                        'Home, Garden & Outdoors',
                                        'Fashion & Beauty',
                                        'Sports & Entertainment',
                                        'Books & Education',
                                        'Jewellery & Timepieces',
                                        'Security, Safety & Equipment',
                                        'Video Games & Electronics',
                                        'Agriculture, Food, Beverage',
                                        'Construction & Real Estate',
                                        'Vehicle & Transportation',
                                        'Business Services & Events',
                                        'Other',
                                      ].map<DropdownMenuItem<String>>(
                                          (String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: value != null
                                              ? Text(value)
                                              : Text(
                                                  value ?? 'Select Category',
                                                  style: bodyText2.copyWith(
                                                    color: hintColor,
                                                  ),
                                                ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  CountryListPick(
                                    appBar: AppBar(
                                      leading: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: SvgPicture.asset(
                                            'assets/svgs/backbutton.svg'),
                                      ),
                                      centerTitle: true,
                                      // ignore: prefer_const_constructors
                                      title: Text(
                                        'Select Location',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    initialSelection: filterCode ?? 'GB',
                                    pickerBuilder: (BuildContext context,
                                        CountryCode? countryCode) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: backgroundcolorinterface,
                                          borderRadius: BorderRadius.circular(
                                              radiusValue),
                                        ),
                                        child: ListTile(
                                          leading: _selectedLocation != null
                                              ? Text(_selectedLocation!)
                                              : Text(
                                                  'Location',
                                                  style: bodyText2.copyWith(
                                                      color: hintColor),
                                                ),
                                          trailing: const Icon(
                                              Icons.keyboard_arrow_right),
                                        ),
                                      );
                                    },
                                    onChanged: (CountryCode? code) {
                                      setState(
                                        () {
                                          _selectedLocation = code?.name;
                                          filterCode = code?.code;
                                        },
                                      );
                                    },
                                    useSafeArea: false,
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Reset'),
                                onPressed: () {
                                  setState(() {
                                    filterLocation = null;
                                    filterCode = null;
                                    filterCategory = null;
                                    _selectedLocation = null;
                                    _selectedCategory = null;
                                    _marketController.initMarket();
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                              ElevatedButton(
                                child: const Text('Search'),
                                onPressed: () {
                                  setState(() {
                                    filterLocation = _selectedLocation;
                                    filterCategory = _selectedCategory;
                                    _marketController.filterMarket(
                                        filterLocation, filterCategory);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }),
                      );
                    },
                  );
                }),
          ]),
      body: _marketController.isLoading
          ? const CircularProgressIndicator()
          : NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverStickyHeader(
                    sticky: false,
                    header: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 25),
                                child: GestureDetector(
                                  onTap: (() {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          sellingGuide(),
                                    );
                                  }),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Guidelines ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SvgPicture.asset(
                                        'assets/svgs/info.svg',
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(150,
                                              45) // put the width and height you want
                                          ),
                                      onPressed: () {
                                        Get.to(
                                          () => const CreateSellingitemScreen(
                                            isUpd: false,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const Text(
                                            'Sell',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SvgPicture.asset(
                                              'assets/svgs/startatopic.svg')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, right: 20, left: 20),
                                      height: 150,
                                      width: double.infinity,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: FittedBox(
                                          fit: BoxFit.fill,
                                          child: Image.asset(
                                              'assets/images/postbackground.png'),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 25, right: 20, left: 35),
                                              height: 86,
                                              width: 142,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: FittedBox(
                                                  child: CachedNetworkImage(
                                                    memCacheWidth: 256,
                                                    imageUrl:
                                                        'http://44.210.87.234/learningImages/marketplace.jpg',
                                                    placeholder: (BuildContext
                                                                context,
                                                            String photo) =>
                                                        const CircularProgressIndicator(),
                                                    errorWidget: (BuildContext
                                                                context,
                                                            String photo,
                                                            dynamic error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 35),
                                                child: Text(
                                                  '- Sell your products and services \n - Find Supplies',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 5,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Stack(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 35,
                                                    top: 5,
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 8,
                                                      top: 8,
                                                      left: 10,
                                                      right: 10,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              200),
                                                      color: primaryColorLT,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 8),
                                                          child: SvgPicture.asset(
                                                              'assets/svgs/members.svg'),
                                                        ),
                                                        Obx(() {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              Get.to(() =>
                                                                  MarketMembersScreen(
                                                                    users: _marketController
                                                                        .users,
                                                                  ));
                                                            },
                                                            child: RichText(
                                                              text: TextSpan(
                                                                children: [
                                                                  TextSpan(
                                                                    text:
                                                                        'Members: (${_marketController.users.length})',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Stack(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, top: 5),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8,
                                                            top: 8,
                                                            left: 10,
                                                            right: 10),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              200),
                                                      color:
                                                          const Color.fromARGB(
                                                              47,
                                                              255,
                                                              255,
                                                              255),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 8),
                                                          child: Icon(
                                                            Icons
                                                                .shopping_cart_checkout_outlined,
                                                            color: Colors.white,
                                                            size: 15,
                                                          ),
                                                        ),
                                                        Obx(
                                                          () {
                                                            return RichText(
                                                              text: TextSpan(
                                                                children: <InlineSpan>[
                                                                  TextSpan(
                                                                    text:
                                                                        'Listings: ${_marketController.markets.length}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Flexible(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 20,
                                                  ),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            joinedButton(),
                                                          ],
                                                        )),
                                                  )),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ]),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ];
              },
              body: Padding(
                padding: const EdgeInsets.only(bottom: 100, top: 20),
                child: Obx(() {
                  if (_marketController.loading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_marketController.error.value) {
                    return const SafetyModel(
                      isLoading: false,
                      title: 'Error While Loading Data',
                      subTitle: 'Try Reloading Again',
                      icon: Icon(
                        Icons.warning,
                        size: 60,
                      ),
                    );
                  } else {
                    return _marketController.markets.isEmpty
                        ? filterCategory != null || filterLocation != null
                            ? SafetyModel(
                                isLoading: false,
                                icon: const Icon(
                                  Icons.shopping_cart,
                                  color: Colors.grey,
                                  size: 80.0,
                                ),
                                title: 'No Items Available For This Search',
                                // subTitle: '',
                                clickableText: 'View All',
                                onTap: () {
                                  setState(() {
                                    filterLocation = null;
                                    filterCode = null;
                                    filterCategory = null;
                                    _selectedLocation = null;
                                    _selectedCategory = null;
                                    _marketController.initMarket();
                                  });
                                },
                              )
                            : SafetyModel(
                                isLoading: false,
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                  size: 80.0,
                                ),
                                title: 'Be the first one to Sell your Item',
                                // subTitle: '',
                                clickableText: 'Start a topic',
                                onTap: () {
                                  Get.to(
                                    () => const CreateSellingitemScreen(
                                      isUpd: false,
                                    ),
                                  );
                                },
                              )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: _marketController.markets.length,
                            itemBuilder: (BuildContext context, int index) {
                              final MarketModel market =
                                  _marketController.markets[index];

                              return MarketTile(
                                post: market,
                              );
                            },
                          );
                  }
                }),
              ),
            ),
    );
  }

  Widget joinedButton() {
    return GestureDetector(
      onTap: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? userId = prefs.getString(Constants.USER_ID);
        await ApiService.post(path: 'members', body: <String, dynamic>{
          'type': 'marketplace',
        });
        setState(() {
          if (_marketController.isJoined.value) {
            _marketController.users
                .removeWhere((UserModel user) => user.uid == userId);
          } else {
            _marketController.users.add(_profileController.myProfile);
          }
          _marketController.isJoined.value = !_marketController.isJoined.value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(
            () => Text(
              _marketController.isJoined.value ? 'Leave' : 'Join',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget sellingGuide() {
    return Dialog(
      backgroundColor: backgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            const Text(
                'All listings created on Business Bosses must meet the following guidelines or the listing and the user account will be deleted and banned permanently.'),
            const SizedBox(
              height: 20,
            ),
            Text(
              'GUIDELINES',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w900, color: Colors.black),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫 ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Weapons, ammunitions, explosives, and hazardous goods listings are not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Human trafficking, prostitution, escort, sexual services or pornographic listings are not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Illegal Drugs, Prescription or Recreational Drugs, Other Drug paraphernalia and alcohol listings is not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'You cannot list stolen goods and your listing must not infringe intellectual property rights of a third-party (e.g. copyright)',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚫  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Selling animals and posting about animals for adoption listings are not allowed',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅  ', style: bodyText2),
                Expanded(
                  child: Text(
                      'Ensure any image and description are honest and fair.',
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('✅  ', style: bodyText2),
                Expanded(
                  child: Text(
                      "Business Bosses does not offer an in-built payment feature yet, it's down to you to choose a payment provider that offers buyer protection (e.g PayPal or escrow)",
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockHorizontal * 3,
            ),
          ],
        ),
      ),
    );
  }
}
