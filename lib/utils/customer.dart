import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:transparent_image/transparent_image.dart';




///字体样式
class CustomerTextStyle extends TextStyle {
  final Color? customerColor;
  final double? customerFontSize;
  final FontWeight? customerFontWeight;
  final TextDecoration? customerDecoration;
  final Color? customerDecorationColor;

  const CustomerTextStyle({
    this.customerFontSize,
    this.customerDecorationColor,
    this.customerFontWeight,
    this.customerDecoration,
    this.customerColor,
  }) : super(
          color: customerColor ?? const Color(0xff333333),
          fontSize: customerFontSize,
          fontWeight: customerFontWeight,
          decoration: customerDecoration,
          decorationColor: customerDecorationColor,
        );
}

///基础 Container
class CustomerContainer extends StatelessWidget {
  final Color? color;
  final double? borderRadius;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final Gradient? gradient;
  final DecorationImage? image;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;

  const CustomerContainer({
    super.key,
    this.color,
    this.borderRadius,
    this.child,
    this.padding,
    this.margin,
    this.height,
    this.gradient,
    this.image,
    this.onTap,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
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
}

///图片加载
class CustomerImagesNetworking extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? errorWidget;

  const CustomerImagesNetworking({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      key: Key(imageUrl),
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, object, s) {
        return Container(
          width: width,
          height: height,
          padding: EdgeInsets.all((width ?? 0) / 2),
          child: Center(
            child: Image.asset(
              'assets/images/noContainer.png',
              // width: width /2,
              // height: width /2,
              fit: fit ?? BoxFit.contain,
            ),
          ),
        );
      },
    );
    return imageUrl.contains('http') == true
        ? FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            width: width,
            height: height,
            image: imageUrl,
            fit: fit,
            placeholderErrorBuilder:
                (_, Object object, StackTrace? stackTrace) {
              return errorWidget ?? const SizedBox();
            },
            imageErrorBuilder: (_, Object object, StackTrace? stackTrace) {
              return errorWidget ?? const SizedBox();
            },
          )
        : errorWidget ?? const SizedBox();
  }
}

///money字体样式
class CustomerMoneyText extends StatelessWidget {
  final String money;
  final double? moneyFontSize;
  final Color? moneyColor;
  final FontWeight? moneyFontWeight;
  final String? unit;
  final double? unitFontSize;
  final Color? unitColor;
  final FontWeight? unitFontWeight;
  final String? rightUnit;
  final double? rightUnitFontSize;
  final Color? rightUnitColor;
  final FontWeight? rightUnitFontWeight;

  const CustomerMoneyText({
    super.key,
    required this.money,
    this.moneyFontSize,
    this.moneyColor,
    this.moneyFontWeight,
    this.unit,
    this.unitFontSize,
    this.unitColor,
    this.unitFontWeight,
    this.rightUnit,
    this.rightUnitFontSize,
    this.rightUnitColor,
    this.rightUnitFontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: unit ?? '',
            style: CustomerTextStyle(
              customerColor: unitColor ?? const Color(0xff333333),
              customerFontSize: unitFontSize ?? 12,
              customerFontWeight: unitFontWeight ?? FontWeight.bold,
            ),
          ),
          TextSpan(
            text: money,
            style: CustomerTextStyle(
              customerColor: moneyColor ?? const Color(0xff333333),
              customerFontSize: moneyFontSize ?? 20,
              customerFontWeight: moneyFontWeight ?? FontWeight.bold,
            ),
          ),
          TextSpan(
            text: rightUnit ?? '',
            style: CustomerTextStyle(
              customerColor: rightUnitColor ?? const Color(0xff333333),
              customerFontSize: rightUnitFontSize ?? 12,
              customerFontWeight: rightUnitFontWeight ?? FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

///Html widget
class CustomerHtmlWidget extends StatelessWidget {
  final String html;
  final Function? onTap;

  const CustomerHtmlWidget({
    super.key,
    required this.html,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
      data: """
        <h1>Hello, World!</h1>
        <p><span style="font-style:italic;">flutter_html</span> supports a variety of HTML and CSS tags and attributes.</p>
        <p>Over a hundred static tags are supported out of the box.</p>
        <p>Or you can even define your own using an <code>Extension</code>: <flutter></flutter></p>
        <p>Its easy to add custom styles to your Html as well using the <code>Style</code> class:</p>
        <p class="fancy">Here's a fancy &lt;p&gt; element!</p>
        """,
      extensions: [
        TagExtension(
          tagsToExtend: {"flutter"},
          child: const FlutterLogo(),
        ),
      ],
      style: {
        "p.fancy": Style(
          textAlign: TextAlign.center,
          // padding:  EdgeInsets.all(),
          backgroundColor: Colors.grey,
          margin: Margins(left: Margin(50, Unit.px), right: Margin.auto()),
          width: Width(300, Unit.px),
          fontWeight: FontWeight.bold,
        ),
      },
    );
    // return Html(
    //   data:  html,
    //   textStyle: const TextStyle(
    //     letterSpacing: 1.5,
    //   ),
    //   onTapUrl: (url) {
    //     return onTap?.call(url);
    //   },
    // );
  }
}
