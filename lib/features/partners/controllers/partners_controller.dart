import 'dart:io';
import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/partners/models/partner_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:flutter/foundation.dart';

class PartnerController extends GetxController {
  final ProfileController profileController = Get.find();

  final RxBool isLoading = false.obs;
  final Rx<ApiResponseModel?> lastResult = Rx<ApiResponseModel?>(null);
  final RxString lastError = ''.obs;
  final RxList<Partner> partners = <Partner>[].obs;
  final RxList<Partner> myPartners = <Partner>[].obs;
  final RxBool loading = false.obs;
  final RxString selectedCategory = 'All'.obs;

  final String createPath = 'partner';

  /// ✅ Create or update a partner entry
  Future<ApiResponseModel> submitPartner({
    required String companyName,
    required String companyEmail,
    String? companyPhone,
    required String partnershipType,
    required String category,
    String? location,
    String? companyUrl,
    String? companyDescription,
    PlatformFile? image,
    String? userId,
  }) async {
    isLoading.value = true;
    lastError.value = '';
    lastResult.value = null;

    try {
      // ✅ Require image before anything else
      if (image == null) {
        showSnackbar(
          title: 'Missing Image',
          message: 'Please upload a company image or logo before submitting.',
          error: true,
        );
        return ApiResponseModel(
          success: false,
          message: 'Image is required',
          data: <dynamic, dynamic>{},
        );
      }
      final String resolvedUserId = userId ?? profileController.myProfile.uid;

      if (resolvedUserId.isEmpty) {
        const String msg = 'User ID not available. Please log in again.';
        showSnackbar(title: 'Error', message: msg, error: true);
        return ApiResponseModel(
            success: false, message: msg, data: <dynamic, dynamic>{});
      }

      // ✅ Upload image if provided
      final String? uploadedImageUrl = await _uploadImage(image);

      // ✅ Build body (mirroring backend fields)
      final Map<String, dynamic> body = <String, dynamic>{
        'companyName': companyName,
        'companyEmail': companyEmail,
        'partnershipType': partnershipType,
        'category': category,
        'userId': resolvedUserId, // 🔄 use camelCase for consistency
        if (companyPhone?.isNotEmpty ?? false) 'companyPhone': companyPhone,
        if (location?.isNotEmpty ?? false) 'location': location,
        if (companyUrl?.isNotEmpty ?? false) 'companyUrl': companyUrl,
        if (companyDescription?.isNotEmpty ?? false)
          'companyDescription': companyDescription,
        if (uploadedImageUrl?.isNotEmpty ?? false)
          'companyPhoto': uploadedImageUrl,
      };

      // ✅ Submit request
      final ApiResponseModel resp =
          await ApiService.post(path: createPath, body: body);
      lastResult.value = resp;

      if (resp.success && resp.data != null) {
        final Partner newPartner = Partner.fromJson(resp.data);
        myPartners.insert(0, newPartner);
      }

      return resp;
    } catch (e, stack) {
      lastError.value = e.toString();
      debugPrint('❌ Partner submission failed: $e\n$stack');
      showSnackbar(title: 'Exception', message: e.toString(), error: true);
      return ApiResponseModel(
          success: false, message: e.toString(), data: <dynamic, dynamic>{});
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Image upload helper
  Future<String?> _uploadImage(PlatformFile? image) async {
    if (image == null) return null;
    try {
      File file;
      if (image.path != null && image.path!.isNotEmpty) {
        file = File(image.path!);
      } else if (image.bytes != null) {
        final TempFile tempFile =
            await _writeBytesToTempFile(image.name, image.bytes!);
        file = tempFile.file;
      } else {
        throw Exception('Invalid image file');
      }

      final dynamic uploadResult = await ApiService.uploadFile(file);
      if (uploadResult is Map && uploadResult['success'] == true) {
        return uploadResult['fileUrl']?.toString();
      } else {
        throw Exception('Upload failed');
      }
    } catch (e) {
      debugPrint('❌ Image upload error: $e');
      showSnackbar(title: 'Upload failed', message: e.toString(), error: true);
      return null;
    }
  }

  Future<TempFile> _writeBytesToTempFile(
      String filename, List<int> bytes) async {
    final Directory tempDir = Directory.systemTemp;
    final File tempFile = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_$filename');
    await tempFile.writeAsBytes(bytes);
    return TempFile(tempFile);
  }

  /// ✅ Load approved partners
  Future<void> loadPartners() async {
    try {
      loading.value = true;
      partners.clear();

      final ApiResponseModel response = await HomeRepository.fetchPartner();

      if (!response.success) {
        showSnackbar(title: 'Error', message: response.message, error: true);
        return;
      }

      final dynamic data = response.data;
      final List<dynamic>? rows = (data is Map) ? data['rows'] : data;

      if (rows == null || rows.isEmpty) {
        loadMyPartners(); // still try to load my own
        return;
      }

      final List<Partner> allLoaded = rows
          .map((dynamic e) => Partner.fromJson(e))
          .where((Partner p) => p.id != 5)
          .toList();

      // Approved partners for the public marketplace view
      partners.assignAll(allLoaded.where((Partner p) => p.approved).toList());

      // Try to find my deals in the global list first
      final List<Partner> myDeals = allLoaded
          .where((Partner p) => p.userId == profileController.myProfile.uid)
          .toList();

      if (myDeals.isNotEmpty) {
        myPartners.assignAll(myDeals);
      } else {
        loadMyPartners();
      }
    } catch (e, stack) {
      debugPrint('❌ loadPartners failed: $e\n$stack');
      showSnackbar(
          title: 'Error', message: 'Failed to load partners', error: true);
    } finally {
      loading.value = false;
    }
  }

  Future<void> loadMyPartners() async {
    try {
      final ApiResponseModel response = await ApiService.get(
          path: 'partner/user/${profileController.myProfile.uid}');
      if (response.success) {
        final List<dynamic> rows = response.data;
        myPartners.assignAll(
            rows.map((dynamic e) => Partner.fromJson(e)).toList());
      }
    } catch (e) {
      debugPrint('❌ loadMyPartners failed: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadPartners();
  }
}

class TempFile {
  final File file;
  TempFile(this.file);
}
