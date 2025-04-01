import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FrostedGlassEffectWidget extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Widget? backgroundChild;
  final Color? backgroundColor;

  const FrostedGlassEffectWidget({
    super.key,
    this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundChild,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // 背景内容（可以放图片或其他内容）
          backgroundChild ?? SizedBox(),
          // 毛玻璃效果
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius ?? 20.h),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10.0,
                sigmaY: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(borderRadius ?? 20.h),
                ),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
