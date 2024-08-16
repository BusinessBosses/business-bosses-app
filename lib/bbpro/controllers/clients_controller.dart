import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ClientsController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Client> clients = RxList<Client>(<Client>[]);

  Future<void> initClients(String userId) async {
    clients.clear();
    ApiResponseModel response = await ApiService.get(path: 'clients/all');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        clients.add(Client.fromMap(response.data['rows'][i]));
      }
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
      clients.add(newClient);
      return true;
    } else {
      return false;
    }
  }

  @override
  void onInit() {
    initClients(profileController.myProfile.uid);
    super.onInit();
  }
}
