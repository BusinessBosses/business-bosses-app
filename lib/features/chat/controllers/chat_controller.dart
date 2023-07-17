import 'dart:io';

import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/chat/models/my_message.dart';
import 'package:business_bosses_v2/features/home/controller/home_controller.dart';
import 'package:business_bosses_v2/features/marketplace/models/market_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  final bool _isLoading = true;
  final bool _isSearching = false;
  List<MessageModel> chatMessages = [];
  List<MessageModel> chats = [];
  List<MessageModel> searchedChats = [];
  late ImagePicker _picker;

  final ProfileController _profileController = Get.find();

  /// GET USER CONVERSATIONS WITH A SECOND PARTY
  List<MessageModel> extractConversations(String counterId, String myId) {
    return chatMessages
        .where((MessageModel element) =>
            (element.senderUid == counterId && element.receiverUid == myId) ||
            (element.senderUid == myId && element.receiverUid == counterId))
        .toList();
  }

  // void addMarketPost(MarketModel marketPost){
  //   chatMessages.insert(marketPost);
  // }

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
      final int chatIndex = chatMessages.indexWhere((MessageModel element) =>
          element.messageId == userConversations[i].messageId);
      chatMessages[chatIndex] = MessageModel.fromMap(
          {...chatMessages[chatIndex].toMap(), 'seen': true});
    }

    extractChats(_profileController.myProfile.uid);

    update();
  }

  /// EXTRACT UNIQUE CHATS ON SEARCH (REMOVE DUPLICATES)
  void searchChats(String query) {
    searchedChats = chats.where((MessageModel element) {
      if (element.user != null) {
        return element.user!.username
            .toLowerCase()
            .contains(query.toLowerCase());
      }
      return false;
    }).toList();

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
              (element.senderUid == e &&
                  element.receiverUid == _profileController.myProfile.uid) ||
              (element.receiverUid == e &&
                  element.senderUid == _profileController.myProfile.uid))
          .toList();
      if (chat.isNotEmpty) {
        chats
            .add(chat[0]); // Add all chat elements instead of accessing chat[i]
      }
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

  /// ADD ON SOCKET EVENT
  void newMessage(Map<String, dynamic> data) {
    chatMessages.insert(0, MessageModel.fromMap(data));
    extractChats(data['receiverUid']);

    update();
  }

  void addNewChat(Map<String, dynamic> data, UserModel user) {
    final HomeController _homeController = Get.find();

    final Map<String, dynamic> body = {
      ...data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'messageId': const Uuid().v4(),
      'seen': false
    };

    chatMessages.insert(
        0, MessageModel.fromMap({...body, 'user': user.toMap()}));
    extractChats(data['senderUid']);
    _homeController.socket.emit('new-message',
        {'data': body, 'sender': _profileController.myProfile.toMap()});
    update();
  }

  void addNewChatMarket(
      Map<String, dynamic> data, UserModel user, String marketId) {
    final HomeController _homeController = Get.find();

    final Map<String, dynamic> body = {
      ...data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'messageId': const Uuid().v4(),
      'marketId': marketId,
      'seen': false
    };

    chatMessages.insert(
        0, MessageModel.fromMap({...body, 'user': user.toMap()}));
    extractChats(data['senderUid']);
    _homeController.socket.emit('new-message',
        {'data': body, 'sender': _profileController.myProfile.toMap()});
    update();
  }

  void uploadNewChat(Map<String, dynamic> data, UserModel user) {
    final HomeController _homeController = Get.find();

    final Map<String, dynamic> body = {
      ...data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'messageId': const Uuid().v4(),
      'seen': false
    };

    chatMessages.insert(
        0, MessageModel.fromMap({...body, 'user': user.toMap()}));
    extractChats(data['senderUid']);
    _homeController.socket.emit('new-message',
        {'data': body, 'sender': _profileController.myProfile.toMap()});
    update();
  }

  /// PICK IMAGE FROM DEVICE GALLERY
  Future<void> onPickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final HomeController _homeController = Get.find();

        final File imageFile = File(image.path);
        final String messageId = const Uuid().v4();
        final Map<String, dynamic> body = {
          'senderUid': _profileController.myProfile.uid,
          'receiverUid': Get.arguments.uid,
          'image': imageFile.path,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'messageId': const Uuid().v4(),
          'seen': false,
          'isRawImage': true
        };
        chatMessages.insert(
            0, MessageModel.fromMap({...body, 'user': Get.arguments.toMap()}));
        extractChats(_profileController.myProfile.uid);
        update();
        final uploadResponse = await ApiService.uploadFile(imageFile);
        if (uploadResponse == null) {
          final int messageIndex = chatMessages.indexWhere(
            (MessageModel element) => element.messageId == messageId,
          );
          if (messageIndex != -1) {
            chatMessages.removeAt(messageIndex);
          }
          showSnackbar(message: 'Error Uploading image');
        } else {
          final String imageUrl = uploadResponse['fileUrl'];
          _homeController.socket.emit('new-message', {
            'data': {
              ...body,
              'image': imageUrl,
            },
            'sender': _profileController.myProfile.toMap()
          });
        }
        update();
      }
    } catch (e) {
      rethrow;
      // handle error
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _picker = ImagePicker();

    super.onInit();
  }
}
