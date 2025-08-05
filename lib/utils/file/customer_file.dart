import 'package:flutter/material.dart';
import 'package:flutter_wlk_customer/utils/file/webview/customer_pdf.dart';
import 'package:flutter_wlk_customer/utils/file/webview/customer_webview.dart';
import 'package:flutter_wlk_customer/utils/toast_utils.dart';
import 'play/video_play_page.dart';

enum OpenType {
  file, //文件
  image, //图片
  video, //视频
  url, //网址
}

class CustomerFile {
  static Future<void> openTypeFile({
    required OpenType type,
    required BuildContext context,
    required int isLock,
    required String filePath,
    String? fileName,
  }) async {
    if (filePath == "" || filePath == null) {
      ToastUtils.showToast(msg: "暂无内容");
    } else {
      if (type == OpenType.file) {
        CustomerAction.openFileAction(
          context: context,
          filePath: filePath,
          fileName: fileName,
        );
      }
      if (type == OpenType.video) {
        CustomerAction.openVideoAction(
          context: context,
          videoUrl: filePath,
        );
      }
    }
  }
}

///公共方法
class CustomerAction {
  ///打开文件
  static Future<void> openFileAction({
    required BuildContext context,
    required String filePath,
    String? fileName,
  }) async {
    if (filePath == "") {
      ToastUtils.showToast(msg: "暂无文件");
    } else {
      if (filePath.contains("http")) {
        // showDialog(
        //     context: context,
        //     builder: (BuildContext ctx) {
        //
        //       // return CustomerPDFPage(
        //       //   filePath: filePath,
        //       // );
        //     });
      } else {
        ToastUtils.showToast(msg: "地址无效");
      }
    }
  }

  static _dealFileName(String filePath) {
    return "${DateTime.now()}.${filePath.split(".").last}";
  }

  ///打开视频
  static Future<void> openVideoAction({
    required BuildContext context,
    required String videoUrl,
  }) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: VideoPlayPage(
              videoUrl: videoUrl,
            ),
          );
        });
  }

  ///打开网页
  // static Future<void> openWebview({
  //   required BuildContext context,
  //   required String url,
  // }) async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext ctx) {
  //       return CustomerWebView(url: url);
  //     },
  //   );
  // }

  static Future<void> openTypeFile({
    required OpenType type,
    required BuildContext context,
    required int isLock,
    required String filePath,
    String? fileName,
  }) async {
    if (filePath == "" || filePath == null) {
      ToastUtils.showToast(msg: "暂无内容");
    } else {
      if (type == OpenType.file) {
        CustomerAction.openFileAction(
          context: context,
          filePath: filePath,
          fileName: fileName,
        );
      }
      if (type == OpenType.video) {
        CustomerAction.openVideoAction(
          context: context,
          videoUrl: filePath,
        );
      }
    }
  }
}
