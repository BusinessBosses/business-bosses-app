import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import '../models/buyer_request_model.dart';

class BuyerRequestController extends GetxController {
  final RxList<BuyerRequestModel> buyerRequests = <BuyerRequestModel>[].obs;
  final RxBool loading = false.obs;
  final RxBool error = false.obs;
  final RxBool loadingMore = false.obs;
  // Server-computed count of buyer requests matching a seller's industry +
  // location (the "Matched Buyer" total). Kept separate from [buyerRequests]
  // so the number stays accurate regardless of what's currently loaded/filtered.
  final RxInt matchCount = 0.obs;
  final RxString filterCategory = ''.obs;
  final RxString filterLocation = ''.obs;
  final RxList<BuyerRequestModel> _allRequests = <BuyerRequestModel>[].obs;
  final HomeController homeController = Get.find();

  final ProfileController _profileController = Get.find();

  /// Initialize and fetch all buyer requests
  Future<void> initBuyerRequests(
      {String? location, String? query, String? priorityLocation}) async {
    buyerRequests.clear();
    loading(true);
    error(false);
    update();

    String path = 'buyer-request';
    final List<String> params = <String>[];
    if (location != null && location.isNotEmpty) {
      params.add('location=${Uri.encodeComponent(location)}');
    }
    if (query != null && query.isNotEmpty) {
      params.add('q=${Uri.encodeComponent(query)}');
    }
    if (priorityLocation != null && priorityLocation.isNotEmpty) {
      params.add('priorityLocation=${Uri.encodeComponent(priorityLocation)}');
    }

    if (params.isNotEmpty) {
      path += '?${params.join('&')}';
    }

    final ApiResponseModel response = await ApiService.get(path: path);

    if (response.success) {
      processRequestsToState(response.data);
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  /// Fetch the exact count of buyer requests matching [category] + [location].
  /// Mirrors the filtering used by "Find my match → I need customers" so the
  /// "Matched Buyer" tile shows a number that agrees with the list it opens.
  Future<void> fetchMatchCount({String? category, String? location}) async {
    final List<String> params = <String>[];
    if (category != null && category.isNotEmpty) {
      params.add('category=${Uri.encodeQueryComponent(category)}');
    }
    if (location != null && location.isNotEmpty) {
      params.add('location=${Uri.encodeQueryComponent(location)}');
    }

    String path = 'buyer-request/match-count';
    if (params.isNotEmpty) {
      path += '?${params.join('&')}';
    }

    try {
      final ApiResponseModel response = await ApiService.get(path: path);
      if (response.success && response.data != null) {
        matchCount.value = (response.data['count'] ?? 0) as int;
        update();
      } else {
        log('fetchMatchCount failed: ${response.message}');
      }
    } catch (e) {
      // Leave the previous count in place; surface the failure for debugging
      // rather than silently swallowing it.
      log('fetchMatchCount error: $e');
    }
  }

  /// Process fetched buyer requests into state
  void processRequestsToState(List<dynamic> rows) {
    buyerRequests.clear();
    _allRequests.clear(); // store backup
    for (dynamic item in rows) {
      final BuyerRequestModel request = BuyerRequestModel.fromJson(item);
      buyerRequests.add(request);
      _allRequests.add(request);
    }
  }

  /// Add a new buyer request
  Future<void> addBuyerRequest(Map<String, dynamic> body,
      {List<PlatformFile>? attachments}) async {
    loading(true);
    error(false);
    update();

    if (attachments != null && attachments.isNotEmpty) {
      final List<String> urls = await _uploadAttachments(attachments);
      body['attachments'] = urls;
    }
    log((<String, dynamic>{
      ...body,
      'user_id': _profileController.myProfile.uid,
    }).toString());
    final ApiResponseModel response = await ApiService.post(
      path: 'buyer-request',
      body: <String, dynamic>{
        ...body,
        'user_id': _profileController.myProfile.uid,
      },
    );

    log(response.toJson().toString());

    if (response.success && response.data != null) {
      buyerRequests.insert(
        0,
        BuyerRequestModel.fromJson(
          <String, dynamic>{
            ...response.data,
            'user': _profileController.myProfile.toMap()
          },
        ),
      );
      homeController.myRequests.insert(
        0,
        BuyerRequestModel.fromJson(
          <String, dynamic>{
            ...response.data,
            'user': _profileController.myProfile.toMap()
          },
        ),
      );
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  Future<List<String>> _uploadAttachments(List<PlatformFile> files) async {
    final List<String> urls = <String>[];

    for (final PlatformFile f in files) {
      try {
        if (f.path != null && f.path!.isNotEmpty) {
          final File file = File(f.path!);
          final dynamic uploadResult = await ApiService.uploadFile(file);

          if (uploadResult != null &&
              uploadResult is Map &&
              uploadResult['success'] == true) {
            final String url = (uploadResult['fileUrl'])?.toString() ??
                jsonEncode(uploadResult);
            urls.add(url);
          } else {
            Get.snackbar('Upload failed', 'Failed to upload ${f.name}');
          }
        } else if (f.bytes != null) {
          final Directory temp = Directory.systemTemp;
          final File tempFile = File(
              '${temp.path}/${DateTime.now().millisecondsSinceEpoch}_${f.name}');
          await tempFile.writeAsBytes(f.bytes!);

          final dynamic uploadResult = await ApiService.uploadFile(tempFile);
          await tempFile.delete();

          if (uploadResult != null &&
              uploadResult is Map &&
              uploadResult['success'] == true) {
            final String url = (uploadResult['fileUrl'])?.toString() ??
                jsonEncode(uploadResult);
            urls.add(url);
          } else {
            Get.snackbar('Upload failed', 'Failed to upload ${f.name}');
          }
        }
      } catch (e) {
        Get.snackbar('Upload exception', e.toString());
      }
    }

    return urls;
  }

  /// Update an existing buyer request
  Future<void> updateBuyerRequest(
    int id,
    Map<String, dynamic> body, {
    List<PlatformFile>? attachments,
    List<String>? existingAttachments, // for pre-existing attachments
  }) async {
    loading(true);
    error(false);
    update();

    // 🟢 Upload new attachments if added
    if (attachments != null && attachments.isNotEmpty) {
      final List<String> newUrls = await _uploadAttachments(attachments);
      body['attachments'] = <String>[
        ...existingAttachments ?? <String>[],
        ...newUrls,
      ];
    } else if (existingAttachments != null) {
      // 🟡 Keep existing attachments if no new files uploaded
      body['attachments'] = existingAttachments;
    }

    final ApiResponseModel response = await ApiService.put(
      path: 'buyer-request/$id',
      body: body,
    );

    if (response.success && response.data != null) {
      int index = buyerRequests.indexWhere((BuyerRequestModel r) => r.id == id);
      if (index != -1) {
        final BuyerRequestModel updatedRequest =
            BuyerRequestModel.fromJson(<String, dynamic>{
          ...response.data,
          'user': buyerRequests[index].user.toMap()
        });

        // Optionally merge user info if API doesn’t include it
        buyerRequests[index] = updatedRequest;
      }
    } else {
      error(true);
    }

    loading(false);
    update();
  }

  /// Delete a buyer request
  Future<bool> deleteBuyerRequest(int id) async {
    final ApiResponseModel response =
        await ApiService.delete(path: 'buyer-request/$id');

    if (response.success) {
      buyerRequests.removeWhere((BuyerRequestModel r) => r.id == id);
      if (homeController.myRequests.isNotEmpty) {
        homeController.myRequests
            .removeWhere((BuyerRequestModel r) => r.id == id);
      }
      update();
      return true;
    } else {
      error(true);
      return false;
    }
  }

  /// Filter requests by category or search query
  void filterBuyerRequests(String query) {
    final String lowerQuery = query.toLowerCase().trim();
    final String lowerCat = filterCategory.value.toLowerCase().trim();
    final String lowerLoc = filterLocation.value.toLowerCase().trim();

    if (lowerQuery.isEmpty && lowerCat.isEmpty && lowerLoc.isEmpty) {
      buyerRequests.assignAll(_allRequests);
    } else {
      final List<BuyerRequestModel> filtered = _allRequests.where(
        (BuyerRequestModel r) {
          final bool matchQuery = lowerQuery.isEmpty ||
              r.title.toLowerCase().contains(lowerQuery) ||
              r.description.toLowerCase().contains(lowerQuery);

          final bool matchCat =
              lowerCat.isEmpty || r.category.toLowerCase().trim() == lowerCat;

          final bool matchLoc = lowerLoc.isEmpty ||
              (r.user.location != null &&
                  r.user.location!.toLowerCase() == lowerLoc);

          return matchQuery && matchCat && matchLoc;
        },
      ).toList();
      buyerRequests.assignAll(filtered);
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    initBuyerRequests();
  }
}
