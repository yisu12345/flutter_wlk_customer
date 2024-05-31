import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wlk_customer/utils/customer.dart';

///上下结构的文字
///title、unit上
///content、unit下
class CustomerTitleAndContentWidget extends StatelessWidget {
  final String title;
  final FontWeight? titleFontWeight;
  final double? titleFontSize;
  final Color? titleColor;
  final String? unitTitle;
  final FontWeight? unitTitleFontWeight;
  final double? unitTitleFontSize;
  final Color? unitTitleColor;
  final String content;
  final FontWeight? contentFontWeight;
  final double? contentFontSize;
  final Color? contentColor;
  final String? unitContent;
  final FontWeight? unitContentFontWeight;
  final double? unitContentFontSize;
  final Color? unitContentColor;
  final CrossAxisAlignment? crossAxisAlignment;
  final MainAxisAlignment? mainAxisAlignment;
  final double? spaceHeight;

  const CustomerTitleAndContentWidget({
    super.key,
    required this.title,
    required this.content,
    this.titleFontWeight,
    this.titleColor,
    this.titleFontSize,
    this.contentFontWeight,
    this.contentFontSize,
    this.contentColor,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    this.unitContent,
    this.unitContentFontWeight,
    this.unitContentFontSize,
    this.unitContentColor,
    this.spaceHeight = 10,
    this.unitTitle,
    this.unitTitleFontWeight,
    this.unitTitleFontSize,
    this.unitTitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: unitTitle,
                style: CustomerTextStyle(
                  customerFontSize: unitTitleFontSize,
                  customerColor: unitContentColor ?? const Color(0xff399FFF),
                  customerFontWeight: unitTitleFontWeight ?? FontWeight.normal,
                ),
              ),
              TextSpan(
                text: title,
                style: CustomerTextStyle(
                  customerFontSize: titleFontSize,
                  customerColor: titleColor ?? const Color(0xff1A1A1A),
                  customerFontWeight: titleFontWeight ?? FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: spaceHeight?.h ?? 30.h),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: content,
                style: TextStyle(
                  fontSize: contentFontSize,
                  color: contentColor ?? const Color(0xff399FFF),
                  fontWeight: contentFontWeight ?? FontWeight.normal,
                ),
              ),
              TextSpan(
                text: unitContent,
                style: TextStyle(
                  fontSize: unitContentFontSize,
                  color: unitContentColor ?? const Color(0xff399FFF),
                  fontWeight: unitContentFontWeight ?? FontWeight.normal,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
