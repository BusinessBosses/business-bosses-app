import 'package:business_bosses_v2/common/dialogs/snackbar.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/common/models/user_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/features/donations/presentation/donation_created.dart';
import 'package:business_bosses_v2/features/forum/models/industry.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/utils/constants/constants.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DonationsController extends GetxController {
  late IO.Socket socket;
  final ProfileController profileController = Get.find();
  RxList<DonationModel> donations = <DonationModel>[].obs;
  RxList<DonationModel> donationsNotApproved = <DonationModel>[].obs;
  RxList<UserModel> users = <UserModel>[].obs;
  List<UserModel> searchedUsers = <UserModel>[];
  List<DonationModel> searchedPosts = <DonationModel>[];
  RxBool loadingSearch = RxBool(false);
  RxBool loadingPostsSearch = RxBool(false);
  RxBool isUserSearch = RxBool(false);
  RxBool isPostSearch = RxBool(false);
  RxList<UserModel> usersMembers = <UserModel>[].obs;
  RxList<dynamic> times = <dynamic>[].obs;
  RxList<dynamic> amounts = <dynamic>[].obs;
  RxList<String> userIds = <String>[].obs;
  List<dynamic> myHistory = <dynamic>[];
  List<dynamic> myHistoryReceived = <dynamic>[];
  List<dynamic> myHistoryOut = <dynamic>[];
  RxBool loading = RxBool(true);
  RxBool error = RxBool(false);
  RxBool hLoading = RxBool(false);
  RxBool hError = RxBool(false);
  RxBool tLoading = RxBool(false);
  RxBool tError = RxBool(false);
  RxList<DonationModel> userdonations = <DonationModel>[].obs;
  late List<String> connecteds =
      profileController.myProfile.connecteds ?? <String>[];

  @override
  void onInit() async {
    initSocket();
    await initUsers();
    fetchDonations();
    super.onInit();
  }

  void clearUserSearch() {
    isUserSearch(false);
    update();
  }

  void clearPostSearch() {
    isPostSearch(false);
    update();
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
        ApiResponseModel responseNot = await ApiService.get(
            path: 'donation/query?isActive=false&isDeleted=false');

        // Clear previous donations before adding new ones
        donationsNotApproved.clear();
        if (responseNot.success) {
          for (int i = 0; i < responseNot.data['rows'].length; i++) {
            if (responseNot.data['rows'][i]['user'] != null) {
              DonationModel donationNot =
                  DonationModel.fromMap(<String, dynamic>{
                ...responseNot.data['rows'][i],
                'likes': responseNot.data['rows'][i]['likes']
                    .map((dynamic like) => like['userId'].toString())
                    .toList(),
              });
              donationsNotApproved.add(donationNot);
            }
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

  Future<void> fetchuserDonations(String userId) async {
    try {
      loading(true); // Set loading to true before fetching data
      update();
      ApiResponseModel response =
          await ApiService.get(path: 'donation/user-donations/$userId');

      if (response.success) {
        userdonations.clear();
        for (int i = 0; i < response.data['rows'].length; i++) {
          if (response.data['rows'] != null) {
            DonationModel userdonation =
                DonationModel.fromMap(<String, dynamic>{
              ...response.data['rows'][i],
              'likes': response.data['rows'][i]['likes']
                  .map((dynamic like) => like['userId'].toString())
                  .toList(),
            });

            userdonations.add(userdonation);
          }
        }
      } else {
        error(true); // Set error to true if there's an error
      }
    } catch (e) {
      error(true); // Set error to true if there's an error
    } finally {
      loading(false); // Set loading back to false after fetching data
    }
    update();
  }

  Future<void> deleteDonation(String donationId) async {
    try {
      ApiResponseModel response =
          await ApiService.delete(path: 'donation/$donationId');

      if (response.success) {
        // Remove the deleted donation from the list
        donations
            .removeWhere((DonationModel donation) => donation.id == donationId);
        donationsNotApproved
            .removeWhere((DonationModel donation) => donation.id == donationId);
        Get.snackbar('Success', 'Donation Deleted Successfully');
      } else {
        Get.snackbar('Error', 'Failed to Delete Donation');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to Delete Donation');
    }
    update();
  }

  bool doesUserDonationExist() {
    final String userId = profileController.myProfile.uid;
    final bool approved = donations.any((DonationModel donation) =>
        donation.user?.uid == userId &&
        donation.amountRecieved < donation.targetAmount!);
    final bool pending = donationsNotApproved
        .any((DonationModel donation) => donation.user?.uid == userId);
    if (pending || approved) {
      return true;
    }
    return false;
  }

  Future<void> fetchDonationTransactions(DonationModel donation) async {
    try {
      tLoading(true); // Set loading to true before fetching data
      ApiResponseModel response = await ApiService.get(
          path: 'donation-transactions/donation/${donation.id}');

      // Clear previous donations before adding new ones
      users.clear();
      times.clear();
      amounts.clear();
      if (response.success) {
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
      }
      tError(false);
    } catch (e) {
      tError(true); // Set error to true if there's an error
    } finally {
      tLoading(false); // Set loading back to false after fetching data
      update();
    }
  }

  Future<void> createDonation(Map<String, dynamic> donation) async {
    ApiResponseModel response =
        await ApiService.post(path: 'donation', body: donation);
    if (response.success) {
      Get.to(() => const DonationCreated());
      donationsNotApproved.add(DonationModel.fromMap(<String, dynamic>{
        ...donation,
        'id': response.data['id'],
        'amountRecieved': 0,
      }));
    }
    update();
  }

  Future<void> updateDonation(Map<String, dynamic> donation, String id) async {
    ApiResponseModel response =
        await ApiService.put(path: 'donation/approve/$id', body: donation);
    if (response.success) {
      final int donationIndex =
          donations.indexWhere((DonationModel donation) => donation.id == id);

      // Update the donation in the list with the updated data
      if (donationIndex != -1) {
        Map<String, dynamic> mergedData = <String, dynamic>{
          ...donations[donationIndex].toMap(),
          ...donation
        };
        donations[donationIndex] = DonationModel.fromMap(mergedData);
      }
      update();
      Get.back();
      Get.snackbar('Success', 'Donation Updated Succesfully!');
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
        final Map<String, dynamic> marketData = <String, dynamic>{
          'industryId': 'donation_id',
          'categoryId': '6463a069-657d-47ae-b937-9a5d4c336811',
          'description': '- Donate to support to a product \n - Find Donations',
          'industry': 'Donation',
          'photo': 'http://44.210.87.234/learningImages/marketplace.jpg',
          'active': true,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        };
        profileController.toggleInterests(Industry.toObject(marketData));
      }
    }
    update();
  }

  Future<void> searchUsers(String query) async {
    loadingSearch(true);
    update();

    searchedUsers.clear();

    for (dynamic user in usersMembers) {
      if (user.username.toLowerCase().contains(query.toLowerCase()) ||
          user.name!.toLowerCase().contains(query.toLowerCase())) {
        searchedUsers.add(user);
      }
    }
    loadingSearch(false);
    update();
  }

  Future<void> searchPosts(String query) async {
    loadingPostsSearch(true);
    update();
    searchedPosts.clear();
    String path = 'donation/all';
    ApiResponseModel response = await ApiService.get(path: path);
    if (response.success) {
      List<dynamic> rows = response.data['rows'];
      for (dynamic row in rows) {
        if (row['userId'] != null) {
          if ((row['title'] != null &&
                  row['title'].toLowerCase().contains(query.toLowerCase())) ||
              (row['user']['username'] != null &&
                  row['user']['username']
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              (row['user']['name'] != null &&
                  row['user']['name']
                      .toLowerCase()
                      .contains(query.toLowerCase())) ||
              (row['description'] != null &&
                  row['description']
                      .toLowerCase()
                      .contains(query.toLowerCase()))) {
            searchedPosts.add(DonationModel.fromMap(<String, dynamic>{
              ...row,
              'likes': row['likes']
                  .map((dynamic like) => like['userId'].toString())
                  .toList(),
            }));
          }
        }
      }
      loadingPostsSearch(false);
      update();
    } else {
      loadingPostsSearch(false);
      update();
    }
  }

  void connectToUser(UserModel user) async {
    final int checkConnected =
        connecteds.indexWhere((String element) => element == user.uid);
    profileController.updateConnections(user.uid);
    update();
    if (isUserSearch.value) {
      final int checkConnectedSearch =
          connecteds.indexWhere((String element) => element == user.uid);
      if (checkConnectedSearch == -1) {
        connecteds.add(user.uid);
      } else {
        connecteds.removeAt(checkConnectedSearch);
      }
    }
    if (checkConnected == -1) {
      connecteds.add(user.uid);
      await connect(user.uid);
    } else {
      connecteds.removeAt(checkConnected);
      await disconnect(user.uid);
    }

    update();
  }

  Future<void> connect(String userId) async {
    await ApiService.post(path: '/connection/connect', body: <String, dynamic>{
      'userId': profileController.myProfile.uid,
      'connectedId': userId,
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> disconnect(String userId) async {
    await ApiService.post(
        path: '/connection/disconnect',
        body: <String, dynamic>{
          'userId': profileController.myProfile.uid,
          'connectedId': userId,
          'timestamp': DateTime.now().millisecondsSinceEpoch
        });
  }

  Future<void> initUsers() async {
    ApiResponseModel response = await ApiService.get(
      path: 'donation/get-joined-users/6463a069-657d-47ae-b937-9a5d4c336811',
    );
    if (response.success) {
      List<dynamic> rows = response.data['rows'];
      userIds
          .addAll(rows.map((dynamic row) => row['userId'].toString()).toList());
      usersMembers.clear();
      for (int i = 0; i < response.data['rows'].length; i++) {
        if (response.data['rows'][i]['user'] != null) {
          UserModel user = UserModel.fromMap(<String, dynamic>{
            ...response.data['rows'][i]['user'],
          });
          usersMembers.add(user);
        }
      }
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
        donations[donationIndex]
            .transactions!
            .add(DonationTransaction.fromMap(<String, dynamic>{
              'id': response.data['id'],
              'date': response.data['date'],
              'amount': data['amount'],
              'description': '',
              'type': 'donated'
            }));
        update();
        return true;
      }
    }
    return false;
  }

  Future<void> claimAmount(DonationModel donationModel) async {
    ApiResponseModel response = await ApiService.put(
        path: 'donation-transactions/claim-reward',
        body: <String, dynamic>{
          'donationId': donationModel.id,
          'userId': profileController.myProfile.uid
        });
    if (response.success) {
      profileController.myProfile
          .incrementCoinsCount(donationModel.amountRecieved);
      showSnackbar(message: 'Withdrawal Successful!');
      Get.back();
    } else {
      showSnackbar(
        title: 'OOPS!',
        message: response.message,
        error: true,
      );
    }
    update();
  }

  Future<void> initHistory() async {
    try {
      hLoading(true); // Set loading to true before fetching data

      ApiResponseModel response = await ApiService.get(
          path:
              'donation-transactions/user/${profileController.myProfile.uid}');
      if (response.success) {
        myHistory.clear();
        myHistoryOut.clear();
        myHistoryReceived.clear();
        final List<dynamic> responseData = response.data['rows'];
        final List<Map<String, dynamic>> mappedData =
            responseData.cast<Map<String, dynamic>>();
        myHistory.addAll(mappedData);
        for (Map<String, dynamic> item in mappedData) {
          if (item['userId'] == profileController.myProfile.uid) {
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
        donations.indexWhere((DonationModel donation) => donation.id == postId);
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
      socket.emit('like', <String, dynamic>{
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'receiverUid': receiverUid,
      });
    } else {
      socket.emit('like', <String, dynamic>{
        'postId': postId,
        'userId': userId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  /// COMMENT FUNCTION
  void comment(String postId, dynamic comment) {
    final int donationIndex =
        donations.indexWhere((DonationModel donation) => donation.id == postId);
    if (donationIndex != -1) {
      donations[donationIndex].comments?.add(comment);
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
