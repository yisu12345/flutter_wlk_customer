import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:transparent_image/transparent_image.dart';

///字体样式
TextStyle customerTextStyle({
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  TextDecoration? decoration,
  Color? decorationColor,
}) {
  return TextStyle(
    color: color ?? const Color(0xff333333),
    fontSize: fontSize?.sp ?? 16.sp,
    fontWeight: fontWeight ?? FontWeight.normal,
    decoration: decoration,
    decorationColor: decorationColor,
  );
}

///基础 Container
Widget customerContainer({
  Color? color,
  double? borderRadius,
  Widget? child,
  EdgeInsetsGeometry? padding,
  EdgeInsetsGeometry? margin,
  double? height,
  Gradient? gradient,
  DecorationImage? image,
  VoidCallback? onTap,
  List<BoxShadow>? boxShadow,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius?.h ?? 10.h),
        gradient: gradient,
        image: image,
        boxShadow: boxShadow,
      ),
      child: child,
    ),
  );
}

///图片加载
Widget customerImagesNetworking({
  required String imageUrl,
  double? width,
  double? height,
  BoxFit? fit,
  Widget? errorWidget,
}) {
  return imageUrl.contains('http') == true
      ? FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          width: width,
          height: height,
          image: imageUrl,
          fit: fit,
          placeholderErrorBuilder: (_, Object object, StackTrace? stackTrace) {
            return errorWidget ?? const SizedBox();
          },
          imageErrorBuilder: (_, Object object, StackTrace? stackTrace) {
            return errorWidget ?? const SizedBox();
          },
        )
      : errorWidget ?? const SizedBox();
}

///money字体样式
Widget customerMoneyText({
  required String money,
  double? moneyFontSize,
  Color? moneyColor,
  FontWeight? moneyFontWeight,
  String? unit,
  double? unitFontSize,
  Color? unitColor,
  FontWeight? unitFontWeight,
  String? rightUnit,
  double? rightUnitFontSize,
  Color? rightUnitColor,
  FontWeight? rightUnitFontWeight,
}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: unit ?? '',
          style: customerTextStyle(
            color: unitColor ?? const Color(0xff333333),
            fontSize: unitFontSize ?? 12,
            fontWeight: moneyFontWeight ?? FontWeight.bold,
          ),
        ),
        TextSpan(
          text: money,
          style: customerTextStyle(
            color: moneyColor ??const Color(0xff333333),
            fontSize: moneyFontSize ?? 20,
            fontWeight: unitFontWeight ?? FontWeight.bold,
          ),
        ),
        TextSpan(
          text: rightUnit ?? '',
          style: customerTextStyle(
            color: rightUnitColor ??const Color(0xff333333),
            fontSize: rightUnitFontSize ?? 12,
            fontWeight: rightUnitFontWeight ?? FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget customerHtmlWidget({
  required String html,
  Function? onTap,
}) {
  return HtmlWidget(
    html,
    textStyle: const TextStyle(
      letterSpacing: 1.5,
    ),
    onTapUrl: (url) {
      return onTap?.call(url);
    },
  );
}

///空白高度
Widget spaceHeight10Widget({double? height}) {
  return SizedBox(
    height: height?.h ?? 10.h,
  );
}

///空白宽度
Widget spaceWidth10Widget({double? width}) {
  return SizedBox(
    width: width?.w ?? 10.w,
  );
}
