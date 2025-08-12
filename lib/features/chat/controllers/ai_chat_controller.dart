// lib/features/chat/controllers/ai_chat_controller.dart
import 'dart:convert';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/ai_chat_message.dart';

class AiChatController extends GetxController {
  // The conversation: user messages (isMe=true) & bot replies (isMe=false)
  final RxList<AiChatMessage> messages = <AiChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final ProfileController profileController = Get.find();

  // Follow-up questions
  final RxList<String> followUpQuestions = <String>[].obs;
  final RxBool isGeneratingFollowUps = false.obs;

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
      if (kDebugMode) {
        print('ERROR: OPENAI_KEY not found in environment variables');
      }
    } else {
      if (kDebugMode) {
        print('OpenAI API key loaded successfully');
      }
    }
  }

  /// Call this to send a new user message and fetch a reply.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    followUpQuestions.clear();

    // Check if API key is available
    if (_apiKey == null || _apiKey!.isEmpty) {
      errorMessage.value =
          'OpenAI API key not configured. Please add OPENAI_KEY to your .env file.';
      return;
    }

    // Clear previous follow-up questions when sending a new message
    followUpQuestions.clear();

    // 1) add the user's message to the list
    messages.add(AiChatMessage(text: text, isMe: true));
    isLoading.value = true;
    errorMessage.value = null;

    // 2) build the payload for the Responses API
    final List<Map<String, String>> inputPayload = <Map<String, String>>[
      <String, String>{
        'role': 'system',
        'content': '''
You are **Smartchat AI**, a friendly and expert business advisor. You specialize in:

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
   **SmartChat AI**: "Hello there! 👋 How can I help you with your business today?"

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
            final String assistantResponse = content.first['text'] as String;
            messages.add(AiChatMessage(
              text: assistantResponse,
              isMe: false,
            ));

            // Generate follow-up questions after getting the response
            _generateFollowUpQuestions(text, assistantResponse);
          } else {
            errorMessage.value = 'No valid response content received from API';
          }
        } else {
          errorMessage.value = 'Empty response received from API';
        }
      } else {
        errorMessage.value = 'Error ${resp.statusCode}: ${resp.body}';
        if (kDebugMode) {
          print('API Error: ${resp.statusCode} - ${resp.body}');
        }
      }
    } catch (e) {
      errorMessage.value = 'Network error: ${e.toString()}';
      if (kDebugMode) {
        print('Exception in sendMessage: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Generate follow-up questions based on the conversation context
  Future<void> _generateFollowUpQuestions(
      String userQuestion, String assistantResponse) async {
    if (_apiKey == null || _apiKey!.isEmpty) return;

    isGeneratingFollowUps.value = true;
    followUpQuestions.clear();

    try {
      final List<Map<String, String>> followUpPayload = <Map<String, String>>[
        <String, String>{
          'role': 'system',
          'content': '''
You are helping generate natural follow-up questions that a business user might ask after receiving this advice. 
Generate exactly 3 concise follow-up questions (12-15 words max) that:
1. A user would naturally ask next about this topic
2. Are from the user's perspective ("How do I...") 
3. Dive deeper into practical implementation
4. Are directly related to the current response
5. Would help the user take action

Return ONLY a valid JSON array like this:
["question1", "question2", "question3"]
'''
        },
        <String, String>{
          'role': 'user',
          'content': '''
Original question: "$userQuestion"
AI response: "$assistantResponse"

Generate exactly 3 follow-up questions as a JSON array:
'''
        },
      ];

      final Map<String, Object> followUpBody = <String, Object>{
        'model': 'gpt-3.5-turbo',
        'messages': followUpPayload,
        'temperature': 0.7,
        'max_tokens': 200,
      };

      final http.Response resp = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode(followUpBody),
      );

      if (resp.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(resp.body);
        final String content = data['choices'][0]['message']['content'];

        // First try to parse as direct JSON array
        try {
          final List<dynamic> questions = jsonDecode(content) as List<dynamic>;
          followUpQuestions.assignAll(
              questions.take(3).map((dynamic q) => q.toString()).toList());
          return;
        } catch (e) {
          if (kDebugMode) {
            print('Direct array parse failed, trying alternative methods: $e');
          }
        }

        // Fallback 1: Try to find JSON array in text response
        try {
          final RegExp jsonArrayExp = RegExp(r'\[.*\]');
          final String? maybeJson = jsonArrayExp.firstMatch(content)?.group(0);
          if (maybeJson != null) {
            final List<dynamic> questions =
                jsonDecode(maybeJson) as List<dynamic>;
            followUpQuestions.assignAll(
                questions.take(3).map((dynamic q) => q.toString()).toList());
            return;
          }
        } catch (e) {
          if (kDebugMode) {
            print('JSON array extraction failed: $e');
          }
        }

        // Fallback 2: Extract questions between quotes
        try {
          final List<String> questions = _extractQuestionsFromText(content);
          if (questions.isNotEmpty) {
            followUpQuestions.assignAll(questions);
            return;
          }
        } catch (e) {
          if (kDebugMode) {
            print('Text extraction failed: $e');
          }
        }

        // Final fallback: Use default questions
        followUpQuestions.assignAll(<String>[
          'How do I apply this to my specific business?',
          'What are the first steps I should take?',
          'Where can I learn more about this?'
        ]);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error generating follow-ups: $e');
      }
      followUpQuestions.assignAll(<String>[
        'Could you explain this in more detail?',
        'What tools can help with this?',
        'How does this apply to small businesses?'
      ]);
    } finally {
      isGeneratingFollowUps.value = false;
    }
  }

  List<String> _extractQuestionsFromText(String content) {
    // Extract text between quotes or after numbers
    final RegExp exp = RegExp(r'(?:"([^"]+)"|(?:\d+\.\s*)(.+))');
    return exp
        .allMatches(content)
        .map((RegExpMatch match) => match.group(1) ?? match.group(2) ?? '')
        .where((String q) => q.trim().isNotEmpty)
        .take(3)
        .toList();
  }

  // List<String> _parseTextFollowUps(String content) {
  //   // Extract questions between quotes if JSON parsing failed
  //   final RegExp exp = RegExp(r'"([^"]*)"');
  //   return exp
  //       .allMatches(content)
  //       .map((RegExpMatch match) => match.group(1)!)
  //       .where((String q) => q.length > 10 && q.length < 100)
  //       .take(3)
  //       .toList();
  // }

  /// Send a follow-up question
  Future<void> sendFollowUpQuestion(String question) async {
    // Clear the follow-up questions when one is selected
    followUpQuestions.clear();
    await sendMessage(question);
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
    followUpQuestions.clear();
    messages.add(AiChatMessage(
      text: 'Hello👋How can I assist you with your business today?',
      isMe: false,
    ));
    errorMessage.value = null;
  }

  /// Check if we should show follow-up questions
  bool get shouldShowFollowUps =>
      followUpQuestions.isNotEmpty &&
      messages.isNotEmpty &&
      !messages.last.isMe && // Last message is from AI
      !isLoading.value &&
      !isGeneratingFollowUps.value;
}
