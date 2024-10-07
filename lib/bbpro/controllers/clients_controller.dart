import 'dart:developer';

import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ClientsController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Client> clients = RxList<Client>(<Client>[]);
  RxBool loading = RxBool(true);

  Future<void> initClients(String userId) async {
    loading(true);
    clients.clear();
    ApiResponseModel response =
        await ApiService.get(path: 'clients/user-clients/$userId');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        clients.add(Client.fromMap(response.data['rows'][i]));
      }
    }
    loading(false);
    update();
  }

  Future<bool> addClient(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'clients', body: data);
    if (response.success) {
      // Convert the response data to a Client object and add it to the list
      Client newClient = Client.fromMap(<String, dynamic>{
        'id': response.data['id'],
        ...response.data,
      });
      clients.add(newClient);
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateClient(String id, Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.put(path: 'clients/$id', body: data);
    if (response.success) {
      final int clientIndex =
          clients.indexWhere((Client element) => element.id == id);
      clients[clientIndex] = Client.fromMap(response.data);
      update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  Future<bool> deleteClient(String id) async {
    ApiResponseModel response = await ApiService.delete(path: 'clients/$id');
    if (response.success) {
      clients.removeWhere((Client element) => element.id == id);
      update();
      return true;
    } else {
      log(response.toMap().toString());
      return false;
    }
  }

  @override
  void onInit() {
    initClients(profileController.myProfile.uid);
    super.onInit();
  }
}
