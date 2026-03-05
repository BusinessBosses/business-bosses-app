import 'package:business_bosses_v2/bbpro/models/campaign_model.dart';
import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientsController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Client> clients = RxList<Client>(<Client>[]);
  RxBool loading = RxBool(true);
  RxBool cLoading = RxBool(true);
  final Map<ClientType, List<Client>> clientsType =
      <ClientType, List<Client>>{};
  final List<Client> allclients = <Client>[];
  final List<Campaign> campaigns = <Campaign>[];
  final GetStorage sandBox = GetStorage();

  Future<void> initClients(String userId) async {
    final dynamic cachedClients = sandBox.read('user_clients_$userId');
    if (cachedClients != null) {
      _processClientsData(cachedClients);
      loading.value = false;
      update();
    } else {
      loading(true);
    }

    ApiResponseModel response =
        await ApiService.get(path: 'clients/user-clients/$userId');
    if (response.success) {
      await sandBox.write('user_clients_$userId', response.data);
      _processClientsData(response.data);
    }
    loading(false);
    update();
  }

  void _processClientsData(dynamic data) {
    clients.clear();
    allclients.clear();
    for (int i = 0; i < data['rows'].length; i++) {
      clients.add(Client.fromMap(data['rows'][i]));
    }
    for (ClientType clientType in ClientType.values) {
      clientsType[clientType] = <Client>[];
    }
    for (ClientType clientType in ClientType.values) {
      List<Client> filteredClients =
          clients.where((Client client) => client.type == clientType).toList();
      clientsType[clientType] = filteredClients;
      allclients.addAll(filteredClients);
    }
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
      clients.add(
          newClient); // Add the new client to the appropriate ClientType list
      ClientType clientType = newClient.type;

      clientsType[clientType]!.add(newClient);

      // Update the UI
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendCampaign(Map<String, dynamic> data) async {
    ApiResponseModel response = await ApiService.post(
        path: 'client-notifications/broadcast', body: data);
    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> initCampaigns(String userId) async {
    final dynamic cachedCampaigns = sandBox.read('user_campaigns_$userId');
    if (cachedCampaigns != null) {
      _processCampaignsData(cachedCampaigns);
      loading.value = false;
      update();
    } else {
      loading(true);
    }

    ApiResponseModel response =
        await ApiService.get(path: 'campaign-history/user/$userId');
    if (response.success) {
      await sandBox.write('user_campaigns_$userId', response.data);
      _processCampaignsData(response.data);
    }
    loading(false);
    update();
  }

  void _processCampaignsData(dynamic data) {
    campaigns.clear();
    for (int i = 0; i < data.length; i++) {
      campaigns.add(Campaign.fromMap(data[i]));
    }
  }

  Future<void> deleteCampaign(int id) async {
    loading(true);
    ApiResponseModel response =
        await ApiService.delete(path: 'campaign-history/$id');
    if (response.success) {
      campaigns.removeWhere((Campaign element) => element.id == id);
    }
    update();
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
      // log(response.toMap().toString());
      return false;
    }
  }

  Future<bool> deleteClient(String id) async {
    Client? deletedClient =
        clients.firstWhereOrNull((Client element) => element.id == id);
    ApiResponseModel response = await ApiService.delete(path: 'clients/$id');
    if (response.success) {
      if (deletedClient != null) {
        ClientType clientType = deletedClient.type;
        if (clientsType.containsKey(clientType)) {
          clientsType[clientType]!.remove(deletedClient);

          // If the ClientType list is empty, optionally remove it from the map
          if (clientsType[clientType]!.isEmpty) {
            clientsType.remove(clientType);
          }
        }
      }
      clients.removeWhere((Client element) => element.id == id);

      update();
      return true;
    } else {
      // log(response.toMap().toString());
      return false;
    }
  }

  @override
  void onInit() {
    initClients(profileController.myProfile.uid);
    initCampaigns(profileController.myProfile.uid);
    super.onInit();
  }
}
