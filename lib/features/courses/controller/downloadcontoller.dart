import 'package:get/get.dart';

class DownloadController extends GetxController {
  double downloadProgress = 0;

  void updateprogress(int progress) {
    var progresss = (progress / 100).toDouble();

    downloadProgress = progresss;

    update();

    print(downloadProgress);
  }

  // void downloadCallback(String id, int status, int progress) {
  //   print(
  //       'Download task ($id) is in status ($status) and progress (${progress / 100})');

  //   var progresss = (progress / 100).toDouble();

  //   downloadProgress = progresss;

  //   update();
  // }
}
