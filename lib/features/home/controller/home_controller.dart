import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/widgets/text_widget.dart';
import 'package:business_bosses_v2/features/chat/controllers/chat_controller.dart';
import 'package:business_bosses_v2/features/home/repository/home_repository.dart';
import 'package:business_bosses_v2/features/marketplace/controllers/market_controller.dart';
import 'package:business_bosses_v2/features/posts/controllers/posts_controller.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:business_bosses_v2/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomeController extends GetxController {
  late IO.Socket socket;
  final PostsController _postsController = Get.find();
  final ProfileController _profileController = Get.find();
  final ChatController _chatController = Get.find();
  final MarketController _marketController = Get.put(MarketController());
  RxBool error = RxBool(false);
  RxBool loading = RxBool(false);
  List<Map<String, dynamic>>? bossUp = [];

  /// SHOW WHEN ACCESS TOKEN EXPIRES
  void showAccessTokenDialog() {
    showDialog(
      barrierDismissible: false,
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: const TextWidget(
          text: 'Access token expired',
          fontWeight: FontWeight.w700,
          size: 18,
        ),
        content: const TextWidget(
          text:
              'Your access token has expired. therefore, you will be required to login again to generate a new one. ',
        ),
        actions: [
          TextButton(
            onPressed: () {
              ApiService().logout();
              Navigator.of(context).pop(context);
            },
            child: const TextWidget(
              text: 'Create new Access Token',
              color: primaryColorLT,
            ),
          )
        ],
      ),
    );
  }

  void showCoinDialog() {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: const TextWidget(
          text: 'Congratulations',
          fontWeight: FontWeight.bold,
          size: 20,
        ),
        content: TextWidget(
          text: 'You have earned 1 coin for logging into Business Bosses today',
          color: Colors.black.withOpacity(.8),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const TextWidget(
              text: 'OK',
            ),
          )
        ],
      ),
    );
  }

  /// DailyCoin
  void addCoinDaily() {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;

    int lastExecutionTimestamp = sandBox.read('lastExecutionTimestamp') ?? 0;
    if (currentTimestamp - lastExecutionTimestamp >= 24 * 60 * 60 * 1000) {
      // The action hasn't been executed today, save the current timestamp
      sandBox.write('lastExecutionTimestamp', currentTimestamp);
      ApiService.put(
        path: 'users/${_profileController.myProfile.uid}',
        body: <String, dynamic>{
          'coinscount': _profileController.myProfile.coinscount! + 1,
        },
      );
      _profileController.updateCoinCount(1);
      showCoinDialog();
    }
  }

  /// LOAD POSTS FROM REMOTE SOURCE
  Future<void> loadData() async {
    loading(true);
    error(false);
    update();
    final ApiResponseModel response = await HomeRepository.fetchData();
    final ApiResponseModel partner = await HomeRepository.fetchPartner();
    if (response.success) {
      _postsController.processPostsAndForumsData(response.data['posts']);
      _profileController.processDataToState(response.data['user']);
      _chatController.processDataToState(
          response.data['chats'], _profileController.myProfile.uid);
      socket.emit('handshake', _profileController.myProfile.uid);
      _marketController.initMarket();
      _marketController.initUsers();
      addCoinDaily();
      if (partner.data['count'] > 0) {
        bossUp?.addAll(partner.data['rows'].cast<Map<String, dynamic>>());
        print(bossUp);
      }
    } else {
      error(true);
      socket.disconnect();
      if (response.message == 'send a valid token') {
        showAccessTokenDialog();
      } else {
        showSnackbar(title: 'OOPS!', message: response.message, error: true);
      }
    }

    loading(false);
    update();
  }

  initSocket() {
    socket = IO.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });

    socket.on('handshake', (data) {
      print(data);
    });

    socket.on('new-message', (data) {
      // print(data);
      _chatController.newMessage(data);
    });

    socket.onReconnect((_) {
      socket.emit('handshake', _profileController.myProfile.uid);

      print('reconnected');
    });

    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  @override
  void onInit() {
    // TODO: implement onInit
    initSocket();
    loadData();
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
