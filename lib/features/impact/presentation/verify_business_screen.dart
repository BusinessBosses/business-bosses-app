import 'dart:io';

import 'package:business_bosses_v2/bbpro/presentation/setup_shop.dart';
import 'package:business_bosses_v2/bbpro/widgets/button.dart';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/theme/theme.dart';
import '../../forum/widgets/field_container.dart';
import 'package:business_bosses_v2/bbpro/controllers/shop_controller.dart';
import 'package:business_bosses_v2/bbpro/models/shop_model.dart';
import 'package:get/get.dart';

class VerifyBusinessScreen extends StatefulWidget {
  const VerifyBusinessScreen({super.key});

  @override
  VerifyBusinessScreenState createState() => VerifyBusinessScreenState();
}

class VerifyBusinessScreenState extends State<VerifyBusinessScreen> {
  final ShopController shopController = Get.find();
  final ProfileController profileController = Get.find();

  final List<XFile> _keyIndividualDocs = <XFile>[];
  final List<XFile> _businessRegDocs = <XFile>[];
  final List<XFile> _proofOfAddressDocs = <XFile>[];

  final List<String> _keyIndividualDocUrls = <String>[];
  final List<String> _businessRegDocUrls = <String>[];
  final List<String> _proofOfAddressDocUrls = <String>[];

  bool _isProcessing = false;
  bool _isLoadingShop = true;

  bool get _hasAnyDocuments =>
      _keyIndividualDocUrls.isNotEmpty ||
      _businessRegDocUrls.isNotEmpty ||
      _proofOfAddressDocUrls.isNotEmpty;

  bool get _isPending =>
      shopController.shop?.verificationStatus == 'pending' && _hasAnyDocuments;

  bool get _isVerified => shopController.shop?.verificationStatus == 'approved';

  bool get _isRejected => shopController.shop?.verificationStatus == 'rejected';

  bool get _canEdit => _isRejected || !_hasAnyDocuments;

  bool get _canSubmit => _canEdit && !_isProcessing;

  @override
  void initState() {
    super.initState();
    if (profileController.myProfile.hasShop) {
      _fetchShopDetails();
    } else {
      Get.off(() => const Setupshop());
    }
  }

  Future<void> _fetchShopDetails() async {
    if (shopController.shop == null) {
      await shopController.initShop();
    }

    final Shop? shop = shopController.shop;
    if (shop != null) {
      _keyIndividualDocUrls
        ..clear()
        ..addAll(List<String>.from(shop.keyIndividualDocs));

      _businessRegDocUrls
        ..clear()
        ..addAll(List<String>.from(shop.businessRegDocs));

      _proofOfAddressDocUrls
        ..clear()
        ..addAll(List<String>.from(shop.proofOfAddressDocs));
    }

    setState(() => _isLoadingShop = false);
  }

  Future<bool> _uploadFiles({
    required List<XFile> files,
    required List<String> targetUrls,
    required String errorLabel,
  }) async {
    for (final XFile file in files) {
      final dynamic response = await ApiService.uploadFile(File(file.path));
      if (response == null || response['success'] != true) {
        showSnackbar(
          title: 'Upload Failed',
          message: 'Failed to upload $errorLabel document',
          error: true,
        );
        return false;
      }
      targetUrls.add(response['fileUrl']);
    }
    return true;
  }

  Map<String, dynamic> _buildUpdatePayload() {
    return <String, dynamic>{
      'keyIndividualDocs': _keyIndividualDocUrls,
      'businessRegDocs': _businessRegDocUrls,
      'proofOfAddressDocs': _proofOfAddressDocUrls,
      'verificationStatus': 'pending',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingShop) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: backgroundcolorinterface,
      appBar: AppBar(
        title: const Text('Verify Business'),
        automaticallyImplyActions: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (shopController.shop != null)
              _buildShopInfoCard(shopController.shop!),
            if (_isPending || _isVerified || _isRejected) _buildStatusBanner(),
            _buildSection(
              'Key Individuals',
              'Directors/Signatories - Government-issued photo ID.',
              _keyIndividualDocs,
              _keyIndividualDocUrls,
            ),
            _buildSection(
              'Business Registration',
              'Certificate of Incorporation or Business License',
              _businessRegDocs,
              _businessRegDocUrls,
            ),
            _buildSection(
              'Proof of Address',
              'Utility bill or bank statement',
              _proofOfAddressDocs,
              _proofOfAddressDocUrls,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: ProCustomButton(
                  loading: _isProcessing,
                  text: _isVerified
                      ? 'Verified'
                      : _isPending
                          ? 'Verification Pending'
                          : 'Submit Verification',
                  onPressed: _canSubmit ? _submitVerification : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    Color color;
    String text;
    IconData icon;

    if (_isVerified) {
      color = Colors.green;
      text = 'Your business has been verified.';
      icon = Icons.verified;
    } else if (_isRejected) {
      color = Colors.red;
      text = 'Verification rejected. Please update documents and resubmit.';
      icon = Icons.error;
    } else {
      color = Colors.orange;
      text = 'Verification pending. You cannot submit again.';
      icon = Icons.hourglass_top;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildSection(
    String title,
    String subtitle,
    List<XFile> files,
    List<String> urls,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        if (_canEdit)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GestureDetector(
              onTap: () => _pickFiles(files),
              child: FieldContainer(
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/svgs/file.svg'),
                    const SizedBox(width: 16),
                    Expanded(child: Text('Upload $title')),
                    const Icon(Icons.add),
                  ],
                ),
              ),
            ),
          ),
        if (urls.isNotEmpty || files.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                ...urls.map(
                  (String url) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(url,
                        width: 100, height: 100, fit: BoxFit.cover),
                  ),
                ),
                ...files.map((XFile file) {
                  final int index = files.indexOf(file);
                  return Stack(
                    children: <Widget>[
                      Image.file(File(file.path),
                          width: 100, height: 100, fit: BoxFit.cover),
                      if (_canEdit)
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                files.removeAt(index);
                              });
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _pickFiles(List<XFile> list) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() => list.addAll(images));
    }
  }

  Future<void> _submitVerification() async {
    if (_keyIndividualDocs.isEmpty && _keyIndividualDocUrls.isEmpty) {
      showSnackbar(
        title: 'Error',
        message: 'Documents are required',
        error: true,
      );
      return;
    }

    setState(() => _isProcessing = true);

    if (!await _uploadFiles(
        files: _keyIndividualDocs,
        targetUrls: _keyIndividualDocUrls,
        errorLabel: 'Key Individual')) {
      return _stop();
    }

    if (!await _uploadFiles(
        files: _businessRegDocs,
        targetUrls: _businessRegDocUrls,
        errorLabel: 'Business Registration')) {
      return _stop();
    }

    if (!await _uploadFiles(
        files: _proofOfAddressDocs,
        targetUrls: _proofOfAddressDocUrls,
        errorLabel: 'Proof of Address')) {
      return _stop();
    }

    await shopController.updateShop(
      shopController.shop!.id,
      _buildUpdatePayload(),
    );

    _stop();
  }

  void _stop() {
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  Widget _buildShopInfoCard(Shop shop) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(shop.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
