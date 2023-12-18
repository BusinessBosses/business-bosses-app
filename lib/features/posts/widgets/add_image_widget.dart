// // // ignore_for_file: public_member_api_docs

// // import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
// // import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
// // import 'package:business_bosses_v2/utils/theme/theme.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/svg.dart';

// // import '../../../common/dialogs/snackbar.dart';
// // import '../../../common/widgets/gallery_screen.dart';

// // class AddImageWidget extends StatefulWidget {
// //   const AddImageWidget(
// //       {Key? key, required this.controller, this.isUpdating = false})
// //       : super(key: key);
// //   final CreatePostController controller;
// //   final bool isUpdating;

// //   @override
// //   State<AddImageWidget> createState() => _AddImageWidgetState();
// // }

// // class _AddImageWidgetState extends State<AddImageWidget> {
// //   // List<MyAssetEntity> _myAssetsEntities = [];
// //   // List<bool> _fileProcessing = [];
// //   @override
// //   Widget build(BuildContext context) {
// //     return widget.controller.vidThumbnail == null
// //         ? Padding(
// //             padding: const EdgeInsets.only(left: 20, right: 20),
// //             child: Row(
// //               children: <Widget>[
// //                 const TextWidget(
// //                   text: 'Add image',
// //                   fontWeight: FontWeight.w700,
// //                   size: 17,
// //                 ),
// //                 const SizedBox(
// //                   width: 10,
// //                 ),
// //                 GestureDetector(
// //                   onTap: () {
// //                     if (widget.controller.imageFileList.length < 5) {
// //                       widget.controller.onPickImage(GalleryType.images,
// //                           isUpdating: widget.isUpdating);
// //                     } else {
// //                       showSnackbar(
// //                           message: 'You can only upload up to 5 images.');
// //                     }
// //                   },
// //                   child: CircleAvatar(
// //                     radius: 26 / 1.38,
// //                     backgroundColor: backgroundColor,
// //                     child: SvgPicture.asset(
// //                       'assets/svgs/addimagepost.svg',
// //                       height: 18,
// //                     ),
// //                   ),
// //                 ),
// //                 if (widget.controller.myAssetsEntities.isEmpty)
// //                   GestureDetector(
// //                     onTap: () {
// //                       widget.controller.onPickImage(GalleryType.videos);
// //                     },
// //                     child: CircleAvatar(
// //                         radius: 26 / 1.38,
// //                         backgroundColor:
// //                             const Color(0xff00CD98).withOpacity(0.2),
// //                         child: SvgPicture.asset(
// //                           'assets/svgs/addvideopost.svg',
// //                           height: 18,
// //                         )),
// //                   ),
// //                 const Spacer(),
// //                 const Text(
// //                   'Max file size for images is 10Mb',
// //                   style: TextStyle(fontSize: 11, color: Colors.red),
// //                 ),
// //               ],
// //             ),
// //           )
// //         : Padding(
// //             padding: const EdgeInsets.only(left: 15, right: 15),
// //             child: Stack(
// //               children: [
// //                 SizedBox(
// //                   width: 100,
// //                   height: 100,
// //                   child: ClipRRect(
// //                     borderRadius: BorderRadius.circular(10.0),
// //                     child: Image.file(
// //                       widget.controller.vidThumbnail!,
// //                       fit: BoxFit.fill,
// //                     ),
// //                   ),
// //                 ),
// //                 Positioned(
// //                   top: 35,
// //                   right: 35,
// //                   bottom: 35,
// //                   left: 35,
// //                   child: SvgPicture.asset(
// //                     'assets/svgs/play.svg',
// //                     height: 20,
// //                     color: Colors.black,
// //                   ),
// //                 ),
// //                 Positioned(
// //                   right: 5.0,
// //                   top: 5.0,
// //                   child: GestureDetector(
// //                     onTap: () {
// //                       setState(() {
// //                         widget.controller.vidThumbnail = null;
// //                         widget.controller.selectedVid = null;
// //                       });
// //                     },
// //                     child: Container(
// //                         height: 30.0,
// //                         width: 30.0,
// //                         alignment: Alignment.center,
// //                         decoration: BoxDecoration(
// //                           color: Colors.black54,
// //                           borderRadius: BorderRadius.circular(40.0),
// //                         ),
// //                         child: const Icon(
// //                           Icons.close,
// //                           size: 18.0,
// //                           color: Colors.white,
// //                         )),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           );
// //   }
// // }
// // ignore_for_file: public_member_api_docs

