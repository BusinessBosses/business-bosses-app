import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/widgets/popup/bossup_challenge_popup.dart';
import '../../utils/size_config.dart';
import '../../utils/theme/theme.dart';

/// Buying and Selling screen
class MarketplaceScreen extends StatefulWidget {
  /// Mrketplace constructor
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String? _selectedCategory;
  String? _selectedLocation;
  final bool _isSearching = false;
  String? filterCode;
  String? filterLocation;
  String? filterCategory;
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
                                              ? Text(
                                                  value,
                                                )
                                              : Text(
                                                  'Select Category',
                                                  style: bodyText2.copyWith(
                                                      color: hintColor),
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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                          padding: const EdgeInsets.only(left: 20, top: 25),
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
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text(
                                      'Add Listing',
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
                                  borderRadius: BorderRadius.circular(15.0),
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
                                              errorWidget:
                                                  (BuildContext context,
                                                          String photo,
                                                          dynamic error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 35),
                                          child: Text(
                                            'Description will be here',
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
                                            padding: const EdgeInsets.only(
                                              left: 35,
                                              top: 5,
                                            ),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                bottom: 8,
                                                top: 8,
                                                left: 10,
                                                right: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                color: primaryColorLT,
                                              ),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: SvgPicture.asset(
                                                        'assets/svgs/members.svg'),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                            text: 'Members: 0',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white),
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap =
                                                                      () {}),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5),
                                            child: Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8,
                                                  top: 8,
                                                  left: 10,
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(200),
                                                color: const Color.fromARGB(
                                                    47, 255, 255, 255),
                                              ),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/svgs/entries.svg'),
                                                  RichText(
                                                    text: const TextSpan(
                                                      children: <InlineSpan>[
                                                        TextSpan(
                                                          text: 'Listings: (0)',
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 20,
                                            ),
                                            child: SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
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
                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //     left: 20.0,
                                  //     right: 5,
                                  //   ),
                                  //   child: StreamBuilder<Event>(
                                  //     stream: FirebaseDatabase.instance
                                  //         .reference()
                                  //         .child(
                                  //             "/settings/BossUp/companyName")
                                  //         .onValue,
                                  //     builder: (BuildContext context,
                                  //         AsyncSnapshot snapshot) {
                                  //       if (snapshot.hasData &&
                                  //           snapshot.data.snapshot
                                  //                   .value !=
                                  //               null) {
                                  //         var data = snapshot
                                  //             .data.snapshot.value;
                                  //         return GestureDetector(
                                  //           onTap: () {
                                  //             Navigator.push(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                   builder: (BuildContext
                                  //                           context) =>
                                  //                       const Bossuppartner()),
                                  //             );
                                  //           },
                                  //           child: Padding(
                                  //             padding:
                                  //                 const EdgeInsets.only(
                                  //                     right: 15, top: 5),
                                  //             child: Container(
                                  //               height: 40,
                                  //               decoration: BoxDecoration(
                                  //                 color: const Color(
                                  //                     0xFFF4F4F4),
                                  //                 borderRadius:
                                  //                     BorderRadius
                                  //                         .circular(10),
                                  //                 boxShadow: [
                                  //                   BoxShadow(
                                  //                     color: Colors.grey
                                  //                         .withOpacity(
                                  //                             0.3),
                                  //                     spreadRadius: 20,
                                  //                     blurRadius: 500,
                                  //                     offset:
                                  //                         const Offset(
                                  //                             0, 3),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               child: Row(
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets
                                  //                             .only(
                                  //                       left: 10,
                                  //                     ),
                                  //                     child: Container(
                                  //                       height: 25,
                                  //                       width: 100,
                                  //                       decoration:
                                  //                           BoxDecoration(
                                  //                         color: const Color(
                                  //                             0xFFEAEAEA),
                                  //                         borderRadius:
                                  //                             BorderRadius
                                  //                                 .circular(
                                  //                                     20),
                                  //                       ),
                                  //                       child:
                                  //                           const Center(
                                  //                         child: Padding(
                                  //                           padding:
                                  //                               EdgeInsets
                                  //                                   .all(
                                  //                                       2),
                                  //                           child: Text(
                                  //                               "Boss Up by"),
                                  //                         ),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   const SizedBox(
                                  //                       width: 10),
                                  //                   Text(
                                  //                     data.toString(),
                                  //                     style:
                                  //                         const TextStyle(
                                  //                       fontSize: 15,
                                  //                       fontWeight:
                                  //                           FontWeight
                                  //                               .bold,
                                  //                       decoration:
                                  //                           TextDecoration
                                  //                               .underline,
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //             ),
                                  //           ),
                                  //         );
                                  //       } else {
                                  //         return Container();
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
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
        body: Container(),
      ),
    );
  }

  Widget joinedButton() {
    return GestureDetector(
      onTap: () {},
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
          child: const Text(
            'Join',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("🚫 ", style: bodyText2),
                Expanded(
                  child: Text(
                      "Weapons, ammunitions, explosives, and hazardous goods listings are not allowed",
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("🚫  ", style: bodyText2),
                Expanded(
                  child: Text(
                      "Human trafficking, prostitution, escort, sexual services or pornographer listings are not allowed",
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("🚫  ", style: bodyText2),
                Expanded(
                  child: Text(
                      "Illegal Drugs, Prescription or Recreational Drugs, Other Drug paraphernalia and alcohol listings is not allowed",
                      style: bodyText2),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 2,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("🚫  ", style: bodyText2),
                Expanded(
                  child: Text(
                      "You cannot list stolen goods and your listing must not infringe intellectual property rights of a third-party (e.g. copyright)",
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
                Text("🚫  ", style: bodyText2),
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
