
import 'package:flutter/material.dart';
import 'package:flutter_wlk_customer/utils/customer.dart';

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
                  customerFontSize: unitTitleFontSize ?? 30,
                  customerColor: unitContentColor ?? const Color(0xff399FFF),
                  customerFontWeight: unitTitleFontWeight ?? FontWeight.normal,
                ),
              ),
              TextSpan(
                text: title,
                style: CustomerTextStyle(
                  customerFontSize: titleFontSize ?? 28,
                  customerColor: titleColor ?? const Color(0xff1A1A1A),
                  customerFontWeight: titleFontWeight ?? FontWeight.normal,
                ),
              ),

            ],
          ),
        ),
        spaceHeight10Widget(height: spaceHeight),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: content,
                style: CustomerTextStyle(
                  customerFontSize: contentFontSize ?? 30,
                  customerColor: contentColor ?? const Color(0xff399FFF),
                  customerFontWeight: contentFontWeight ?? FontWeight.normal,
                ),
              ),
              TextSpan(
                text: unitContent,
                style: CustomerTextStyle(
                  customerFontSize: unitContentFontSize ?? 30,
                  customerColor: unitContentColor ?? const Color(0xff399FFF),
                  customerFontWeight: unitContentFontWeight ?? FontWeight.normal,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
