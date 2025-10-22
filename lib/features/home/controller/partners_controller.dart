import 'dart:io';
import 'dart:convert';

import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';

class PartnerController extends GetxController {
  final ProfileController profileController = Get.find();

  final RxBool isLoading = false.obs;
  final Rx<ApiResponseModel?> lastResult = Rx<ApiResponseModel?>(null);
  final RxString lastError = ''.obs;

  // path used by ApiService.post (ApiService.post uses '${Constants.baseUrl}/$path')
  final String createPath = 'partner'; // change if your endpoint differs

  /// Submit partner details: uploads a single image (if provided) and posts the payload.
  Future<ApiResponseModel> submitPartner({
    required String companyName,
    required String companyEmail,
    String? companyPhone,
    required String partnershipType,
    required String category,
    String? location,
    String? companyUrl,
    String? companyDescription,
    PlatformFile? image, // single image only
    String? userId,
  }) async {
    isLoading.value = true;
    lastError.value = '';
    lastResult.value = null;

    try {
      final String resolvedUserId = profileController.myProfile.uid;

      if (resolvedUserId.isEmpty) {
        final String msg =
            'User id not available. Provide userId param or ensure ShopController has shop.uid.';
        lastError.value = msg;
        isLoading.value = false;
        Get.snackbar('Error', msg);
        return ApiResponseModel(
            success: false, message: msg, data: <dynamic, dynamic>{});
      }

      // 1) Upload the single image (if provided) using ApiService.uploadFile
      String? uploadedImageUrl;
      if (image != null) {
        try {
          if (image.path != null && image.path!.isNotEmpty) {
            final File file = File(image.path!);
            final dynamic uploadResult = await ApiService.uploadFile(file);
            if (uploadResult != null &&
                uploadResult is Map &&
                uploadResult['success'] == true) {
              // pick likely keys for returned URL (adjust if your upload.php returns a different key)
              final String? url = (uploadResult['fileUrl'])?.toString();
              if (url != null && url.isNotEmpty) {
                uploadedImageUrl = url;
              } else {
                // fallback: stringify result
                uploadedImageUrl = jsonEncode(uploadResult);
              }
            } else {
              final String errMsg = 'Image upload failed';
              lastError.value = errMsg;
              Get.snackbar('Upload failed', errMsg);
              // abort since image upload failed (you can change to continue behavior if you prefer)
              isLoading.value = false;
              return ApiResponseModel(
                  success: false, message: errMsg, data: <dynamic, dynamic>{});
            }
          } else if (image.bytes != null) {
            // write bytes to temp file and upload
            final TempFile tempFile =
                await _writeBytesToTempFile(image.name, image.bytes!);
            final dynamic uploadResult =
                await ApiService.uploadFile(tempFile.file);
            try {
              await tempFile.file.delete();
            } catch (_) {}
            if (uploadResult != null &&
                uploadResult is Map &&
                uploadResult['success'] == true) {
              final String? url = (uploadResult['url'] ??
                      uploadResult['file'] ??
                      uploadResult['filepath'] ??
                      uploadResult['path'] ??
                      uploadResult['data'] ??
                      uploadResult['file_url'])
                  ?.toString();
              if (url != null && url.isNotEmpty) {
                uploadedImageUrl = url;
              } else {
                uploadedImageUrl = jsonEncode(uploadResult);
              }
            } else {
              final String errMsg = 'Image upload failed';
              lastError.value = errMsg;
              Get.snackbar('Upload failed', errMsg);
              isLoading.value = false;
              return ApiResponseModel(
                  success: false, message: errMsg, data: <dynamic, dynamic>{});
            }
          } else {
            final String errMsg = 'Image has no path or bytes';
            lastError.value = errMsg;
            Get.snackbar('Upload failed', errMsg);
            isLoading.value = false;
            return ApiResponseModel(
                success: false, message: errMsg, data: <dynamic, dynamic>{});
          }
        } catch (e) {
          lastError.value = 'Image upload exception: $e';
          Get.snackbar('Upload exception', lastError.value);
          isLoading.value = false;
          return ApiResponseModel(
              success: false,
              message: lastError.value,
              data: <dynamic, dynamic>{});
        }
      }

      // 2) Build body
      final Map<String, dynamic> body = <String, dynamic>{
        'companyName': companyName,
        'companyEmail': companyEmail,
        'partnershipType': partnershipType,
        'category': category,
        'userId': resolvedUserId,
      };

      if (companyPhone != null && companyPhone.isNotEmpty) {
        body['companyPhone'] = companyPhone;
      }
      if (location != null && location.isNotEmpty) body['location'] = location;
      if (companyUrl != null && companyUrl.isNotEmpty) {
        body['companyUrl'] = companyUrl;
      }
      if (companyDescription != null && companyDescription.isNotEmpty) {
        body['companyDescription'] = companyDescription;
      }
      if (uploadedImageUrl != null && uploadedImageUrl.isNotEmpty) {
        body['companyPhoto'] = uploadedImageUrl;
      }

      // 3) Post using ApiService.post
      final ApiResponseModel resp =
          await ApiService.post(path: createPath, body: body);

      lastResult.value = resp;
      isLoading.value = false;

      if (resp.success) {
        Get.snackbar('Success', 'Partner sent for moderation by admin!');
        Get.back();
        Get.back();
      } else {
        Get.snackbar('Error', resp.message);
        lastError.value = resp.message;
      }

      return resp;
    } catch (e) {
      lastError.value = e.toString();
      isLoading.value = false;
      Get.snackbar('Exception', lastError.value);
      return ApiResponseModel(
          success: false, message: lastError.value, data: <dynamic, dynamic>{});
    } finally {
      isLoading.value = false;
    }
  }

  // helper to write bytes to temp file when necessary
  Future<TempFile> _writeBytesToTempFile(
      String filename, List<int> bytes) async {
    final Directory tempDir = Directory.systemTemp;
    final File tempFile = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_$filename');
    await tempFile.writeAsBytes(bytes);
    return TempFile(tempFile);
  }
}

class TempFile {
  final File file;
  TempFile(this.file);
}
