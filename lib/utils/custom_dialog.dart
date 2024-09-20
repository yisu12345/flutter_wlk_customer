import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///@Author ouyangyan
///@Time 2023/3/1 13:43
///自定义对话框
class CustomDialog extends Dialog {
  final String title; //标题
  final String content; //内容
  final String cancelText; //"取消" 按钮文字
  final String confirmText; //"确定" 按钮文字
  final VoidCallback cancelCall; //取消按钮回调
  final VoidCallback confirmCall; //确定按钮回调
  final TextStyle? cancelTextStyle; //"取消" 按钮文字
  final TextStyle? confirmTextStyle; //"确定" 按钮文字

  const CustomDialog({
    required this.title,
    required this.content,
    required this.cancelText,
    required this.confirmText,
    required this.cancelCall,
    required this.confirmCall,
    this.cancelTextStyle,
    this.confirmTextStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      title,
                      textWidthBasis: TextWidthBasis.parent,
                      style: const TextStyle(
                        color: Color(0xff222222),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 12,
                      bottom: 20,
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xff999999),
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                  lineWidget(height: 0.5),
                  _bottomButtonGroupWidget(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///底部按钮组
  Widget _bottomButtonGroupWidget() {
    return Row(
      children: [
        Expanded(
          child: buttonWidget(
            title: cancelText,
            callback: cancelCall,
            textStyle: cancelTextStyle ??
                const TextStyle(
                  color: Color(0xff888888),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        lineWidget(width: 0.5, height: 50),
        Expanded(
          child: buttonWidget(
            title: confirmText,
            callback: confirmCall,
            textStyle: confirmTextStyle ??
                const TextStyle(
                  color: Color(0xffFF4D1A),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  ///按钮共用
  Widget buttonWidget({
    required String title,
    required TextStyle textStyle,
    required VoidCallback callback,
  }) {
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(title, style: textStyle),
      ),
    );
  }

  ///线
  Widget lineWidget({
    double? width,
    double? height,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      color: const Color(0xffe9e9e9),
      height: height,
      margin: margin,
    );
  }
}