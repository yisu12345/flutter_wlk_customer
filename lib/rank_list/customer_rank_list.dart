import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wlk_customer/utils/customer.dart';

class CustomerRankListModel {
  final List<CustomerRankListContent>? content;
  final String? detailTitle;
  final List<CustomerRankDetailContent>? detail;

  CustomerRankListModel({
    this.detailTitle,
    this.content,
    this.detail,
  });
}

class CustomerRankListContent {
  final String? content;
  final TextAlign? textAlign;

  CustomerRankListContent({
    this.content,
    this.textAlign,
  });
}

class CustomerRankDetailContent {
  final String? content;
  final String? label;

  CustomerRankDetailContent({
    this.content,
    this.label,
  });
}

class CustomerRankListWidget extends StatelessWidget {
  // final String? title;
  final Widget? titleWidget;
  final Color? titleBackgroundColor;
  final Color? contentBackgroundColor;
  final List<CustomerRankListContent> titleList;
  final List<CustomerRankListModel>? contentList;
  final double? titleHeight;
  final double? contentHeight;
  final Function? onTap;
  final EdgeInsetsGeometry? padding;
  final double? titleFontSize;
  final double? contentFontSize;

  const CustomerRankListWidget({
    super.key,
    required this.titleList,
    this.contentList,
    this.titleHeight,
    this.contentHeight,
    this.onTap,
    this.padding,
    this.titleWidget,
    this.titleBackgroundColor = Colors.transparent,
    this.contentBackgroundColor = Colors.transparent,
    this.titleFontSize = 34,
    this.contentFontSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 60.w),
      child: Column(
        children: [
          titleWidget ?? const SizedBox(),
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: detailWidget(
              content: titleList,
              isTitle: true,
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                top: 30.h,
                bottom: 16.h,
              ),
              itemBuilder: (_, index) {
                CustomerRankListModel? model = contentList?[index];
                return Column(
                  children: [
                    detailWidget(
                      content: model?.content ?? [],
                      isTitle: false,
                      onTap: () => onTap?.call(model?.content?[1]),
                    ),
                    model?.detail == null
                        ? const SizedBox()
                        : contentDetailListWidget(
                            detailTitle: model?.detailTitle,
                            detail: model?.detail,
                          ),
                  ],
                );
              },
              separatorBuilder: (_, index) {
                return Divider(
                  height: 0.5,
                  color: const Color(0xff399FFF).withOpacity(0.05),
                );
              },
              itemCount: contentList?.length ?? 0,
            ),
          ),
        ],
      ),
    );
  }

  dealContentData({
    required Map<String, dynamic> content,
    required int index,
  }) {
    return [];
  }

  Widget detailWidget({
    required List<CustomerRankListContent?> content,
    required bool isTitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height:
            isTitle == true ? titleHeight?.h ?? 30.h : contentHeight?.h ?? 40.h,
        decoration: BoxDecoration(
          color:
              isTitle != true ? contentBackgroundColor : titleBackgroundColor,
          borderRadius: BorderRadius.circular(10.h),
        ),
        child: Row(
          children: content
              .map(
                (e) => Expanded(
                  child: e?.content?.contains('assets/') == true
                      ? Image.asset(
                          e?.content ?? '',
                          width: contentHeight,
                          height: contentHeight,
                          fit: BoxFit.contain,
                        )
                      : e?.content?.contains('http') == true
                          ? CustomerImagesNetworking(
                              imageUrl: e?.content ?? '',
                              width: contentHeight,
                              height: contentHeight,
                              fit: BoxFit.contain,
                            )
                          : detailText(
                              e?.content ?? '',
                              isTitle: isTitle,
                              textAlign: e?.textAlign,
                            ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget contentDetailListWidget({
    String? detailTitle,
    List<CustomerRankDetailContent>? detail,
  }) {
    return detail?.isEmpty == true
        ? const SizedBox()
        : CustomerContainer(
            color: const Color(0xfff5F5F5),
            borderRadius: 30,
            margin: EdgeInsets.only(left: 60.w, right: 60.w, bottom: 20.h),
            padding: EdgeInsets.all(30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${detailTitle}TOP10',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                spaceHeight10Widget(height: 30),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, index) {
                    CustomerRankDetailContent? detailContent = detail?[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          detailContent?.label ?? '',
                          style: TextStyle(
                            fontSize: contentFontSize,
                          ),
                        ),
                        Text(
                          detailContent?.content ?? '',
                          style: TextStyle(
                            fontSize: contentFontSize,
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, index) {
                    return spaceHeight10Widget(height: 20);
                  },
                  itemCount: detail?.length ?? 0,
                ),
              ],
            ),
          );
  }

  detailText(
    text, {
    bool? isTitle,
    TextAlign? textAlign,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: textAlign == TextAlign.start ? 60.w : 0,
        right: textAlign == TextAlign.end ? 60.w : 0,
      ),
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.center,
        style: TextStyle(
          fontSize: isTitle == true ? titleFontSize : contentFontSize,
        ),
      ),
    );
  }
}