// import 'package:business_bosses_v2/common/widgets/gallery_screen.dart';
// import 'package:business_bosses_v2/common/widgets/typography/text_widget.dart';
// import 'package:business_bosses_v2/features/posts/controllers/create_post_controller.dart';
// import 'package:business_bosses_v2/utils/theme/theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../common/dialogs/snackbar.dart';

// class AddImageWidget extends StatelessWidget {
//   const AddImageWidget(
//       {Key? key, required this.controller, this.isUpdating = false})
//       : super(key: key);
//   final CreatePostController controller;


//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, right: 20),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                   decoration: BoxDecoration(
//                       color: backgroundColor,
//                       borderRadius: BorderRadius.circular(50)),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                     child: GestureDetector(
//                       onTap: () {
//                         if (controller.imageFileList.length < 5) {
//                           controller.onPickImage(GalleryType.images,
//                               isUpdating: isUpdating);
//                         } else {
//                           showSnackbar(
//                               message: 'You can only upload up to 5 images.');
//                         }
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           const TextWidget(
//                             text: 'Add image',
//                             fontWeight: FontWeight.w700,
//                             size: 15,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           SvgPicture.asset(
//                             'assets/svgs/addimagepost.svg',
//                             height: 15,
//                           ),

//                           // const Text(
//                           //   'Max file size for images is 10Mb',
//                           //   style: TextStyle(fontSize: 11, color: Colors.red),
//                           // )
//                         ],
//                       ),
//                     ),
//                   )),
//               const SizedBox(
//                 width: 5,
//               ),
//               Container(
//                   decoration: BoxDecoration(
//                       color: backgroundColor,
//                       borderRadius: BorderRadius.circular(50)),
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                     child: GestureDetector(
//                       onTap: () {
//                         if (controller.imageFileList.length < 5) {
//                           controller.onPickImage(GalleryType.images,
//                               isUpdating: isUpdating);
//                         } else {
//                           showSnackbar(
//                               message: 'You can only upload up to 5 images.');
//                         }
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           const TextWidget(
//                             text: 'Add Youtube link',
//                             fontWeight: FontWeight.w700,
//                             size: 15,
//                           ),
//                           const SizedBox(
//                             width: 5,
//                           ),
//                           SvgPicture.asset(
//                             'assets/svgs/addimagepost.svg',
//                             height: 15,
//                           ),

//                           // const Text(
//                           //   'Max file size for images is 10Mb',
//                           //   style: TextStyle(fontSize: 11, color: Colors.red),
//                           // )
//                         ],
//                       ),
//                     ),
//                   )),
//             ],
//           ),

//           Container(
//                             decoration: const BoxDecoration(
//                               color: backgroundColor,
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(15),
//                               ),
//                             ),
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: TextFormField(
//                                       onChanged: (String val) {
//                                         _ytUrl = val;
//                                         setState(() {});
//                                       },
//                                       // validator: (value) {
//                                       //   if (value == null || value.isEmpty) {
//                                       //     return '';
//                                       //   }
//                                       //   return null;
//                                       // },
//                                       // textInputAction: TextInputAction.done,
//                                       keyboardType:
//                                           TextInputType.visiblePassword,
//                                       maxLines: 2,
//                                       decoration: InputDecoration(
//                                         hintText:
//                                             'Paste a Youtube Video link here',
//                                         border: InputBorder.none,
//                                         hintStyle: Theme.of(context)
//                                             .textTheme
//                                             .bodyMedium!
//                                             .copyWith(
//                                               color: textColor.withOpacity(0.2),
//                                             ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
          
//         ],
//       ),
//     );
//   }
// }
