import 'package:business_bosses_v2/common/models/api_response_model.dart';
import 'package:business_bosses_v2/features/donations/models/donations_model.dart';
import 'package:business_bosses_v2/services/api_service.dart';
import 'package:get/get.dart';

class DonationsController extends GetxController {
  RxList<DonationModel> donations = <DonationModel>[].obs;
  RxBool loading = RxBool(false);
  RxBool error = RxBool(false);

  @override
  void onInit() {
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
      donations.add(DonationModel.fromMap(donation));
      update();
      Get.back();
      Get.snackbar('Success', 'Donations Created Successfully');
    }
  }
}
