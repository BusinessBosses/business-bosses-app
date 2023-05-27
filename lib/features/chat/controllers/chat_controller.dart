import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final bool _isLoading = true;
  final bool _isSearching = false;
  List<MessageModel> chatMessages = [];
  List<MessageModel> chats = [];
  List<MessageModel> searchedChats = [];

  final ProfileController _profileController = Get.find();

  /// GET USER CONVERSATIONS WITH A SECOND PARTY
  List<MessageModel> extractConversations(String counterId, String myId) {
    return chatMessages
        .where((MessageModel element) =>
            (element.senderUid == counterId && element.receiverUid == myId) ||
            (element.senderUid == myId && element.receiverUid == counterId))
        .toList();
  }

  /// SET SEEN STATUS TO A CHAT TO TRUE
  void seen(String counterId, Socket socket) {
    final List<MessageModel> userConversations = chatMessages
        .where((MessageModel element) =>
            element.senderUid == counterId &&
            element.receiverUid == _profileController.myProfile.uid &&
            !element.seen)
        .toList();
    socket.emit('seen-message', {
      'senderUid': counterId,
      'receiverUid': _profileController.myProfile.uid
    });
    for (int i = 0; i < userConversations.length; i++) {
      final int chatIndex = chatMessages.indexWhere(
          (MessageModel element) => element.messageId == userConversations[i].messageId);
      chatMessages[chatIndex] = MessageModel.fromMap(
          {...chatMessages[chatIndex].toMap(), 'seen': true});
    }

    extractChats(_profileController.myProfile.uid);

    update();
  }

  /// EXTRACT UNIQUE CHATS ON SEARCH (REMOVE DUPLICATES)
  void searchChats(String query) {
    searchedChats = chats
        .where((MessageModel element) =>
            element.user.username.toLowerCase().contains(query.toLowerCase()))
        .toList();

    update();
  }

  void clearSearch() {
    searchedChats.clear();
    update();
  }

  /// EXTRACT UNIQUE CHATS (REMOVE DUPLICATES)
  void extractChats(String myId) {
    final List<String> counterIds = chatMessages
        .map((MessageModel e) =>
            e.senderUid == myId ? e.receiverUid : e.senderUid)
        .toList();
    final Set<String> chatIds = <String>{...counterIds};
    final List<String> uniqueChatIds = chatIds.toList();
    chats.clear();
    for (int i = 0; i < uniqueChatIds.length; i++) {
      final String e = uniqueChatIds[i];

      final List<MessageModel> chat = chatMessages
          .where((MessageModel element) =>
              element.senderUid == e || element.receiverUid == e)
          .toList();
      chats.add(chat[i]);
    }
  }

  /// MODELIZE RAW JSON DATA AND STORE TO STATE
  void processDataToState(dynamic cht, String myId) {
    final List chts = cht;
    for (int i = chts.length - 1; i >= 0; i--) {
      chatMessages.add(MessageModel.fromMap(chts[i]));
    }
    extractChats(myId);
    update();
  }

  void newMessage(Map<String, dynamic> data) {
    chatMessages.insert(0, MessageModel.fromMap(data));
    extractChats(data['receiverUid']);

    update();
  }

  void addNewChat(Map<String, dynamic> data, UserModel user, Socket socket) {
    final Map<String, dynamic> body = {
      ...data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'messageId': const Uuid().v4(),
      'seen': false
    };

    chatMessages.insert(
        0, MessageModel.fromMap({...body, 'user': user.toMap()}));
    extractChats(data['senderUid']);
    socket.emit('new-message',
        {'data': body, 'sender': _profileController.myProfile.toMap()});
    update();
  }
}
