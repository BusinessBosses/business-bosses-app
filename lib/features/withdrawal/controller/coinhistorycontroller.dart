import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/withdrawal/presentation/withdrawal_created.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CoinHistoryController extends GetxController {
  late IO.Socket socket;
  final ProfileController profileController = Get.find();
  RxList<DonationModel> donations = <DonationModel>[].obs;
  RxList<UserModel> users = <UserModel>[].obs;
  RxList<dynamic> times = <dynamic>[].obs;
  RxList<dynamic> amounts = <dynamic>[].obs;
  RxList<String> userIds = <String>[].obs;
  List<dynamic> myHistory = <dynamic>[];
  List<dynamic> coindepositsHistory = <dynamic>[];
  List<dynamic> coinwithdrawalHistory = <dynamic>[];
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  RxBool hLoading = RxBool(false);
  RxBool hError = RxBool(false);
  RxBool tLoading = RxBool(false);
  RxBool tError = RxBool(false);

  @override
  void onInit() async {
    initSocket();
    super.onInit();
  }

  ///Make Withdrawal
  Future<void> makeWithdrawal(Map<String, dynamic> coinTransaction) async {
    ApiResponseModel response = await ApiService.post(
        path: 'transaction-history', body: coinTransaction);
    if (response.success) {
      Get.off(() => const WithdrawalCreated());
    } else {}
  }

  Future<void> initHistory() async {
    try {
      hLoading(true);

      ApiResponseModel response = await ApiService.get(
          path: 'transaction-history/user/${profileController.myProfile.uid}');
      if (response.success) {
        myHistory.clear();
        coindepositsHistory.clear();
        coinwithdrawalHistory.clear();
        final List<dynamic> responseData = response.data['rows'];
        final List<Map<String, dynamic>> mappedData =
            responseData.cast<Map<String, dynamic>>();
        myHistory.addAll(mappedData);
        for (Map<String, dynamic> item in mappedData) {
          if (item['transactionType'] == 'credit') {
            coinwithdrawalHistory.add(item);
          } else {
            coindepositsHistory.add(item);
          }
        }
      } else {
        // Handle unsuccessful API response
        hError(true);
      }
    } catch (e) {
      // Handle error
      hError(true);
    } finally {
      hLoading(false); // Set loading back to false after fetching data
      // Update the UI after data fetch completes
    }
    update();
  }

  void initSocket() {
    socket = IO.io(Constants.socketUrl, <String, dynamic>{
      'autoConnect': false,
      'transports': <String>['websocket'],
    });
    socket.connect();
    socket.onConnect((_) {
      // ignore: avoid_print
      print('Connection established');
    });

    socket.on('handshake', (data) {
      // print(data);
    });

    socket.on('new-notification', (data) {
      // print(data);
      profileController.updateProfile(<String, dynamic>{
        ...profileController.myProfile.toMap(),
        'unReadCount': 1
      });
    });

    socket.onReconnect((_) {
      socket.emit('handshake', profileController.myProfile.uid);

      print('reconnected');
    });

    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }
}
