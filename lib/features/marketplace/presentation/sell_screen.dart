// ignore_for_file: equal_keys_in_map

import 'package:business_bosses_v2/features/home/widgets/sellingpopup.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../action/action.dart';
import '../../../common/dialogs/snackbar.dart';
import '../../../common/models/comment_model.dart';
import '../../../common/widgets/buttons/my_outlined_button.dart';
import '../../../common/widgets/gallery_screen.dart';
import '../../../utils/theme/theme.dart';
import '../../forum/widgets/field_container.dart';
import '../../posts/widgets/preview.dart';
import '../../profile/controller/profile_controller.dart';
import '../controllers/create_market_controller.dart';
import '../controllers/market_controller.dart';
import '../models/market_model.dart';

/// SELLING SCREEN MARKETPLACE
class CreateSellingitemScreen extends StatefulWidget {
  /// SELLING SCREEN MARKETPLACE
  const CreateSellingitemScreen({Key? key, this.market, required this.isUpd})
      : super(key: key);

  /// String if to update;
  final MarketModel? market;
  final bool isUpd;

  // CreateSellingitemScreen();
  @override
  // ignore: library_private_types_in_public_api
  _CreateSellingitemScreenState createState() =>
      _CreateSellingitemScreenState();
}

class _CreateSellingitemScreenState extends State<CreateSellingitemScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  final ProfileController _profileController = Get.find();
  // ignore: unused_field
  final MarketController _marketController = Get.put(MarketController());
  final CreateMarketController createMarketController =
      Get.put(CreateMarketController());
  List<bool>? _fileProcessing;

  List<MyAssetEntity> _myAssetsEntities = <MyAssetEntity>[];

  MarketModel? _market;

  Map<String, String> currencyValues = <String, String>{
    'Afghanistan': 'AFN',
    'Albania': 'ALL',
    'Algeria': 'DZD',
    'AmericanSamoa': 'USD',
    'Andorra': 'EUR',
    'Angola': 'AOA',
    'Anguilla': 'XCD',
    'Antarctica': '',
    'Antigua and Barbuda': 'XCD',
    'Argentina': 'ARS',
    'Armenia': 'AMD',
    'Aruba': 'AWG',
    'Australia': 'AUD',
    'Austria': 'EUR',
    'Azerbaijan': 'AZN',
    'Bahamas (The)': 'BSD',
    'Bahrain': 'BHD',
    'Bangladesh': 'BDT',
    'Barbados': 'BBD',
    'Belarus': 'BYN',
    'Belgium': 'EUR',
    'Belize': 'BZD',
    'Benin': 'XOF',
    'Bermuda': 'BMD',
    'Bhutan': 'BTN',
    'Bhutan (Indian Rupee)': 'INR',
    'Bolivia, Plurinational State of': 'BOB',
    'Bolivia (Plurinational State of) (Mvdol)': 'BOV',
    'Bonaire, Sint Eustatius and Saba': 'USD',
    'Bosnia and Herzegovina': 'BAM',
    'Botswana': 'BWP',
    'Bouvet Island': 'NOK',
    'Brazil': 'BRL',
    'British Indian Ocean Territory': 'USD',
    'Brunei Darussalam': 'BND',
    'Bulgaria': 'BGN',
    'Burkina Faso': 'XOF',
    'Burundi': 'BIF',
    'Cabo Verde': 'CVE',
    'Cambodia': 'KHR',
    'Cameroon': 'XAF',
    'Canada': 'CAD',
    'Cayman Islands (The)': 'KYD',
    'Central African Republic': 'XAF',
    'Chad': 'XAF',
    'Chile (Unidad de Fomento)': 'CLF',
    'Chile (Chilean Peso)': 'CLP',
    'China': 'CNY',
    'Christmas Island': 'AUD',
    'Cocos (Keeling) Islands': 'AUD',
    'Colombia': 'COP',
    'Colombia': 'COU',
    'Comoros': 'KMF',
    'Congo, The Democratic Republic of the Congo': 'CDF',
    'Congo': 'XAF',
    'Cook Islands': 'NZD',
    'Costa Rica': 'CRC',
    'Croatia': 'EUR',
    'Cuba': 'CUC',
    'Cuba': 'CUP',
    'Curaçao': 'ANG',
    'Cyprus': 'EUR',
    'Czech Republic': 'CZK',
    "Cote d'Ivoire": 'XOF',
    'Denmark': 'DKK',
    'Djibouti': 'DJF',
    'Dominica': 'XCD',
    'Dominican Republic (The)': 'DOP',
    'Ecuador': 'USD',
    'Egypt': 'EGP',
    'El Salvador': 'SVC',
    'El Salvador': 'USD',
    'Equatorial Guinea': 'XAF',
    'Eritrea': 'ERN',
    'Estonia': 'EUR',
    'Ethiopia': 'ETB',
    'European Union': 'EUR',
    'Falkland Islands (Malvinas)': 'FKP',
    'Faroe Islands': 'DKK',
    'Fiji': 'FJD',
    'Finland': 'EUR',
    'France': 'EUR',
    'French Guiana': 'EUR',
    'French Polynesia': 'XPF',
    'French Southern Territories': 'EUR',
    'Gabon': 'XAF',
    'Gambia (The)': 'GMD',
    'Georgia': 'GEL',
    'Germany': 'EUR',
    'Ghana': 'GHS',
    'Gibraltar': 'GIP',
    'Greece': 'EUR',
    'Greenland': 'DKK',
    'Grenada': 'XCD',
    'Guadeloupe': 'EUR',
    'Guam': 'USD',
    'Guatemala': 'GTQ',
    'Guernsey': 'GBP',
    'Guinea': 'GNF',
    'Guinea-Bissau': 'XOF',
    'Guyana': 'GYD',
    'Haiti': 'HTG',
    'Haiti': 'USD',
    'Heard Island and McDonald Islands': 'AUD',
    'Holy See (Vatican City State)': 'EUR',
    'Honduras': 'HNL',
    'Hong Kong': 'HKD',
    'Hungary': 'HUF',
    'Iceland': 'ISK',
    'India': 'INR',
    'Indonesia': 'IDR',
    'Iran, Islamic Republic of Persian Gulf': 'IRR',
    'Iraq': 'IQD',
    'Ireland': 'EUR',
    'Isle of Man': 'GBP',
    'Israel': 'ILS',
    'Italy': 'EUR',
    'Jamaica': 'JMD',
    'Japan': 'JPY',
    'Jersey': 'GBP',
    'Jordan': 'JOD',
    'Kazakhstan': 'KZT',
    'Kenya': 'KES',
    'Kiribati': 'AUD',
    'Korea, Democratic People’s Republic of Korea)': 'KPW',
    'Korea, Republic of South Korea': 'KRW',
    'Kuwait': 'KWD',
    'Kyrgyzstan': 'KGS',
    'Laos': 'LAK',
    'Latvia': 'EUR',
    'Lebanon': 'LBP',
    'Lesotho (Loti)': 'LSL',
    'Lesotho (Rand)': 'ZAR',
    'Liberia': 'LRD',
    'Libyan Arab Jamahiriya': 'LYD',
    'Liechtenstein': 'CHF',
    'Lithuania': 'EUR',
    'Luxembourg': 'EUR',
    'Macao': 'MOP',
    'Madagascar': 'MGA',
    'Malawi': 'MWK',
    'Malaysia': 'MYR',
    'Maldives': 'MVR',
    'Mali': 'XOF',
    'Malta': 'EUR',
    'Marshall Islands (The)': 'USD',
    'Martinique': 'EUR',
    'Mauritania': 'MRU',
    'Mauritius': 'MUR',
    'Mayotte': 'EUR',
    'Member Countries of the African Development Bank Group': 'XUA',
    'Mexico (Mexican Peso)': 'MXN',
    'Mexico (Mexican Unidad de Inversion - UDI)': 'MXV',
    'Micronesia, Federated States of Micronesia': 'USD',
    'Moldova': 'MDL',
    'Monaco': 'EUR',
    'Mongolia': 'MNT',
    'Montenegro': 'EUR',
    'Montserrat': 'XCD',
    'Morocco': 'MAD',
    'Mozambique': 'MZN',
    'Myanmar': 'MMK',
    'Namibia': 'NAD',
    'Namibia': 'ZAR',
    'Nauru': 'AUD',
    'Nepal': 'NPR',
    'Netherlands (The)': 'EUR',
    'New Caledonia': 'XPF',
    'New Zealand': 'NZD',
    'Nicaragua': 'NIO',
    'Niger (The)': 'XOF',
    'Nigeria': 'NGN',
    'Niue': 'NZD',
    'Norfolk Island': 'AUD',
    'Northern Mariana Islands (The)': 'USD',
    'Norway': 'NOK',
    'Oman': 'OMR',
    'Pakistan': 'PKR',
    'Palau': 'USD',
    'Palestinian Territory, Occupied, State of': '',
    'Panama': 'PAB',
    'Panama': 'USD',
    'Papua New Guinea': 'PGK',
    'Paraguay': 'PYG',
    'Peru': 'PEN',
    'Philippines (The)': 'PHP',
    'Pitcairn': 'NZD',
    'Poland': 'PLN',
    'Portugal': 'EUR',
    'Puerto Rico': 'USD',
    'Qatar': 'QAR',
    'Republic of North Macedonia': 'MKD',
    'Romania': 'RON',
    'Russian Federation (The)': 'RUB',
    'Rwanda': 'RWF',
    'Réunion': 'EUR',
    'Saint Barthélemy': 'EUR',
    'Saint Helena, Ascension and Tristan da Cunha': 'SHP',
    'Saint Kitts and Nevis': 'XCD',
    'Saint Lucia': 'XCD',
    'Saint Martin (French Part)': 'EUR',
    'Saint Pierre and Miquelon': 'EUR',
    'Saint Vincent and the Grenadines': 'XCD',
    'Samoa': 'WST',
    'San Marino': 'EUR',
    'Sao Tome and Principe': 'STN',
    'Saudi Arabia': 'SAR',
    'Senegal': 'XOF',
    'Serbia': 'RSD',
    'Seychelles': 'SCR',
    'Sierra Leone': 'SLE',
    'Singapore': 'SGD',
    'Sint Maarten (Dutch Part)': 'ANG',
    'Sistema Unitario de Compensacion Regional de Pagos "Sucre"': 'XSU',
    'Slovakia': 'EUR',
    'Slovenia': 'EUR',
    'Solomon Islands': 'SBD',
    'Somalia': 'SOS',
    'South Africa': 'ZAR',
    'South Georgia and the South Sandwich Islands': '',
    'South Sudan': 'SSP',
    'Spain': 'EUR',
    'Sri Lanka': 'LKR',
    'Sudan (The)': 'SDG',
    'Suriname': 'SRD',
    'Svalbard and Jan Mayen': 'NOK',
    'Swaziland': 'SZL',
    'Sweden': 'SEK',
    'Switzerland (WIR Euro)': 'CHE',
    'Switzerland (Swiss Franc)': 'CHF',
    'Switzerland (WIR Franc)': 'CHW',
    'Syrian Arab Republic': 'SYP',
    'Taiwan (Province of China)': 'TWD',
    'Tajikistan': 'TJS',
    'Tanzania, United Republic of Tanzania': 'TZS',
    'Thailand': 'THB',
    'Timor-Leste': 'USD',
    'Togo': 'XOF',
    'Tokelau': 'NZD',
    'Tonga': 'TOP',
    'Trinidad and Tobago': 'TTD',
    'Tunisia': 'TND',
    'Turkey': 'TRY',
    'Turkmenistan': 'TMT',
    'Turks and Caicos Islands': 'USD',
    'Tuvalu': 'AUD',
    'Uganda': 'UGX',
    'Ukraine': 'UAH',
    'United Arab Emirates (The)': 'AED',
    'United Kingdom': 'GBP',
    'United States': 'USD',
    'United States of America (The)': 'USD',
    'United States of America (The) (US Dollar Next day)': 'USN',
    'Uruguay (Uruguay Peso en Unidades Indexadas - URUIURUI)': 'UYI',
    'Uruguay (Peso Uruguayo)': 'UYU',
    'Uzbekistan': 'UZS',
    'Vanuatu': 'VUV',
    'Venezuela, Bolivarian Republic of Venezuela': 'VEF',
    'Venezuela (Bolivarian Republic of)': 'VED',
    'Vietnam': 'VND',
    'Virgin Islands, British': 'USD',
    'Virgin Islands, U.S.': 'USD',
    'Wallis and Futuna': 'XPF',
    'Western Sahara': 'MAD',
    'Yemen': 'YER',
    'Zambia': 'ZMW',
    'Zimbabwe': 'ZWL',
    'Aland Islands': 'EUR',
  };

  String? description;
  String? price;
  String? discount;
  String? currency;
  String? _selectedCategory;
  String? _selectedLocation;
  String? filterCode;
  String? filterLocation;
  String? filterCategory;
  bool _isProcessing = false;
  bool? _isUpdating;
  bool _shouldPromote = false;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  String? defaultcountry;
  Future<String?>? getCountryValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLocation = prefs.getString('country') ?? _market!.location;
    });
    return _selectedLocation;
  }

  @override
  void initState() {
    getCountryValue();
    super.initState();

    _isUpdating = widget.isUpd;
    if (widget.isUpd) {
      _market = widget.market;
    }
    descriptionController.text = _market?.description ?? '';
    _priceController.text = _market?.price ?? '';

    _discountController.text = _market?.discount.toString() ?? '';
    _selectedCategory = _market?.category;
    _fileProcessing = <bool>[];
  }

  @override
  Widget build(BuildContext context) {
    _currencyController.text = _selectedLocation != null
        ? '${currencyValues[_selectedLocation]}'
        : 'USD';
    return GetBuilder<CreateMarketController>(
        builder: (CreateMarketController controller) {
      return GestureDetector(
        onTap: () => unFocusKeyboard(context),
        child: Scaffold(
          backgroundColor: backgroundcolorinterface,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(widget.isUpd
                ? 'Edit Product Listing'
                : 'Create Product Listing'),
            automaticallyImplyLeading: false, // Used for removing back buttoon.
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, left: 0.0, right: 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: _currencyController,
                          onChanged: (String val) => currency = val,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          maxLength: 3,
                          decoration: inputDecoration.copyWith(
                            hintText: '${currencyValues[_selectedLocation]}',
                          ),
                        ),
                        // child: Padding(
                        //   padding: const EdgeInsets.only(
                        //       top: 18.0), // Adjust the value as needed
                        //   child: Text(
                        //     _selectedLocation != null
                        //         ? '${currencyValues[_selectedLocation]}'
                        //         : 'USD',
                        //     style: const TextStyle(fontWeight: FontWeight.w700),
                        //   ),
                        // ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex:
                            6, // Adjust the flex value to control the relative sizes
                        child: Stack(children: <Widget>[
                          TextFormField(
                            controller: _priceController,
                            onChanged: (String val) => price = val,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            maxLength: 15,
                            decoration: inputDecoration.copyWith(
                              hintText: 'Enter Price',
                            ),
                          )
                        ]),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        flex:
                            4, // Adjust the flex value to control the relative sizes
                        child: Stack(
                          children: <Widget>[
                            TextFormField(
                              controller: _discountController,
                              onChanged: (String val) => discount = val,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              decoration: inputDecoration.copyWith(
                                hintText: 'Discount',
                              ),
                            ),
                            const Positioned(
                              right: 10,
                              top: 0,
                              bottom: 25,
                              child: Align(
                                alignment: Alignment
                                    .centerRight, // Vertically centers the text
                                child: Text(
                                  '%',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: DetectableTextField(
                    controller: descriptionController,

                    detectionRegExp: detectionRegExp(hashtag: false)!,
                    onDetectionTyped: (String text) {},
                    onDetectionFinished: () {},
                    keyboardType: TextInputType.multiline,
                    // minLines: 5,
                    maxLength: 300,
                    maxLines: 5,
                    basicStyle: Theme.of(context).textTheme.bodyMedium,
                    onChanged: (String val) => description = val,

                    decoration: inputDecoration.copyWith(
                      hintText: 'Describe your Listing',
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(radiusValue),
                    ),
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                      top: 4,
                      bottom: 5,
                    ),
                    child: DropdownButton<String>(
                      underline: Container(),
                      value: _selectedCategory,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_right),
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
                      ].map<DropdownMenuItem<String>>((String? value) {
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
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: CountryListPick(
                    appBar: AppBar(
                      leading: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
                      ),
                      centerTitle: true,
                      title: const Text(
                        'Select Location',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    initialSelection: _selectedLocation,
                    pickerBuilder:
                        (BuildContext context, CountryCode? countryCode) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(radiusValue),
                        ),
                        child: ListTile(
                          leading: _selectedLocation != null
                              ? Text(_selectedLocation!)
                              : Text(
                                  'Location',
                                  style: bodyText2.copyWith(color: hintColor),
                                ),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        ),
                      );
                    },
                    onChanged: (CountryCode? code) async {
                      setState(() {
                        _selectedLocation = code!.name;
                      });

                      try {
                        SharedPreferences marketplaceCountry =
                            await SharedPreferences.getInstance();
                        await marketplaceCountry.setString(
                            'country', code!.name!);
                        await marketplaceCountry.setString(
                            'currency', code.code!);
                      } catch (e) {}
                    },
                    useSafeArea: false,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                widget.isUpd
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16),
                        child: GestureDetector(
                          onTap: () {
                            if (createMarketController.imageFileList.length <
                                5) {
                              createMarketController.onPickImage();
                            } else {
                              showSnackbar(
                                  message:
                                      'You can only upload up to 5 images.');
                            }
                          },
                          child: FieldContainer(
                            child: Row(
                              children: <Widget>[
                                SvgPicture.asset('assets/svgs/file.svg'),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: Text('Add Attachment',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: hintColor)),
                                ),
                                const SizedBox(width: 16.0),
                                CircleAvatar(
                                  radius: 26 / 1.38,
                                  backgroundColor: backgroundColor,
                                  child: SvgPicture.asset(
                                    'assets/svgs/addimagepost.svg',
                                    height: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: widget.isUpd
                      ? Container()
                      : Preview(controller: createMarketController),
                ),
                widget.isUpd
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 16, right: 16),
                                child: Row(
                                  children: <Widget>[
                                    SvgPicture.asset('assets/svgs/rocket.svg'),
                                    const SizedBox(width: 15),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'Boost this listing?',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            'Reach a wider audience and get more views',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 11,
                                              color: Color(0xFF777777),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Text(
                                          'No',
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Switch(
                                          value: _shouldPromote,
                                          onChanged: (bool value) {
                                            setState(() {
                                              _shouldPromote = value;
                                            });
                                          },
                                        ),
                                        const Text(
                                          'Yes',
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16),
                  child: MCustomButton(
                    onPressed: () async {
                      setState(() {
                        _isProcessing = true;
                      });
                      if (descriptionController.text.isEmpty ||
                          _priceController.text.isEmpty) {
                        showSnackBar(
                          context,
                          message:
                              'Please enter price and description to create a listing',
                        );
                        setState(() {
                          _isProcessing = false;
                        });
                        return;
                      } else {
                        await _onChangeForum();
                      }
                      setState(() {
                        _isProcessing = false;
                      });
                    },
                    label: _isUpdating! ? 'Update' : 'Sell',
                    isProcessing: _isProcessing,
                    buttonType: ButtonType.elevated,
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20.0,
                      right: 20,
                      top: 20,
                      bottom: 50,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text.rich(
                          TextSpan(
                            children: <InlineSpan>[
                              const TextSpan(
                                text:
                                    'By clicking on Sell, you confirm that you will abide by the ',
                                style: TextStyle(
                                    fontSize: 12, color: subtextColor),
                              ),
                              TextSpan(
                                text: 'Marketplace Guidelines',
                                style: const TextStyle(
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                  fontSize: 12,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          sellingGuide(context),
                                    );
                                  },
                              ),
                              const TextSpan(
                                text:
                                    ', and declare that the listing does not include any Prohibited Items',
                                style: TextStyle(
                                    fontSize: 12, color: subtextColor),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _onChangeForum() async {
    if (widget.isUpd == false) {
      await createMarketController.createForum(<String, dynamic>{
        'category': _selectedCategory,
        'location': _selectedLocation,
        'description': description,
        'price': _currencyController.text + price.toString(),
        'discount': discount,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      }, _shouldPromote);
    } else {
      await _marketController.updatePost(<String, dynamic>{
        'marketId': _market?.marketId,
        'category': _selectedCategory,
        'location': _selectedLocation,
        'description': descriptionController.text,
        'price': _currencyController.text + _priceController.text,
        'promote': _market?.promote,
        'approved': _market?.approved,
        'likes': _market?.likes,
        'comments':
            _market?.comments?.map((CommentModel x) => x.toMap()).toList(),
        'coins': _market?.coins,
        'images': _market?.images,
        'userId': _market?.userId,
        'user': _market?.user?.toMap(),
        'discount': _discountController.text,
      });
      await ApiService.put(
          path: 'markets/${_market?.marketId}',
          body: <String, dynamic>{
            'category': _selectedCategory,
            'location': _selectedLocation,
            'description': descriptionController.text,
            'price': _currencyController.text + _priceController.text,
            'discount': _discountController.text,
            'images': _market?.images,
          });
      Get.back();
    }
  }

  Future<void> _onImagePicker() async {
    try {
      PermissionState permissionState =
          await PhotoManager.requestPermissionExtend();

      if (permissionState.isAuth ||
          permissionState == PermissionState.limited) {
        var data = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GalleryPhotosScreen(
              galleryType: GalleryType.images,
              selectedMyAssetEntities: _myAssetsEntities,
            ),
          ),
        );
        if (data == null) return;
        setState(() {
          _myAssetsEntities = data;
          _fileProcessing =
              List.generate(_myAssetsEntities.length, (int index) => false);
        });
      } else if (permissionState == PermissionState.denied) {
        final PermissionState ps = await PhotoManager.requestPermissionExtend();
        if (!ps.isAuth) {
          PhotoManager.openSetting();
        }
      }
    } catch (e) {}
  }

  void _removeImage(int index) {
    List<MyAssetEntity> ae = _myAssetsEntities;

    ae.removeAt(index);
    setState(() {
      _myAssetsEntities = ae;
      _fileProcessing?.removeAt(index);
    });
  }

  Widget _deleteImage(int index) {
    return Positioned(
      right: 5.0,
      top: 5.0,
      child: GestureDetector(
        onTap: _isProcessing ? null : () => _removeImage(index),
        child: Container(
          height: 30.0,
          width: 30.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: const Icon(
            Icons.close,
            size: 18.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
