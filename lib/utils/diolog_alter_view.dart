import 'package:flutter/material.dart';

///弹窗widget
///ctx  showDialog context
///padding 位置
class ShowDialogWidget extends StatelessWidget {
  final BuildContext? ctx;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final ScrollController? scrollController;

  const ShowDialogWidget({
    super.key,
    this.ctx,
    required this.child,
    required this.padding,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: ctx == null ? null : () => Navigator.pop(ctx!),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Padding(
              padding: padding,
              child: SingleChildScrollView(
                controller: scrollController,
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
