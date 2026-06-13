// lib/features/promotion/controllers/ai_promote_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

  /// The AI‐generated ad copy
  final RxString adCopy = ''.obs;

  /// Loading & error states
  final RxBool isGenerating = false.obs;
  final RxBool isPosting = false.obs;
  final RxnString errorMessage = RxnString();

  /// Your OpenAI key from `.env` (may be missing/empty if not configured).
  final String? _apiKey = dotenv.env['OPENAI_KEY'];
  final ProfileController profileController = Get.find();

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
      ..write(
          'Rewrite the following information into a professional and catchy social media post for a ${postType.value}. ')
      // The first field is a free-form Title (not necessarily the business
      // name), matching the "Title" label on the form.
      ..write('Title: ${businessName.value}. ')
      ..write('Industry: ${industry.value}. ')
      ..write('Location: ${location.value}. ')
      ..write('Description: ${description.value}. ');

    if (price.value.isNotEmpty) {
      promptBuffer.write('Price: ${price.value}. ');
    }
    if (additionalDetails.value.isNotEmpty) {
      promptBuffer.write('Additional details: ${additionalDetails.value}. ');
    }

    promptBuffer.write('NO EMOJIS PLEASE.');

    prompt.value = promptBuffer.toString();
  }

  /// If the user tweaked the prompt in AiPromoteSheet, call this
  void updatePrompt(String newPrompt) {
    prompt.value = newPrompt;
  }

  /// Sends [prompt] to OpenAI and populates [adCopy]
  Future<void> generateAd() async {
    debugPrint('🟦 generateAd() called. promptLen=${prompt.value.trim().length} '
        'apiKeyLen=${_apiKey?.trim().length ?? 0}');

    if (prompt.value.trim().isEmpty) {
      errorMessage.value = 'Nothing to generate — please fill in the details.';
      debugPrint('❌ generateAd aborted: prompt is empty');
      return;
    }

    // Fail loudly when the key isn't configured instead of sending an empty
    // Bearer token (which 401s) and silently showing a placeholder.
    if (_apiKey == null || _apiKey!.trim().isEmpty) {
      errorMessage.value =
          'OpenAI API key not configured. Add OPENAI_KEY to your .env file.';
      debugPrint('❌ generateAd aborted: OPENAI_KEY is missing/empty in .env');
      return;
    }

    isGenerating.value = true;
    errorMessage.value = null;

    final Map<String, dynamic> body = <String, dynamic>{
      'model': 'gpt-4o',
      'messages': <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '''
You are **AiPromoBot**, an expert at writing punchy, high-converting business ads.
Focus on clarity, engagement, and a strong call-to-action. Leave no placeholders in the output and also no dummy data. Don't use brackets too for businesses name and website.
STRICT RULE: Do not include any emojis in the generated content.
'''
        },
        <String, String>{'role': 'user', 'content': prompt.value},
      ],
      'temperature': 0.7,
      'max_tokens': 512,
      'top_p': 0.9,
    };

    try {
      debugPrint('🟦 generateAd: POST https://api.openai.com/v1/chat/completions');
      final http.Response resp = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(body),
      );

      debugPrint('🟦 generateAd: status=${resp.statusCode} bodyLen=${resp.body.length}');

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final Map<String, dynamic> data =
            jsonDecode(resp.body) as Map<String, dynamic>;
        log(resp.body.toString());

        if (data['choices'] != null &&
            (data['choices'] as List<dynamic>).isNotEmpty) {
          final String? text = data['choices'][0]['message']['content'];
          if (text != null) {
            adCopy.value = text.trim();
            debugPrint('✅ generateAd: adCopy set (len=${adCopy.value.length})');
          } else {
            errorMessage.value = 'No text in AI response.';
            debugPrint('❌ generateAd: no content field in response');
          }
        } else {
          errorMessage.value = 'Empty AI output.';
          debugPrint('❌ generateAd: no choices in response');
        }
      } else {
        errorMessage.value = 'Error ${resp.statusCode}: ${resp.body}';
        debugPrint('❌ generateAd: HTTP ${resp.statusCode} -> ${resp.body}');
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
      debugPrint('❌ generateAd: exception -> $e');
    } finally {
      isGenerating.value = false;
      debugPrint('🟦 generateAd: done. errorMessage=${errorMessage.value}');
    }
  }

  /// Simulates posting the ad to your backend or social channel
  Future<void> postAd() async {
    if (adCopy.value.trim().isEmpty) return;
    isPosting.value = true;
    errorMessage.value = null;

    try {
      // Replace with your real post API
      final http.Response resp = await http.post(
        Uri.parse('https://api.yourapp.com/promotions'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'businessName': businessName.value,
          'adCopy': adCopy.value,
        }),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        // success → navigate to SuccessScreen in your UI layer
      } else {
        errorMessage.value = 'Post failed: ${resp.body}';
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
    } finally {
      isPosting.value = false;
    }
  }
}
