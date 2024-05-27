import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


class ToastUtils {
  ///提示框
  static showToast({
    String? msg,
    Color? backgroundColor,
    TextStyle? textStyle = const TextStyle(color: Colors.white),
  }) async {
    EasyLoading.showToast(msg ?? '');
    // _cancelToast();
  }

  ///加载框
  static showLoading({String? text}) async {
    await EasyLoading.show(
      // status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    // EasyLoading.showProgress(0,status: text ?? '加载中...');
    // _cancelToast();
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   Get.dialog(
    //     Material(
    //       type: MaterialType.transparency,
    //       child: WillPopScope(
    //         onWillPop: onWillPop ?? () => Future.value(false),
    //         child: Center(
    //           child: SizedBox(
    //             width: 120.0,
    //             height: 120.0,
    //             child: Container(
    //               padding: const EdgeInsets.all(15),
    //               decoration: const ShapeDecoration(
    //                 color: Color(0xffffffff),
    //                 shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.all(
    //                     Radius.circular(5.0),
    //                   ),
    //                 ),
    //               ),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   // const Center(
    //                   //   child: LoadingWidget(),
    //                   // ),
    //                   Padding(
    //                     padding: const EdgeInsets.only(top: 5),
    //                     child: Text(
    //                       text ?? '加载中...',
    //                       style: const TextStyle(color: Colors.black),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //     barrierDismissible: false,
    //   );
    // });
  }

  ///关闭Loading
  static close() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  ///成功弹窗提示
  static successToast({String? successText}) {
    EasyLoading.showError(
      successText ?? '成功',
      duration: const Duration(seconds: 2),
    );
    _cancelToast();
  }

  ///失败弹窗提示
  static errorToast({String? errorText}) {
    EasyLoading.showError(
      errorText ?? '错误',
      duration: const Duration(seconds: 2),
    );
    _cancelToast();
  }

  // ///显示对话框
  // static showDialog({
  //   VoidCallback? confirmCallback,
  //   VoidCallback? cancelCallback,
  //   String? titleText,
  //   String? contentText,
  //   String? confirmText,
  //   TextStyle? confirmStyle,
  //   TextStyle? cancelStyle,
  // }) {
  //   _cancelToast();
  //   return Get.dialog(
  //     CustomDialog(
  //       title: titleText ?? '温馨提示',
  //       content: contentText ?? '您确定要退出当前登录吗?',
  //       cancelText: "取消",
  //       confirmText: "确定",
  //       cancelTextStyle: cancelStyle,
  //       confirmTextStyle: confirmStyle,
  //       cancelCall: () {
  //         Get.back();
  //         Future.delayed(const Duration(milliseconds: 50)).then((value) {
  //           if (cancelCallback != null) {
  //             cancelCallback();
  //           }
  //         });
  //       },
  //       confirmCall: () {
  //         Get.back();
  //         if (confirmCallback != null) {
  //           confirmCallback();
  //         }
  //       },
  //     ),
  //   );
  // }

  ///底部自适应高度弹窗
  ///底部弹窗
  static showBottomSheet({
    required BuildContext context,
    bool isTime = false,
    double height = 200,
    Function? onConfirm,
    String? title,
    Widget? contentWidget,
    Widget? header,
    bool isShowConfirm = false,
    Color? barrierColor,
  }) {
    _cancelToast();
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 2,
            ),
            padding: EdgeInsets.only(bottom: 80.h),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              children: [
                header ??
                    Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xffE1E1E1), width: 0.5))),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 6, right: 10),
                              color: Colors.transparent,
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 40,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                title ?? '头部',
                                style: const TextStyle(
                                    color: Color(0xff333333),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isShowConfirm) {
                                if (onConfirm != null) {
                                  onConfirm();
                                  Get.back();
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 10,
                                top: 8,
                                bottom: 8,
                                right: 18,
                              ),
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Text(
                                '确定',
                                style: TextStyle(
                                    color: isShowConfirm
                                        ? const Color(0xff4D6FD5)
                                        : Colors.transparent,
                                    fontSize: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                Expanded(child: contentWidget ?? const SizedBox())
              ],
            ),
          );
        });
    return Get.bottomSheet(
      Container(
        width: double.infinity,
        height: height,
        padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            )),
        child: Column(
          children: [
            header ??
                Container(
                  padding: const EdgeInsets.only(bottom: 5),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Color(0xffE1E1E1), width: 0.5))),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.only(left: 6, right: 10),
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 40,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            title ?? '头部',
                            style: const TextStyle(
                                color: Color(0xff333333),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (isShowConfirm) {
                            if (onConfirm != null) {
                              onConfirm();
                              Get.back();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            top: 8,
                            bottom: 8,
                            right: 18,
                          ),
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          child: Text(
                            '确定',
                            style: TextStyle(
                                color: isShowConfirm
                                    ? const Color(0xff4D6FD5)
                                    : Colors.transparent,
                                fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
            Expanded(child: contentWidget ?? const SizedBox())
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? const Color.fromRGBO(0, 0, 0, 0.2),
    );
  }

  ///错误信息弹窗
  static showExceptionToast({String? title, String? msg}) {
    _cancelToast();
    return Get.snackbar(
      title ?? '错误信息',
      msg ?? '错误信息内容',
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      backgroundColor: Colors.red[800],
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      borderRadius: 4,
      duration: const Duration(seconds: 3),
    );
  }

  static _cancelToast() {
    //  延时2秒
    EasyLoading.dismiss();
  }
}
