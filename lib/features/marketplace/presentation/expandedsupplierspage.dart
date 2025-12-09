import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/widgets/network_image_with_placeholder.dart';
import 'package:business_bosses_v2/features/marketplace/models/suppliers_model.dart';
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

class ExpandedSuppliersPage extends StatefulWidget {
  final SuppliersModel supplier;
  final bool isLoading;
  final bool isSearch;
  final Function(UserModel)? onConnectionChange;

  const ExpandedSuppliersPage({
    super.key,
    this.isLoading = false,
    this.isSearch = false,
    this.onConnectionChange,
    required this.supplier,
  });

  @override
  State<ExpandedSuppliersPage> createState() => _FilterUsersState();
}

class _FilterUsersState extends State<ExpandedSuppliersPage> {
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
            if (widget.supplier.isVerified)
              const SizedBox(
                height: 5,
              ),
            if (widget.supplier.isVerified)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(35),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  'Verified',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            const SizedBox(height: 10),
            if (!widget.supplier.isVerified) _buildVerificationWarning(),
            if (!widget.supplier.isVerified)
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      _contactUs();
                    },
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        const Text('Own this business?'),
                        const SizedBox(width: 5),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blue.withAlpha(35),
                              borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle),
                                  padding: const EdgeInsets.all(4),
                                  child: SvgPicture.asset(
                                    'assets/svgs/upicon.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Color.fromARGB(255, 255, 255, 255),
                                        BlendMode.srcIn),
                                    height: 8,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Text(
                                  'Contact us to manage or verify',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
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
        widget.supplier.images!.isEmpty
            ? CircleAvatar(
                backgroundColor: Colors.grey.withValues(alpha: 0.5),
                radius: 64.0,
                child: SvgPicture.asset('assets/svgs/person.svg'),
              )
            : NetworkImageWithPlaceHolder(
                imageUrl: widget.supplier.images![0],
                height: 128.0,
                width: 128.0,
                radius: 64.0,
                cacheHeight: 300,
                cacheWidth: 300,
                placeHolder: Icons.person,
                iconSize: 90,
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildVerificationWarning() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(20),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            'assets/svgs/report.svg',
            colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
            height: 26,
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'This supplier isn\'t verified by Business Bosses; we cannot guarantee a response',
              style: TextStyle(color: Colors.red),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _contactUs() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri mailUrl = Uri(
      scheme: 'mailto',
      path: 'support@businessbosses.co.uk',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Contact Business Bosses',
      }),
    );

    try {
      if (await canLaunchUrl(mailUrl)) {
        await launchUrl(mailUrl);
      } else {
        throw 'Could not launch $mailUrl';
      }
    } catch (e) {
      showSnackbar(
          title: 'OOPS!',
          message: 'An error occurred, please try again!',
          error: true);
    }
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
              'https://${widget.supplier.url}',
              12, () async {
            await Clipboard.setData(
              ClipboardData(text: widget.supplier.url!),
            );

            // Show toast
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(content: Text('Website Url copied to clipboard')),
            );

            _launchURL(widget.supplier.url!);
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
              ClipboardData(text: widget.supplier.email!),
            );

            // Show toast
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(content: Text('Email copied to clipboard')),
            );

            _launchURL('mailto:${widget.supplier.email}');
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
            ScaffoldMessenger.of(Get.context!).showSnackBar(
              const SnackBar(content: Text('Phone copied to clipboard')),
            );

            _launchURL('tel:${widget.supplier.phone}');
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
                ClipboardData(text: widget.supplier.location!),
              );

              // Show toast
              ScaffoldMessenger.of(Get.context!).showSnackBar(
                const SnackBar(content: Text('Location copied to clipboard')),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildContactRow(String iconPath, String label, String? value,
      String url, double height, Function()? ontap) {
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
          onTap: ontap,
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
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              } else if (text.startsWith('wa.me')) {
                final Uri whatsappUrl = Uri.parse('https://$text');
                if (await launchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl);
                } else {
                  throw Exception('Could not launch $whatsappUrl');
                }
              }
            },
          ),
          const SizedBox(height: 20),
          if (widget.supplier.images != null &&
              widget.supplier.images!.isNotEmpty)
            _buildImageGallery(),
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    // Ensure the URL has a valid scheme
    if (!urlString.startsWith(RegExp(r'^(http|https|tel|mailto):'))) {
      urlString = 'https://$urlString';
    }

    final Uri url = Uri.parse(urlString);

    if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
      throw Exception('Could not launch $urlString');
    }
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.supplier.images!.length,
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
                imageUrl: widget.supplier.images![i],
                width: 200,
                height: 200,
                placeHolder: Icons.photo,
                iconSize: 18.0,
                radius: 10.0,
              ),
            ),
          );
        },
      ),
    );
  }
}
