import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:crypto/crypto.dart';
import "package:dio/dio.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadOss {

  /*
   * @params file 要上传的文件对象
   * @params rootDir 阿里云oss设置的根目录文件夹名字
   * @param fileType 文件类型例如jpg,mp4等
   * @param callback 回调函数我这里用于传cancelToken，方便后期关闭请求
   * @param onSendProgress 上传的进度事件
   */

  static Future<String> upload(
    String path, {
    String rootDir = "moment",
    required String fileType,
    required String oSSAccessKeyId,
    required String policy,
    required String callback,
    required String signature,
    required String ossDirectory,
    required String ossHost,
  }) async {
    // 生成oss的路径和文件名我这里目前设置的是moment/20201229/test.mp4
    String pathName = "$rootDir/${getDate()}/app-${getRandom(12)}.$fileType";

    // 请求参数的form对象
    FormData formdata = FormData.fromMap({
      'OSSAccessKeyId': oSSAccessKeyId,
      'policy': policy,
      'callback': callback,
      'signature': signature,
      'key': '$ossDirectory$pathName',
      //上传后的文件名
      'success_action_status': '200',
      'file': MultipartFile.fromFileSync(path),
    });
    await EasyLoading.show(
      // status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    Dio dio = Dio();
    dio.options.responseType = ResponseType.plain;
    dio.options.contentType = "multipart/form-data";
    try {
      // 发送请求
      Response response = await dio.post(
        ossHost,
        data: formdata,
      );
      EasyLoading.dismiss();
      // 成功后返回文件访问路径
      return "$ossHost/$ossDirectory$pathName";
    } on DioError catch (e) {
      EasyLoading.dismiss();
      print("e.message ===== ${e.message}");
      print("e.data ===== ${e.response?.data}");
      // print("e.headers ===== ${e.response?.headers}");
      // print("e.extra ===== ${e.response?.extra}");
      return '';
    }
  }

  /*
  * 生成固定长度的随机字符串
  * */
  static String getRandom(int num) {
    String alphabet = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
    String left = "";
    for (var i = 0; i < num; i++) {
//    right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }

  /// 获取日期
  static String getDate() {
    DateTime now = DateTime.now();
    return "${now.year}${now.month}${now.day}";
  }

}

class UploadWidgetOss {
  static Future<String> uploadWidgetImage(
    GlobalKey globalKey, {
    required String oSSAccessKeyId,
    required String policy,
    required String callback,
    required String signature,
    required String ossDirectory,
    required String ossHost,
  }) async {
    ///通过globalkey将Widget保存为ui.Image
    ui.Image _image = await getImageFromWidget(globalKey);

    ///异步将这张图片保存在手机内部存储目录下
    String? localImagePath = await saveImageByUIImage(_image, isEncode: false);

    ///保存完毕后关闭当前页面并将保存的图片路径返回到上一个页面
    String? url = await UploadOss.upload(
      localImagePath,
      fileType: "png",
      oSSAccessKeyId: oSSAccessKeyId,
      policy: policy,
      callback: callback,
      signature: signature,
      ossDirectory: ossDirectory,
      ossHost: ossHost,
    );
    return url;
  }

  // 将一个Widget转为image.Image对象
  static Future<ui.Image> getImageFromWidget(GlobalKey globalKey) async {
    // globalKey为需要图像化的widget的key
    RenderRepaintBoundary? boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    // 转换为图像
    ui.Image img = await boundary!.toImage(pixelRatio: 2);
    return img;
  }

  ///将指定的文件保存到目录空间中。
  ///[image] 这里是使用的ui包下的Image
  ///[picName] 保存到本地的文件（图片）文件名，如test_image
  ///[endFormat]保存到本地的文件（图片）文件格式，如png，
  ///[isReplace]当本地存在同名的文件（图片）时，true就是替换
  ///[isEncode]对保存的文件（图片）进行编码
  ///  最终保存到本地的文件 （图片）的名称为 picName.endFormat
  static Future<String> saveImageByUIImage(ui.Image image,
      {String? picName,
      String endFormat = "png",
      bool isReplace = true,
      bool isEncode = true}) async {
    ///获取本地磁盘路径
    /*
     * 在Android平台中获取的是/data/user/0/com.studyyoun.flutterbookcode/app_flutter
     * 此方法在在iOS平台获取的是Documents路径
     */
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    ///拼接目录
    if (picName == null || picName.trim().isEmpty) {
      ///当用户没有指定picName时，取当前的时间命名
      picName = "${DateTime.now().millisecond.toString()}.$endFormat";
    } else {
      picName = "$picName.$endFormat";
    }

    if (isEncode) {
      ///对保存的图片名字加密
      picName = md5.convert(utf8.encode(picName)).toString();
    }

    appDocPath = "$appDocPath/$picName";

    ///校验图片是否存在
    var file = File(appDocPath);
    bool exist = await file.exists();
    if (exist) {
      if (isReplace) {
        ///如果图片存在就进行删除替换
        ///如果新的图片加载失败，那么旧的图片也被删除了
        await file.delete();
      } else {
        ///如果图片存在就不进行下载
        return "";
      }
    }
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    ///将Uint8List的数据格式保存
    await File(appDocPath).writeAsBytes(pngBytes);

    return appDocPath;
  }

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
  static void savePhoto(GlobalKey globalKey) async {
    RenderRepaintBoundary? boundary =
        globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;

    double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
    var image = await boundary!.toImage(pixelRatio: dpr);
    // 将image转化成byte
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    //获取保存相册权限，如果没有，则申请改权限
    bool permition = await getPormiation();

    var status = await Permission.photos.status;
    if (permition) {
      if (Platform.isIOS) {
        if (status.isGranted) {
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaverPlus.saveImage(images,
              quality: 60, name: "hello");
          // EasyLoading.showToast("保存成功");
          ToastUtils.showToast(msg: "保存成功");
        }
        if (status.isDenied) {
          print("IOS拒绝");
        }
      } else {
        //安卓
        if (status.isGranted) {
          print("Android已授权");
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaverPlus.saveImage(images, quality: 60);
          if (result != null) {
            // EasyLoading.showToast("保存成功");
            ToastUtils.showToast(msg: "保存成功");
          } else {
            print('error');
            // toast("保存失败");
          }
        }
      }
    } else {
      //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
      savePhoto(globalKey);
    }
  }
}
