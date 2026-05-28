// lib/features/promotion/controllers/ai_promote_controller.dart
import 'dart:convert';
import 'dart:developer';
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

  /// Your OpenAI key from `.env`
  final String _apiKey = dotenv.env['OPENAI_KEY']!;
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

    String typeContext = '';
    String priceContext = '';
    if (price.value.isNotEmpty) {
      priceContext = ' priced at ${price.value}';
    }

    String extraContext = '';
    if (additionalDetails.value.isNotEmpty) {
      extraContext = ' Additional details: ${additionalDetails.value}.';
    }

    if (postType.value == 'Product') {
      typeContext = 'to sell a product$priceContext';
    } else if (postType.value == 'Service') {
      typeContext = 'to sell a service$priceContext';
    }

    // build a default prompt
    prompt.value = profileController.myProfile.isSubscribed
        ? 'Write a catchy ad $typeContext for a $industry business '
            'called "$businessName" located in $location that: '
            '$description.$extraContext'
        : 'Write a catchy ad $typeContext for a $industry business '
            'for the person named "$businessName" located in $location that: '
            '$description.$extraContext';
  }

  /// If the user tweaked the prompt in AiPromoteSheet, call this
  void updatePrompt(String newPrompt) {
    prompt.value = newPrompt;
  }

  /// Sends [prompt] to OpenAI and populates [adCopy]
  Future<void> generateAd() async {
    if (prompt.value.trim().isEmpty) return;
    isGenerating.value = true;
    errorMessage.value = null;

    Map<String, Object> body = <String, Object>{};

    body = <String, Object>{
      'model': 'gpt-4o',
      'input': <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '''
You are **AiPromoBot**, an expert at writing punchy, high-converting business ads.
Focus on clarity, engagement, and a strong call-to-action. Leave no placeholders in the output and also no dummy data. Don't use brackets too for businesses name and website.
'''
        },
        <String, String>{'role': 'user', 'content': prompt.value},
      ],
      'text': <String, Map<String, String>>{
        'format': <String, String>{'type': 'text'}
      },
      'temperature': 0.7,
      'max_output_tokens': 512,
      'top_p': 0.9,
      'store': false,
    };

    try {
      final http.Response resp = await http.post(
        Uri.parse('https://api.openai.com/v1/responses'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(body),
      );

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final Map<String, dynamic> data =
            jsonDecode(resp.body) as Map<String, dynamic>;
        log(resp.body.toString());
        final List<dynamic> outputs =
            data['output'] as List<dynamic>? ?? <dynamic>[];
        if (outputs.isNotEmpty) {
          final List<Map<String, dynamic>> content =
              (outputs.first['content'] as List<dynamic>?)
                      ?.cast<Map<String, dynamic>>() ??
                  <Map<String, dynamic>>[];
          final String? text =
              content.isNotEmpty ? content.first['text'] as String : null;
          if (text != null) {
            adCopy.value = text.trim();
          } else {
            errorMessage.value = 'No text in AI response.';
          }
        } else {
          errorMessage.value = 'Empty AI output.';
        }
      } else {
        errorMessage.value = 'Error ${resp.statusCode}: ${resp.body}';
      }
    } catch (e) {
      errorMessage.value = 'Exception: $e';
    } finally {
      isGenerating.value = false;
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
