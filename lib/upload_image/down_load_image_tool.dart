import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class DownLoadImageTool {

  // 请求照片库权限
  static Future<bool> requestPhotoPermission() async {
    // 检查当前权限状态
    var status = await Permission.photos.status;

    if (status.isDenied) {
      // 请求权限
      status = await Permission.photos.request();

      // 如果用户拒绝了权限，可以显示一个解释
      if (status.isPermanentlyDenied) {
        // 打开应用设置，让用户手动启用权限
        await openAppSettings();
      }

      if (status.isDenied) {
        // 打开应用设置，让用户手动启用权限
        await openAppSettings();
      }
    }

    return status.isGranted;
  }

  // 或者请求存储权限（适用于Android）
  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      // 对于Android 13及以上版本
      if (await DeviceInfoPlugin().androidInfo.then((info) => info.version.sdkInt) >= 33) {
        var status = await Permission.photos.request();
        if(status == PermissionStatus.denied){
          await requestPhotoPermission();
        }
        return status.isGranted;
      } else {
        // 对于Android 13以下版本
        var status = await Permission.storage.request();
        return status.isGranted;
      }
    } else {
      // iOS使用照片权限
      return await requestPhotoPermission();
    }
  }

  ///保存到相册
  static Future<dynamic> savePhoto({
    required String imageUrl,
    bool? isHideLoading,
  }) async {
    //获取保存相册权限，如果没有，则申请改权限
    bool permition = await requestStoragePermission();
    if (permition) {
      var result = imageRequest(
        imageUrl: imageUrl,
        isHideLoading: isHideLoading,
      );
      return result;
    } else {
      //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
      ToastUtils.showToast(msg: '请打开手机相册权限');
      // savePhoto(imageUrl: imageUrl);
    }
  }

  static Future<dynamic> imageRequest({
    required String imageUrl,
    bool? isHideLoading,
  }) async {
    if (isHideLoading == true) {
    } else {
      await EasyLoading.show(
        // status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
    }

    var response = await Dio().get(
      imageUrl,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    if (isHideLoading == true) {
    } else {
      EasyLoading.dismiss();
    }

    final result = await ImageGallerySaverPlus.saveImage(
      Uint8List.fromList(response.data),
      quality: 60,
      name: "hello",
      isReturnImagePathOfIOS: true,
    );
    print('=result ============ $result');
    return result;
  }

  ///fetchImageAsUint8List
  static Future<Uint8List?> fetchImageAsUint8List(String imageUrl) async {
    await EasyLoading.show(
      // status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      var response = await Dio().get(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      // final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        EasyLoading.dismiss();
        return response.data;
      } else {
        // debugPrint('Failed to load image: ${response.statusCode}');
        EasyLoading.dismiss();
        return null;
      }

    } catch (e) {
      EasyLoading.dismiss();
      // debugPrint('Error fetching image: $e');
      return null;
    }
  }
}
