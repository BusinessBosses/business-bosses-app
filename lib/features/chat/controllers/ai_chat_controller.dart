// lib/features/chat/controllers/ai_chat_controller.dart
import 'dart:convert';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/ai_chat_message.dart';

class AiChatController extends GetxController {
  // The conversation: user messages (isMe=true) & bot replies (isMe=false)
  final RxList<AiChatMessage> messages = <AiChatMessage>[
    AiChatMessage(
      text:
          'Hi, I\'m BB SmartChat. Here to help you make smarter decisions and elevate your business.',
      isMe: false,
    ),
  ].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final ProfileController profileController = Get.find();

  // Safe API key initialization
  String? _apiKey;

  @override
  void onInit() {
    super.onInit();
    _initializeApiKey();
  }

  void _initializeApiKey() {
    _apiKey = dotenv.env['OPENAI_KEY'];
    if (_apiKey == null || _apiKey!.isEmpty) {
      errorMessage.value =
          'OpenAI API key not configured. Please check your .env file.';
      print('ERROR: OPENAI_KEY not found in environment variables');
    } else {
      print('OpenAI API key loaded successfully');
    }
  }

  /// Call this to send a new user message and fetch a reply.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Check if API key is available
    if (_apiKey == null || _apiKey!.isEmpty) {
      errorMessage.value =
          'OpenAI API key not configured. Please add OPENAI_KEY to your .env file.';
      return;
    }

    // 1) add the user's message to the list
    messages.add(AiChatMessage(text: text, isMe: true));
    isLoading.value = true;
    errorMessage.value = null;

    // 2) build the payload for the Responses API
    //   we prefix with your system prompt on the first call:
    final List<Map<String, String>> inputPayload = <Map<String, String>>[
      <String, String>{
        'role': 'system',
        'content': '''
You are **BB Smartchat**, a friendly and expert business advisor. You specialize in:

  • Strategy  
  • Finance  
  • Marketing  
  • Operations  
  • Entrepreneurship  

When you respond, follow these guidelines:

1. **Focus.**  Only answer questions about business topics.  
2. **Personalize.**  Use the user's profile data below to tailor your advice:  
   ${profileController.myProfile.toMap()}  
3. **Tone.**  Be clear, concise, and actionable. Use a professional yet approachable style.  
4. **Off-topic fallback.**  If the user's request isn't business-related, reply **exactly**:  
   "❌ I'm sorry, but I can only answer business-related questions."  
5. **Allowed digressions.**  You may graciously accept:  
   - **Compliments** (e.g. "Thanks!")  
   - **Meta-questions** (e.g. "Who are you?")  
   - **Casual greetings** (e.g. "hi," "hello," "good morning")  

   For greetings, respond with a brief, friendly welcome.  
   _Example_:  
   **User**: "Hi!"  
   **BizBot**: "Hello there! 👋 How can I help you with your business today?"

Now, let's help the user with their next request!
'''
      },
      // then all chat so far
      ...messages.map((AiChatMessage m) => <String, String>{
            'role': m.isMe ? 'user' : 'assistant',
            'content': m.text,
          }),
    ];

    final Map<String, Object> body = <String, Object>{
      'model': 'gpt-4.1-nano',
      'input': inputPayload,
      'text': <String, Map<String, String>>{
        'format': <String, String>{'type': 'text'}
      },
      'reasoning': <String, dynamic>{},
      'tools': <dynamic>[],
      'temperature': 0.7,
      'max_output_tokens': 1024,
      'top_p': 0.9,
      'store': true,
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
        // extract assistant text
        final List<dynamic> outputs =
            data['output'] as List<dynamic>? ?? <dynamic>[];
        if (outputs.isNotEmpty) {
          final List<Map<String, dynamic>> content =
              (outputs.first['content'] as List<dynamic>? ?? <dynamic>[])
                  .cast<Map<String, dynamic>>();

          if (content.isNotEmpty && content.first['text'] is String) {
            messages.add(AiChatMessage(
              text: content.first['text'] as String,
              isMe: false,
            ));
          } else {
            errorMessage.value = 'No valid response content received from API';
          }
        } else {
          errorMessage.value = 'Empty response received from API';
        }
      } else {
        errorMessage.value = 'Error ${resp.statusCode}: ${resp.body}';
        print('API Error: ${resp.statusCode} - ${resp.body}');
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      print('Exception in sendMessage: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper method to check if the controller is properly configured
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  /// Method to manually set API key (for testing or dynamic configuration)
  void setApiKey(String apiKey) {
    _apiKey = apiKey;
    if (errorMessage.value?.contains('API key not configured') == true) {
      errorMessage.value = null;
    }
  }

  /// Clear all messages and reset to initial state
  void clearChat() {
    messages.clear();
    messages.add(AiChatMessage(
      text:
          'Hi, I\'m BB SmartChat. Here to help you make smarter decisions and elevate your business.',
      isMe: false,
    ));
    errorMessage.value = null;
  }
}
