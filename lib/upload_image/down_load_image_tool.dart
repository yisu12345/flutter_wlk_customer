import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
  static void savePhoto({required String imageUrl}) async {
    //获取保存相册权限，如果没有，则申请改权限
    bool permition = await getPormiation();

    var status = await Permission.photos.status;
    if (permition) {
      if (Platform.isIOS) {
        if (status.isGranted) {
          var result =  imageRequest(imageUrl: imageUrl);
          ToastUtils.showToast(msg: "保存成功");
        }
        if (status.isDenied) {
          print("IOS拒绝");
        }
      } else {
        //安卓
        if (status.isGranted) {
          var result = imageRequest(imageUrl: imageUrl);
          // EasyLoading.showToast("保存成功");
          ToastUtils.showToast(msg: "保存成功");
        }
      }
    } else {
      //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
      savePhoto(imageUrl: imageUrl);
    }
  }

  static Future<dynamic> imageRequest({required String imageUrl}) async {
    var response = await Dio().get(
      imageUrl,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");
    return result;
  }
}
