import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/models/my_response.dart';
import '../utils/constants/constants.dart';

class MyNativeFunctions {
  static Future<MyResponse> onImagePick(ImageSource imageSource) async {
    MyResponse res;
    File image;
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedImage = await picker.pickImage(source: imageSource);
      if (pickedImage != null) {
        image = File(pickedImage.path);
        res = MyResponse(success: true, message: 'Image picked', data: image);
        return res;
      } else {
        res = MyResponse(success: false, message: 'Image not selected');
        return res;
      }
    } catch (e) {
      res = MyResponse(success: false, message: e.toString());
      return res;
    }
  }

  static Future<MyResponse> onMultiPicker(
      {required FileType type,
      required List<String> allowedExtension,
      allowMultiple = true}) async {
    MyResponse res;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtension,
        allowMultiple: true,
      );
      if (result != null) {
        res = MyResponse(
          success: true,
          message: 'File picked',
          data: result,
        );
        return res;
      } else {
        return res = MyResponse(
          success: true,
          message: 'No image selected',
        );
      }
    } catch (e) {
      res = MyResponse(success: false, message: e.toString());
      return res;
    }
  }

  static List<File> toImageFile(FilePickerResult result) {
    List<File> files = [];
    if (result != null) {
      List<PlatformFile> platformFiles = result.files;
      for (PlatformFile plf in platformFiles) {
        files.add(File(plf.path.toString()));
      }
      return files;
    } else {
      return [];
    }
  }

  static Future<MyResponse> onUrlLaunch(String urlString) async {
    try {
      await canLaunchUrlString(urlString)
          ? await launchUrlString(urlString)
          : throw 'Invalid url $urlString';
      return MyResponse(success: true);
    } catch (e) {
      return MyResponse(success: false, message: e.toString());
    }
  }

  static String completeURL(String url, MyUrl myUrl) {
    String cUrl = url.toLowerCase();
    if (myUrl == MyUrl.twitter) {
      if (cUrl.contains(Constants.TWITTER_BASE_URL)) return cUrl;
      return Constants.TWITTER_BASE_URL + cUrl;
    } else if (myUrl == MyUrl.instagram) {
      if (cUrl.contains(Constants.INSTAGRAM_BASE_URL)) return cUrl;

      return Constants.INSTAGRAM_BASE_URL + cUrl;
    } else {
      if (cUrl.contains(Constants.HTTPS_WWW)) {
        return cUrl;
      } else if (cUrl.contains('www.')) {
        return 'https://$cUrl';
      } else {
        return 'https://www.$cUrl';
      }
    }
  }
}

enum MyUrl { twitter, instagram, url }
