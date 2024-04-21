import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DonationsController extends GetxController {
  late IO.Socket socket;
  final ProfileController profileController = Get.find();
  RxList<DonationModel> donations = <DonationModel>[].obs;
  RxList<String> userIds = <String>[].obs;
  List<dynamic> myHistory = <dynamic>[];
  List<dynamic> myHistoryReceived = <dynamic>[];
  List<dynamic> myHistoryOut = <dynamic>[];
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);
  RxBool hLoading = RxBool(false);
  RxBool hError = RxBool(false);

  @override
  void onInit() async {
    initSocket();
    await initUsers();
    fetchDonations();
    super.onInit();
  }

  Future<void> fetchDonations() async {
    try {
      loading(true); // Set loading to true before fetching data
      update();
      ApiResponseModel response = await ApiService.get(path: 'donation/all');

      // Clear previous donations before adding new ones
      donations.clear();
      if (response.success) {
        for (int i = 0; i < response.data['rows'].length; i++) {
          if (response.data['rows'][i]['user'] != null) {
            DonationModel donation = DonationModel.fromMap(<String, dynamic>{
              ...response.data['rows'][i],
              'likes': response.data['rows'][i]['likes']
                  .map((dynamic like) => like['userId'].toString())
                  .toList(),
            });
            donations.add(donation);
          }
        }
      }
      error(false);
    } catch (e) {
      error(true); // Set error to true if there's an error
    } finally {
      loading(false); // Set loading back to false after fetching data
    }
    update();
  }

  Future<void> createDonation(Map<String, dynamic> donation) async {
    ApiResponseModel response =
        await ApiService.post(path: 'donation', body: donation);
    if (response.success) {
      // donations.insert(
      //     0,
      //     DonationModel.fromMap(
      //         <String, dynamic>{...donation, 'id': response.data['id']}));
      update();
      Get.back();
      Get.snackbar('Success', 'Donations Pending Approval!');
    }
  }

  Future<void> joinGroup() async {
    ApiResponseModel response = await ApiService.put(
        path:
            'donation/join-leave-donation/6463a069-657d-47ae-b937-9a5d4c336811',
        body: <String, dynamic>{});
    if (response.success) {
      if (userIds.contains(profileController.myProfile.uid)) {
        // If it exists, remove it
        userIds.remove(profileController.myProfile.uid);
      } else {
        // If it doesn't exist, add it
        userIds.add(profileController.myProfile.uid);
      }
    }
    update();
  }

  Future<void> initUsers() async {
    ApiResponseModel response = await ApiService.get(
        path: 'donation/get-joined-users/6463a069-657d-47ae-b937-9a5d4c336811');
    if (response.success) {
      List<dynamic> rows = response.data['rows'];
      userIds.addAll(rows.map((row) => row['userId'].toString()).toList());
      update();
    }
  }

  Future<bool> contributeDonation(Map<String, dynamic> data, String id) async {
    ApiResponseModel response =
        await ApiService.post(path: 'donation-transactions', body: data);
    if (response.success) {
      final int donationIndex =
          donations.indexWhere((DonationModel donation) => donation.id == id);
      if (donationIndex != -1) {
        donations[donationIndex]
            .setRecievedAmount(int.tryParse(data['amount'])!);
        profileController.myProfile
            .incrementCoinsCount(-(int.tryParse(data['amount'])!));
        update();
        return true;
      }
    }
    return false;
  }

  Future<void> initHistory() async {
    try {
      hLoading(true); // Set loading to true before fetching data

      ApiResponseModel response = await ApiService.get(
          path:
              'donation-transactions/user/${profileController.myProfile.uid}');
      if (response.success) {
        myHistory.clear();
        final List<dynamic> responseData = response.data['rows'];
        final List<Map<String, dynamic>> mappedData =
            responseData.cast<Map<String, dynamic>>();
        myHistory.addAll(mappedData);
        for (Map<String, dynamic> item in mappedData) {
          if (item['type'] == 'donated') {
            myHistoryOut.add(item);
          } else {
            myHistoryReceived.add(item);
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

  /// LIKE AND UNLIKE FUNCTION
  void postLike(String userId, String postId, String receiverUid) {
    final int donationIndex =
        donations.indexWhere((donation) => donation.id == postId);
    if (donationIndex != -1) {
      final bool checkLiked = donations[donationIndex].likes!.contains(userId);
      if (checkLiked) {
        donations[donationIndex].likes?.remove(userId);
      } else {
        donations[donationIndex].likes?.add(userId);
      }
      update();
    }

    if (profileController.myProfile.uid != receiverUid) {
      socket.emit('like', {
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('like', {
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  /// COMMENT FUNCTION
  void comment(String postId, dynamic comment, String type) {
    final int donationIndex =
        donations.indexWhere((donation) => donation.id == postId);
    if (donationIndex != -1) {
      if (type == 'post') {
        donations[donationIndex].comments?.add(comment);
      } else {
        // Handle comment for forum posts or other types if needed
      }
      update();
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
