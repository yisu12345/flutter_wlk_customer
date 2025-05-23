import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wlk_customer/utils/custom_dialog.dart';
import 'package:get/get.dart';

// import 'package:get/get.dart';

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
  }

  ///成功弹窗提示
  static successToast({String? successText}) {
    EasyLoading.showError(
      successText ?? '成功',
      duration: const Duration(seconds: 2),
    );
    cancelToast();
  }

  ///失败弹窗提示
  static errorToast({String? errorText}) {
    EasyLoading.showError(
      errorText ?? '错误',
      duration: const Duration(seconds: 2),
    );
    cancelToast();
  }

  ///底部自适应高度弹窗
  ///底部弹窗
  static showBottomSheet({
    required BuildContext context,
    bool isTime = false,
    double? height,
    Function? onConfirm,
    String? title,
    double? titleFontSize,
    double? leftIconSize,
    Widget? contentWidget,
    Widget? header,
    bool isShowConfirm = false,
    Color? barrierColor,
  }) {
    cancelToast();
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            margin: EdgeInsets.only(
              top: height == null
                  ? MediaQuery.of(context).size.height / 2
                  : (MediaQuery.of(context).size.height - height),
            ),
            padding: const EdgeInsets.only(bottom: 40),
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
                          bottom:
                              BorderSide(color: Color(0xffE1E1E1), width: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 6, right: 10),
                              color: Colors.transparent,
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: leftIconSize ?? 40,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                title ?? '头部',
                                style: TextStyle(
                                  color: const Color(0xff333333),
                                  fontSize: titleFontSize ?? 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (isShowConfirm) {
                                if (onConfirm != null) {
                                  onConfirm();
                                  Navigator.pop(context);
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
  }

  static cancelToast() {
    //  延时2秒
    EasyLoading.dismiss();
  }

  ///显示对话框
  static showAlterDialog({
    VoidCallback? confirmCallback,
    VoidCallback? cancelCallback,
    String? titleText,
    String? contentText,
    String? confirmText,
    TextStyle? confirmStyle,
    TextStyle? cancelStyle,
  }) {
    cancelToast();
    return Get.dialog(
      CustomDialog(
        title: titleText ?? '温馨提示',
        content: contentText ?? '您确定要退出当前登录吗?',
        cancelText: "取消",
        confirmText: "确定",
        cancelTextStyle: cancelStyle,
        confirmTextStyle: confirmStyle,
        cancelCall: () {
          Get.back();
          Future.delayed(const Duration(milliseconds: 50)).then((value) {
            if (cancelCallback != null) {
              cancelCallback();
            }
          });
        },
        confirmCall: () {
          Get.back();
          if (confirmCallback != null) {
            confirmCallback();
          }
        },
      ),
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
  ///取消弹窗
  static _cancelToast() {
    // Toast.dismissAllToast();
  }
}
