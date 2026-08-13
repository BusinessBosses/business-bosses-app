import 'package:business_bosses_v2/bbpro/models/supplier_model.dart';
import 'package:business_bosses_v2/utils/safe_url_launcher.dart';
import 'package:business_bosses_v2/bbpro/presentation/add_supplier.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/posts/widgets/images_viewer_screen.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/models/user_model.dart';
import '../../../utils/theme/theme.dart';

class ExpandedProSuppliersPage extends StatefulWidget {
  final Vendor supplier;
  final bool isLoading;
  final bool isSearch;
  final Function(UserModel)? onConnectionChange;

  const ExpandedProSuppliersPage({
    super.key,
    this.isLoading = false,
    this.isSearch = false,
    this.onConnectionChange,
    required this.supplier,
  });

  @override
  State<ExpandedProSuppliersPage> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<ExpandedProSuppliersPage> {
  final bool loadingNext = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset('assets/svgs/backbutton.svg'),
        ),
        centerTitle: true,
        title: const Text(
          'About Supplier',
        ),
        // ignore: prefer_const_literals_to_create_immutables
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Get.to(() => const AddSupplier());
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child: CircleAvatar(
                  backgroundColor: prosemibackColor,
                  child: Icon(
                    Icons.edit,
                    color: Colors.black,
                  )),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildSupplierImage(),
            Text(
              widget.supplier.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: textColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactInfo(),
            const SizedBox(height: 20),
            _buildDescription(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplierImage() {
    return Column(
      children: <Widget>[
        widget.supplier.images.isEmpty
            ? CircleAvatar(
                backgroundColor: Colors.grey.withValues(alpha: 0.5),
                radius: 64.0,
                child: SvgPicture.asset('assets/svgs/person.svg'),
              )
            : NetworkImageWithPlaceHolder(
                imageUrl: widget.supplier.images[0],
                height: 128.0,
                width: 128.0,
                radius: 64.0,
                cacheHeight: 300,
                cacheWidth: 300,
                placeHolder: Icons.person,
                iconSize: 60,
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Future<void> _contactUs() async {
  //   String? encodeQueryParameters(Map<String, String> params) {
  //     return params.entries
  //         .map((MapEntry<String, String> e) =>
  //             '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
  //         .join('&');
  //   }

  //   final Uri mailUrl = Uri(
  //     scheme: 'mailto',
  //     path: 'support@businessbosses.co.uk',
  //     query: encodeQueryParameters(<String, String>{
  //       'subject': 'Contact Business Bosses',
  //     }),
  //   );

  //   try {
  //     if (await canLaunchUrl(mailUrl)) {
  //       await openUrl(mailUrl);
  //     } else {
  //       throw 'Could not launch $mailUrl';
  //     }
  //   } catch (e) {
  //     showSnackbar(
  //         title: 'OOPS!',
  //         message: 'An error occurred, please try again!',
  //         error: true);
  //   }
  // }

  Future<void> _launchURL(String urlString) async {
    // Ensure the URL has a valid scheme
    if (!urlString.startsWith(RegExp(r'^(http|https|tel|mailto):'))) {
      urlString = 'https://$urlString';
    }

    final Uri url = Uri.parse(urlString);

    await openUrl(url, mode: LaunchMode.platformDefault);
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Contact Information',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          _buildContactRow(
              'assets/svgs/website.svg',
              'Website',
              widget.supplier.url,
              widget.supplier.url.startsWith('http://') ||
                      widget.supplier.url.startsWith('https://')
                  ? widget.supplier.url
                  : 'https://${widget.supplier.url}',
              12, () async {
            await Clipboard.setData(
              ClipboardData(text: widget.supplier.url),
            );

            // Show toast
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Website Url copied to clipboard')),
            );

            // Open URL
            _launchURL(widget.supplier.url);
          }),
          _buildDivider(),
          const SizedBox(height: 10),
          _buildContactRow(
              'assets/svgs/email.svg',
              'Email',
              widget.supplier.email,
              'mailto:${widget.supplier.email}',
              9, () async {
            await Clipboard.setData(
              ClipboardData(text: widget.supplier.email),
            );

            // Show toast
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email copied to clipboard')),
            );

            // Open Email
            await _launchURL('mailto:${widget.supplier.email}');
          }),
          _buildDivider(),
          const SizedBox(height: 10),
          _buildContactRow(
              'assets/svgs/phone.svg',
              'Phone',
              widget.supplier.phone,
              'tel:${widget.supplier.phone}',
              11, () async {
            await Clipboard.setData(
              ClipboardData(text: widget.supplier.phone),
            );

            // Show toast
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Phone copied to clipboard')),
            );

            // Open Phone Dialer
            await _launchURL('tel:${widget.supplier.phone}');
          }),
          _buildDivider(),
          const SizedBox(height: 10),
          _buildContactRow(
            'assets/svgs/locationicon.svg',
            'Location',
            widget.supplier.location,
            '',
            13,
            () async {
              // Copy to clipboard
              await Clipboard.setData(
                ClipboardData(text: widget.supplier.location),
              );

              // Show toast
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Location copied to clipboard')),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildContactRow(String iconPath, String label, String? value,
      String url, double height, Function()? onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            SvgPicture.asset(
              iconPath,
              height: height,
            ),
            const SizedBox(width: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,

          //  () async {
          //   if (url.isNotEmpty && await canLaunch(url)) {
          //     await launch(url);
          //   }

          child: Text(
            value!,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: textColor.withAlpha(200),
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(color: Colors.black12, height: 0.5);
  }

  Widget _buildDescription() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Description',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 20),
          Text('Category - ${widget.supplier.category}'),
          const SizedBox(height: 20),
          DetectableText(
            text: widget.supplier.description,
            detectionRegExp: detectionRegExp(hashtag: false)!,
            detectedStyle: bodyText2.copyWith(color: Colors.blue),
            moreStyle: bodyText2.copyWith(color: Colors.redAccent),
            lessStyle: bodyText2.copyWith(color: Colors.redAccent),
            trimLength: 10000,
            basicStyle: bodyText2.copyWith(color: textColor),
            onTap: (String text) async {
              final Uri url = Uri.parse(text);
              if ((url.scheme == 'http' || url.scheme == 'https')) {
                await openUrl(url);
              } else if (text.startsWith('wa.me')) {
                final Uri whatsappUrl = Uri.parse('https://$text');
                // openUrl reports its own failure. This used to open
                // WhatsApp twice, then throw out of an onTap handler.
                await openUrl(whatsappUrl);
              }
            },
          ),
          const SizedBox(height: 20),
          if (widget.supplier.images.isNotEmpty) _buildImageGallery(),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.supplier.images.length,
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            onTap: () => Get.to(
              () => ImagesViewerScreen(
                urls: widget.supplier.images,
                text: widget.supplier.description,
                index: i,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 10.0, right: 10),
              child: NetworkImageWithPlaceHolder(
                imageUrl: widget.supplier.images[i],
                width: 200,
                height: 200,
                placeHolder: Icons.photo,
                iconSize: 60.0,
                radius: 10.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
