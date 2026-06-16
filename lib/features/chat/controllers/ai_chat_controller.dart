// lib/features/chat/controllers/ai_chat_controller.dart
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
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

  // Backend endpoints. The AI provider/keys live server-side.
  static const String _messagePath = 'ai-chat/message';
  static const String _followUpsPath = 'ai-chat/follow-ups';

  /// Builds the system prompt (personalized with the user's profile).
  String get _systemPrompt => '''
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
''';

  /// Call this to send a new user message and fetch a reply.
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Clear previous follow-up questions when sending a new message
    followUpQuestions.clear();

    // 1) add the user's message to the list
    messages.add(AiChatMessage(text: text, isMe: true));
    isLoading.value = true;
    errorMessage.value = null;

    // 2) build the conversation payload (system prompt + full history)
    final List<Map<String, String>> inputPayload = <Map<String, String>>[
      <String, String>{'role': 'system', 'content': _systemPrompt},
      ...messages.map((AiChatMessage m) => <String, String>{
            'role': m.isMe ? 'user' : 'assistant',
            'content': m.text,
          }),
    ];

    try {
      final ApiResponseModel res = await ApiService.post(
        path: _messagePath,
        body: <String, dynamic>{'messages': inputPayload},
      );

      final String assistantResponse = _contentOf(res);
      if (res.success && assistantResponse.trim().isNotEmpty) {
        messages.add(AiChatMessage(text: assistantResponse, isMe: false));
        // Generate follow-up questions after getting the response
        _generateFollowUpQuestions(text, assistantResponse);
      } else {
        errorMessage.value = res.message.isNotEmpty
            ? res.message
            : 'No valid response received. Please try again.';
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

  /// Generate follow-up questions based on the conversation context.
  Future<void> _generateFollowUpQuestions(
      String userQuestion, String assistantResponse) async {
    isGeneratingFollowUps.value = true;
    followUpQuestions.clear();

    try {
      final ApiResponseModel res = await ApiService.post(
        path: _followUpsPath,
        body: <String, dynamic>{
          'userQuestion': userQuestion,
          'assistantResponse': assistantResponse,
        },
      );

      final List<String> questions = _questionsOf(res);
      if (questions.isNotEmpty) {
        followUpQuestions.assignAll(questions.take(3));
        return;
      }

      // Fallback: default questions when the backend returns none.
      followUpQuestions.assignAll(<String>[
        'How do I apply this to my specific business?',
        'What are the first steps I should take?',
        'Where can I learn more about this?'
      ]);
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

  /// Extracts the assistant text from the backend response.
  String _contentOf(ApiResponseModel res) {
    final dynamic data = res.data;
    if (data is String) return data;
    if (data is Map) {
      final dynamic c = data['content'] ?? data['text'];
      if (c is String) return c;
    }
    return '';
  }

  /// Extracts the follow-up questions list from the backend response.
  List<String> _questionsOf(ApiResponseModel res) {
    final dynamic data = res.data;
    if (data is Map && data['questions'] is List) {
      return (data['questions'] as List<dynamic>)
          .map((dynamic q) => q.toString())
          .where((String q) => q.trim().isNotEmpty)
          .toList();
    }
    return <String>[];
  }

  /// Send a follow-up question
  Future<void> sendFollowUpQuestion(String question) async {
    // Clear the follow-up questions when one is selected
    followUpQuestions.clear();
    await sendMessage(question);
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
