import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///封装刷新加载pull_to_refresh控件
class PullRefreshListWidget extends StatelessWidget {
  final RefreshController controller;

  // final NullableIndexedWidgetBuilder itemBuilder;
  // final int itemCount;
  final bool enablePullUp;
  final bool enablePullDown;
  final bool shrinkWrap;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;

  // final EdgeInsetsGeometry? padding;
  final Widget? header;
  final Widget? footer;
  final Widget? placeholder;

  // final ScrollPhysics? physics;
  final bool isWhiteTheme;
  final Widget? child;

  const PullRefreshListWidget({
    Key? key,
    required this.controller,
    // required this.itemBuilder,
    // required this.itemCount,
    this.enablePullUp = false,
    this.enablePullDown = true,
    this.shrinkWrap = true,
    this.onRefresh,
    this.onLoading,
    // this.padding,
    this.header,
    this.footer,
    this.placeholder,
    // this.physics,
    this.isWhiteTheme = false,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: header ??
          ClassicHeader(
            releaseText: '松开刷新',
            refreshingText: '正在刷新...',
            completeText: '刷新成功',
            failedText: '刷新失败',
            idleText: '下拉刷新',
            textStyle:
                TextStyle(color: isWhiteTheme ? Colors.white : Colors.grey),
            idleIcon: Icon(Icons.arrow_downward,
                color: isWhiteTheme ? Colors.white : Colors.grey),
            failedIcon: Icon(Icons.error,
                color: isWhiteTheme ? Colors.white : Colors.grey),
            completeIcon: Icon(Icons.done,
                color: isWhiteTheme ? Colors.white : Colors.grey),
            releaseIcon: Icon(Icons.refresh,
                color: isWhiteTheme ? Colors.white : Colors.grey),
          ),
      footer: footer ??
          ClassicFooter(
            loadingText: '正在加载...',
            noDataText: '没有更多数据',
            idleText: '加载更多',
            failedText: '加载失败',
            canLoadingText: '松开加载更多',
            textStyle:
                TextStyle(color: isWhiteTheme ? Colors.white : Colors.grey),
            idleIcon: Icon(Icons.arrow_downward,
                color: isWhiteTheme ? Colors.white : Colors.grey),
            failedIcon: Icon(Icons.error,
                color: isWhiteTheme ? Colors.white : Colors.grey),
          ),
      enablePullDown: enablePullDown,
      enablePullUp: enablePullUp,
      controller: controller,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child ??
          Column(
            children: [
              Expanded(
                child: Container(
                  child: placeholder ?? const Text('暂无相关数据'),
                ),
              ),
            ],
          ),
    );
  }
}
