import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/donation_created.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/features/withdrawal/model/cointransactionmodel.dart';
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

  Future<void> fetchCoinHistoryTransactions(CoinTransaction coinTransaction) async {
    try {
      hLoading(true); // Set loading to true before fetching data
      users.clear();
      times.clear();
      amounts.clear();
      ApiResponseModel response = await ApiService.get(
          path: 'transaction-history/user/${profileController.myProfile.uid}');
      if (response.success) {
        myHistory.clear();
        final List<dynamic> responseData = response.data['rows'];
        final List<Map<String, dynamic>> mappedData =
            responseData.cast<Map<String, dynamic>>();
        myHistory.addAll(mappedData);
        for (Map<String, dynamic> item in mappedData) {
          if (item['transactionType'] == "debit") {
            coinwithdrawalHistory.add(item);
          } else {
            coindepositsHistory.add(item);
          }
        }
        for (int i = 0; i < response.data['rows'].length; i++) {
          if (response.data['rows'][i]['user'] != null) {
            UserModel user = UserModel.fromMap(<String, dynamic>{
              ...response.data['rows'][i]['user'],
            });
            times.add(response.data['rows'][i]['date']);
            amounts.add(response.data['rows'][i]['amount']);
            users.add(user);
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
      update(); // Update the UI after data fetch completes
    }
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
      // print(data);
    });

    socket.on('new-notification', (data) {
      // print(data);
      profileController.updateProfile(
          {...profileController.myProfile.toMap(), 'unReadCount': 1});
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
