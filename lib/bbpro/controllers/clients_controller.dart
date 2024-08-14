import 'package:business_bosses_v2/bbpro/models/client_model.dart';
import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/profile/controller/profile_controller.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class ClientsController extends GetxController {
  final ProfileController profileController = Get.find();
  RxList<Client> clients = RxList<Client>(<Client>[]);

  Future<void> initClients(String userId) async {
    ApiResponseModel response = await ApiService.get(path: 'tasks/all');
    if (response.success) {
      for (int i = 0; i < response.data['rows'].length; i++) {
        clients.add(Client.fromMap(response.data['rows'][i]));
      }
      print(clients);
    }
  }

  Future<bool> addClient(Map<String, dynamic> data) async {
    ApiResponseModel response =
        await ApiService.post(path: 'projects', body: data);
    if (response.success) {
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
