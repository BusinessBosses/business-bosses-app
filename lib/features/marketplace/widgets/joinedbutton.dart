// import 'package:business_bosses_v2/common/models/user_model.dart';
// import 'package:business_bosses_v2/common/widgets/buttons/my_outlined_button.dart';
// import 'package:business_bosses_v2/features/forum/models/industry.dart';
// import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
// import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
// import 'package:business_bosses_v2/services/api_service.dart';
// import 'package:business_bosses_v2/utils/constants/constants.dart';
// import 'package:business_bosses_v2/utils/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class JoinedButton extends StatefulWidget {
//   const JoinedButton({super.key});

//   @override
//   _JoinedButtonState createState() => _JoinedButtonState();
// }

// class _JoinedButtonState extends State<JoinedButton> {
//   final ProfileController _profileController = Get.find();
//   final MarketController _marketController = Get.find();
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () async {
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         final String? userId = prefs.getString(Constants.USER_ID);

//         setState(() {
//           if (_marketController.isJoined.value) {
//             _marketController.users.removeWhere((UserModel user) => user.uid == userId);
//           } else {
//             _marketController.users.add(_profileController.myProfile);
//           }
//           _marketController.isJoined.value = !_marketController.isJoined.value;
//         });

//         final Map<String, dynamic> marketData = <String, dynamic>{
//           'industryId': 'market_place_id',
//           'categoryId': Constants.MARKET_PLACE_CATEGORY_ID,
//           'description': '- Sell your products and services \n - Find Supplies',
//           'industry': 'Market Place',
//           'photo':
//               'https://businessbosses.com.ng/learningImages/marketplace.jpg',
//           'active': true,
//           'timestamp': DateTime.now().millisecondsSinceEpoch
//         };

//         _profileController.toggleInterests(Industry.toObject(marketData));
//         await ApiService.post(path: 'members', body: <String, dynamic>{
//           'type': 'marketplace',
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12.0),
//         alignment: Alignment.center,
//         child: SizedBox(
//           height: 38,
//           width: 75,
//           child: Obx(
//             () => !_marketController.isJoined.value
//                 ? const MCustomButton(
//                     child: Text(
//                       'Join',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: primaryColorLT,
//                       ),
//                     ),
//                   )
//                 : const MCustomButton(
//                     buttonType: ButtonType.outlinegrey,
//                     child: Text(
//                       'Leave',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: Color(0xFF777777),
//                       ),
//                     ),
//                   ),
//           ),
//         ),
//       ),
//     );
//   }
// }
