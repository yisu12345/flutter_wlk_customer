import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_wlk_customer/upload_image/ossUtil.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:images_picker/images_picker.dart';
// import 'package:images_picker/images_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadImagesTool {
  static uploadImagesTool({
    String? oSSAccessKeyId,
    String? policy,
    String? callback,
    String? signature,
    String? ossDirectory,
    String? ossHost,
    required BuildContext context,
    Function? chooseImagesTap,
    int? max,
    bool? isVideo,
  }) async {
    if (Platform.isIOS) {
      await chooseCamera(
        context: context,
        max: max ?? 9,
        oSSAccessKeyId: oSSAccessKeyId ?? '',
        ossHost: ossHost ?? '',
        ossDirectory: ossDirectory ?? '',
        policy: policy ?? '',
        callback: callback ?? '',
        signature: signature ?? '',
        isVideo: isVideo,
        chooseImages: (list) => chooseImagesTap?.call(list),
      );
    } else {
      // bool b = await requestPermission(context);
      // if (b == true) {
      //   await chooseCamera(
      //     context: context,
      //     max: max ?? 9,
      //     oSSAccessKeyId: oSSAccessKeyId ?? '',
      //     ossHost: ossHost ?? '',
      //     ossDirectory: ossDirectory ?? '',
      //     policy: policy ?? '',
      //     callback: callback ?? '',
      //     signature: signature ?? '',
      //     chooseImages: (list) => chooseImagesTap?.call(list),
      //   );
      // }
      await chooseCamera(
        context: context,
        max: max ?? 9,
        isVideo: isVideo,
        oSSAccessKeyId: oSSAccessKeyId ?? '',
        ossHost: ossHost ?? '',
        ossDirectory: ossDirectory ?? '',
        policy: policy ?? '',
        callback: callback ?? '',
        signature: signature ?? '',
        chooseImages: (list) => chooseImagesTap?.call(list),
      );
    }
  }

  /// 动态申请权限，需要区分android和ios，很多时候它两配置权限时各自的名称不同
  /// 此处以保存图片需要的配置为例
  static Future<bool> requestPermission(context) async {
    late PermissionStatus status;
    // 1、读取系统权限的弹框
    if (Platform.isIOS) {
      status = await Permission.photosAddOnly.request();
    } else {
      status = await Permission.camera.request();
    }
    // 2、假如你点not allow后，下次点击不会在出现系统权限的弹框（系统权限的弹框只会出现一次），
    // 这时候需要你自己写一个弹框，然后去打开app权限的页面

    if (status != PermissionStatus.granted) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext ctx) {
            return CupertinoAlertDialog(
              title: const Text('您需要去打开权限'),
              content: const Text('请打开您的相机或者相册权限'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.pop(ctx);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () {
                    openAppSettings();
                    Navigator.pop(ctx);
                    // 打开手机上该app权限的页面
                  },
                ),
              ],
            );
          });
    } else {
      return true;
    }
    return false;
  }

  ///
  static Future<void> chooseCamera({
    required BuildContext context,
    int? max,
    String? oSSAccessKeyId,
    String? policy,
    String? callback,
    String? signature,
    String? ossDirectory,
    String? ossHost,
    Function? chooseImages,
    bool? isVideo,
  }) async {
    //
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext ctx) {
          return isVideo == true
              ? CupertinoActionSheet(
                  title: const Text('上传视频'),
                  message: Text('请选择视频'),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: const Text('视频库'),
                      onPressed: () {
                        openGallery(
                          max: max,
                          oSSAccessKeyId: oSSAccessKeyId ?? '',
                          ossHost: ossHost ?? '',
                          ossDirectory: ossDirectory ?? '',
                          policy: policy ?? '',
                          callback: callback ?? '',
                          signature: signature ?? '',
                          chooseImages: (list) => chooseImages?.call(list),
                        );
                        Get.back();
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    child: const Text('取消'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                )
              : CupertinoActionSheet(
                  title: const Text('上传图片'),
                  message: Text('请选择上传方式\n相册最多${max ?? 9}张'),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: const Text('拍照上传'),
                      onPressed: () {
                        openCamera(
                          oSSAccessKeyId: oSSAccessKeyId ?? '',
                          ossHost: ossHost ?? '',
                          ossDirectory: ossDirectory ?? '',
                          policy: policy ?? '',
                          callback: callback ?? '',
                          signature: signature ?? '',
                          chooseImages: (list) => chooseImages?.call(list),
                        );
                        Get.back();
                      },
                    ),
                    CupertinoActionSheetAction(
                      child: const Text('相册'),
                      onPressed: () {
                        openGallery(
                          max: max,
                          oSSAccessKeyId: oSSAccessKeyId ?? '',
                          ossHost: ossHost ?? '',
                          ossDirectory: ossDirectory ?? '',
                          policy: policy ?? '',
                          callback: callback ?? '',
                          signature: signature ?? '',
                          chooseImages: (list) => chooseImages?.call(list),
                        );
                        Get.back();
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    isDefaultAction: true,
                    child: const Text('取消'),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                );
        });
  }

  //
  static openCamera({
    Function? chooseImages,
    String? oSSAccessKeyId,
    String? policy,
    String? callback,
    String? signature,
    String? ossDirectory,
    String? ossHost,
  }) async {
    XFile? file = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (file == null) {
      Get.back();
    } else {
      String imgPath = await saveNetworkImg(
        file,
        oSSAccessKeyId: oSSAccessKeyId ?? '',
        ossHost: ossHost ?? '',
        ossDirectory: ossDirectory ?? '',
        policy: policy ?? '',
        callback: callback ?? '',
        signature: signature ?? '',
      );
      chooseImages?.call([imgPath]);
    }
  }

  static openGallery({
    Function? chooseImages,
    String? oSSAccessKeyId,
    String? policy,
    String? callback,
    String? signature,
    String? ossDirectory,
    String? ossHost,
    int? max,
    bool? isVideo,
  }) async {
    if (isVideo == true) {
      XFile? video = await ImagePicker().pickMedia();
      String path = await saveNetworkImgGallery(
        video?.path ?? '',
        fileType: 'mp4',
        oSSAccessKeyId: oSSAccessKeyId ?? '',
        ossHost: ossHost ?? '',
        ossDirectory: ossDirectory ?? '',
        policy: policy ?? '',
        callback: callback ?? '',
        signature: signature ?? '',
      );
      chooseImages?.call([path]);
      print('video path ============ $path');
    } else {
      List<XFile>? images = await ImagePicker().pickMultiImage();
      List<String> list = [];
      for (var element in images) {
        String path = await saveNetworkImgGallery(
          element.path,
          oSSAccessKeyId: oSSAccessKeyId ?? '',
          ossHost: ossHost ?? '',
          ossDirectory: ossDirectory ?? '',
          policy: policy ?? '',
          callback: callback ?? '',
          signature: signature ?? '',
        );
        list.add(path);
      }
      chooseImages?.call(list);
    }
  }

  // 保存网络图片
  static Future<String> saveNetworkImg(
    XFile file, {
    String? oSSAccessKeyId,
    String? policy,
    String? callback,
    String? signature,
    String? ossDirectory,
    String? ossHost,
  }) async {
    // print("file.path ===== ${file.path}");
    String string = await UploadOss.upload(
      file.path,
      fileType: "jpg",
      oSSAccessKeyId: oSSAccessKeyId ?? '',
      ossHost: ossHost ?? '',
      ossDirectory: ossDirectory ?? '',
      policy: policy ?? '',
      callback: callback ?? '',
      signature: signature ?? '',
    );
    // print("Gallery ===string== $string");
    return string;
  }

  // 保存网络图片
  static Future<String> saveNetworkImgGallery(
    String path, {
    String? fileType,
    String? oSSAccessKeyId,
    String? policy,
    String? callback,
    String? signature,
    String? ossDirectory,
    String? ossHost,
  }) async {
    String string = await UploadOss.upload(
      path,
      fileType: fileType ?? "jpg",
      oSSAccessKeyId: oSSAccessKeyId ?? '',
      ossHost: ossHost ?? '',
      ossDirectory: ossDirectory ?? '',
      policy: policy ?? '',
      callback: callback ?? '',
      signature: signature ?? '',
    );
    return string;
  }
}
