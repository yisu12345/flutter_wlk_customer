import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class DownLoadImageTool {
  //申请存本地相册权限
  static Future<bool> getPormiation() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
        ].request();
        // saveImage(globalKey);
      }
      return status.isGranted;
    } else {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
      }
      return status.isGranted;
    }
  }

  ///保存到相册
  static Future<dynamic> savePhoto({
    required String imageUrl,
    bool? isHideLoading,
  }) async {
    //获取保存相册权限，如果没有，则申请改权限
    bool permition = await getPormiation();

    var status = await Permission.photos.status;
    if (permition) {
      if (Platform.isIOS) {
        if (status.isGranted) {
          var result = imageRequest(
            imageUrl: imageUrl,
            isHideLoading: isHideLoading,
          );
          return result;
        }
        if (status.isDenied) {
          print("IOS拒绝");
        }
      } else {
        //安卓
        if (status.isDenied) {
          var result = imageRequest(
            imageUrl: imageUrl,
            isHideLoading: isHideLoading,
          );
          return result;
        }
      }
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
        name: "hello");
    print('=result ============ $result');
    return result;
  }
}
