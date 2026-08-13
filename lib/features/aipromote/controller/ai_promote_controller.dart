// lib/features/promotion/controllers/ai_promote_controller.dart
import 'package:flutter/foundation.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class AiPromoteController extends GetxController {
  /// Business details collected from BusinessForm
  final RxString businessName = ''.obs;
  final RxString description = ''.obs;
  final RxString location = ''.obs;
  final RxString industry = ''.obs;
  final RxString postType = 'General Post'.obs;
  final RxString price = ''.obs;
  final RxString additionalDetails = ''.obs;

  /// The user‐edited prompt to send to AI
  final RxString prompt = ''.obs;

  /// The AI‐generated ad copy (body)
  final RxString adCopy = ''.obs;

  /// A short, refined headline derived from the entered title, shown above the
  /// content in the preview/post.
  final RxString adTitle = ''.obs;

  /// Loading & error states
  final RxBool isGenerating = false.obs;
  final RxBool isPosting = false.obs;
  final RxnString errorMessage = RxnString();

  final ProfileController profileController = Get.find();

  /// Backend endpoint that performs the generation. The AI provider
  /// (openai vs vercel) is selected server-side via the POST_AI_PROVIDER env
  /// var — the app never holds an AI key.
  static const String _generatePath = 'ai-promote/generate';

  /// Call this once BusinessForm is valid
  void setBusinessDetails({
    required String name,
    required String desc,
    required String loc,
    required String ind,
    String? type,
    String? priceVal,
    String? additionalDetailsVal,
  }) {
    businessName.value = name;
    description.value = desc;
    location.value = loc;
    industry.value = ind;
    if (type != null) {
      postType.value = type;
    }
    if (priceVal != null) {
      price.value = priceVal;
    }
    if (additionalDetailsVal != null) {
      additionalDetails.value = additionalDetailsVal;
    }

    // Build the prompt from ALL the details captured on the form. Price and
    // additional details were previously collected but never added here, so
    // they never reached the AI (the two if-blocks were empty).
    final StringBuffer promptBuffer = StringBuffer()
      ..write('Write a professional and catchy social media post. ')
      // Perspective MUST match the post type, otherwise a buyer "Need a
      // Product or Service" request reads like a seller advertising it.
      ..write(_intentDirective)
      ..write('Use the following details. ')
      ..write('Post type: ${postType.value}. ')
      // The first field is a free-form Title (not necessarily the business
      // name), matching the "Title" label on the form.
      ..write('Title: ${businessName.value}. ')
      ..write('Industry: ${industry.value}. ')
      // Location is intentionally NOT included — the generated content should
      // not mention the user's location.
      ..write('Description: ${description.value}. ');

    if (price.value.isNotEmpty) {
      promptBuffer.write('Price: ${price.value}. ');
    }
    if (additionalDetails.value.isNotEmpty) {
      promptBuffer.write('Additional details: ${additionalDetails.value}. ');
    }

    promptBuffer
      ..write('Do NOT mention any location, city, or country. NO EMOJIS PLEASE. ')
      // Ask for a refined headline (from the entered title) plus the body,
      // in a strict format we can parse on the client.
      ..write('Respond EXACTLY in this format and nothing else:\n')
        ..write('TITLE: <a short, catchy, refined headline based on the title above, max 8 words, no quotes>\n')
        ..write('BODY: <the post content>');

    prompt.value = promptBuffer.toString();
  }

  /// Perspective instruction tailored to the selected post type so the AI
  /// writes from the right point of view (buyer vs seller vs partner).
  String get _intentDirective {
    switch (postType.value) {
      case 'Find a Partner':
        return 'Write from the perspective of someone SEEKING a business partner or '
            'collaborator. Invite suitable partners to connect — do not frame it as '
            'a product sales ad. ';
      case 'Sell a Product or Service':
      case 'Promote My Business':
      default:
        return 'Write from the perspective of the SELLER/PROVIDER promoting what they '
            'offer, with a strong call-to-action for potential customers. ';
    }
  }

  /// If the user tweaked the prompt in AiPromoteSheet, call this
  void updatePrompt(String newPrompt) {
    prompt.value = newPrompt;
  }

  /// Generates the ad copy via the backend. The AI provider (openai vs vercel)
  /// is chosen server-side by the POST_AI_PROVIDER env var, so the app holds no
  /// AI keys and the choice can change without an app release.
  Future<void> generateAd() async {
    debugPrint('🟦 generateAd() called. promptLen=${prompt.value.trim().length}');

    if (prompt.value.trim().isEmpty) {
      errorMessage.value = 'Nothing to generate — please fill in the details.';
      debugPrint('❌ generateAd aborted: prompt is empty');
      return;
    }

    isGenerating.value = true;
    errorMessage.value = null;

    try {
      debugPrint('🟦 generateAd: POST $_generatePath');
      final ApiResponseModel res = await ApiService.post(
        path: _generatePath,
        body: <String, dynamic>{'prompt': prompt.value},
      );

      final String text = _extractContent(res);
      if (res.success && text.trim().isNotEmpty) {
        _applyGenerated(text.trim());
        debugPrint('✅ generateAd: title="${adTitle.value}" '
            'adCopy set (len=${adCopy.value.length})');
      } else {
        errorMessage.value = res.message.isNotEmpty
            ? res.message
            : 'Could not generate content. Please try again.';
        debugPrint('❌ generateAd failed: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      debugPrint('❌ generateAd: exception -> $e');
    } finally {
      isGenerating.value = false;
      debugPrint('🟦 generateAd: done. adCopyLen=${adCopy.value.length} '
          'errorMessage=${errorMessage.value}');
    }
  }

  /// Splits the model's `TITLE: ...` / `BODY: ...` response into [adTitle] and
  /// [adCopy]. Falls back to the entered title + raw text if the model didn't
  /// follow the format.
  void _applyGenerated(String text) {
    final RegExpMatch? titleMatch =
        RegExp(r'TITLE:\s*(.+)', caseSensitive: false).firstMatch(text);
    final RegExpMatch? bodyMatch =
        RegExp(r'BODY:\s*([\s\S]+)', caseSensitive: false).firstMatch(text);

    if (bodyMatch != null) {
      adTitle.value = (titleMatch?.group(1) ?? businessName.value).trim();
      adCopy.value = bodyMatch.group(1)!.trim();
    } else {
      // Model ignored the format — keep the whole output as the body and use
      // the entered title as the headline.
      adTitle.value = businessName.value.trim();
      adCopy.value = text;
    }
  }

  /// Reads the generated copy out of the backend response. Accepts
  /// `data.content` (preferred), `data` as a raw string, or `data.text`.
  String _extractContent(ApiResponseModel res) {
    final dynamic data = res.data;
    if (data is String) {
      return data;
    }
    if (data is Map) {
      final dynamic content = data['content'] ?? data['text'] ?? data['adCopy'];
      if (content is String) {
        return content;
      }
    }
    return '';
  }
}
