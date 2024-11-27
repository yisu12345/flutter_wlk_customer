import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wlk_customer/utils/customer.dart';
import 'package:flutter_wlk_customer/value/string.dart';

///商品文字标题
class GoodsEditeTitleWidget extends StatelessWidget {
  final String title;
  final TextStyle? style;
  final String? hint; //灰色提示
  final bool? isRed; //是否有红点
  final Widget? rightChild;
  final Widget? contentChild;

  const GoodsEditeTitleWidget({
    super.key,
    required this.title,
    this.hint,
    this.isRed,
    this.rightChild,
    this.contentChild,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key(BaseStringValue.cellKeyString(string: title)),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: style ??
                  CustomerTextStyle(
                    customerFontSize: 30.sp,
                    customerFontWeight: FontWeight.bold,
                  ),
            ),
            isRed == true
                ? Text(
                    ' * ',
                    textAlign: TextAlign.start,
                    style: CustomerTextStyle(
                      customerColor: Colors.red,
                      customerFontSize: 20.sp,
                      customerFontWeight: FontWeight.bold,
                    ),
                  )
                : const SizedBox(),
            Text(
              hint ?? '',
              textAlign: TextAlign.start,
              style: CustomerTextStyle(
                customerColor: const Color(0xff777777),
                customerFontSize: 24.sp,
              ),
            ),
            const Expanded(child: SizedBox()),
            rightChild ?? const SizedBox(),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
          child: contentChild ?? const SizedBox(),
        ),
      ],
    );
  }
}

///
class GoodsEditeContentWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? height;
  final Color? backColor;
  final VoidCallback? onTap;

  const GoodsEditeContentWidget({
    super.key,
    this.child,
    this.padding,
    this.borderRadius,
    this.height,
    this.backColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        padding: padding ?? const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius?.h ?? 30.h),
        ),
        child: child ?? const SizedBox(),
      ),
    );
  }
}

///输入框
class GoodsEditeTextFiled extends StatefulWidget {
  final String? hint;
  final TextInputType? keyboardType;
  final String? prefixText;
  final String? suffixText;
  final int? maxLines;
  final Function? onChanged;
  final String? content;
  final double? borderRadius;
  final double? height;
  final bool? obscureText;
  final bool? readOnly;
  final Color? backColor;
  final int? maxNumberText;
  final bool? hadOver; //是否必须输入才返回，默认是false
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;

  const GoodsEditeTextFiled({
    super.key,
    this.hint,
    this.keyboardType,
    this.prefixText,
    this.suffixText,
    this.maxLines,
    this.onChanged,
    this.content,
    this.borderRadius,
    this.obscureText = false,
    this.height,
    this.readOnly = false,
    this.backColor,
    this.maxNumberText,
    this.hadOver = false,
    this.textInputAction,
    this.textAlign,
  });

  @override
  State<GoodsEditeTextFiled> createState() => _GoodsEditeTextFiledState();
}

class _GoodsEditeTextFiledState extends State<GoodsEditeTextFiled> {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    controller = TextEditingController(text: widget.content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoodsEditeContentWidget(
      padding: EdgeInsets.zero,
      backColor: widget.backColor,
      borderRadius: widget.borderRadius,
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          TextField(
            textAlign: widget.textAlign ?? TextAlign.start,
            controller: controller,
            focusNode: focusNode,
            maxLength: widget.maxNumberText,
            // textInputAction: TextInputAction.done,
            maxLines: widget.maxLines,
            style: CustomerTextStyle(
              customerFontSize: 28.sp,
            ),
            readOnly: widget.readOnly ?? false,
            obscureText: widget.obscureText ?? false,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            textInputAction: widget.textInputAction ?? TextInputAction.done,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                ///设置边框四个角的弧度
                // borderRadius: BorderRadius.all(
                //   Radius.circular(
                //     12.5,
                //   ),
                // ),
                borderSide: BorderSide.none,
              ),
              counterText: '',
              contentPadding: const EdgeInsets.all(0),
              hintText: widget.hint ?? '',
              hintStyle: CustomerTextStyle(
                customerColor: const Color(0xffAAAAAA),
                customerFontSize: 28.sp,
              ),
              prefixText: widget.prefixText ?? '    ',
              prefixStyle: CustomerTextStyle(
                customerFontSize: 28.sp,
              ),
            ),
            onEditingComplete: () {
              widget.onChanged?.call(controller.text);
            },
            onSubmitted: widget.hadOver == true
                ? (value) {
                    focusNode.unfocus();
                    widget.onChanged?.call(value);
                  }
                : (value) {
                    focusNode.unfocus();
                  },
            onChanged: widget.hadOver == true
                ? null
                : (value) => widget.onChanged?.call(value),
          ),
          widget.maxNumberText == null
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(bottom: 20.h, right: 30.w),
                  child: Text(
                    '${controller.text.length}/${widget.maxNumberText}',
                    style: CustomerTextStyle(
                      customerFontSize: 28.sp,
                      customerColor: const Color(0xffCCCCCC),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
